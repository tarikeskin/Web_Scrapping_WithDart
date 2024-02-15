import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_scrapping_sample/profleinfo/profile_info.dart';

class TrendingBooks extends StatefulWidget {
  const TrendingBooks({super.key});

  @override
  State<TrendingBooks> createState() => _TrendingBooksState();
}

class _TrendingBooksState extends State<TrendingBooks> {
  var url = Uri.parse(
      "https://www.kitapyurdu.com/index.php?route=product/best_sellers&list_id=16");
  var data;
  List<TrendBooks> trendbooks = [];
  bool isLoading = false;

  Future streamData() async {
    setState(() {
      isLoading = true;
    });

    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

    var response = document
        .getElementsByClassName("product-grid")[0]
        .getElementsByClassName("product-cr")
        .forEach((element) {
      setState(() {
        trendbooks.add(
          TrendBooks(
            image: element.children[3].children[0].children[0].children[0]
                .attributes["src"]
                .toString(),
            kitapAdi: element.children[4].text.toString(),
            yayinEvi: element.children[5].text.toString(),
            yazar: element.children[6].text.toString(),
            fiyat: element.children[9].text.toString(),
          ),
        );
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    streamData();
    loadFavoriteState();
  }

  void loadFavoriteState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      trendbooks.forEach((book) {
        book.isFavorite = prefs.getBool(book.kitapAdi) ?? false;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileInfo(),
                ),
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          "TRENDİNG BOOKS",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ChangeNotifierProvider.value(
                value: context.read<FavoriteBooksModel>(),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.43,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: trendbooks.length,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 6,
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(trendbooks[index].image),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Kitap ismi: ${trendbooks[index].kitapAdi}",
                            style: _style(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Kitap Yayınevi: ${trendbooks[index].yayinEvi}",
                            style: _style(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${trendbooks[index].yazar}",
                            style: _style(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${trendbooks[index].fiyat}",
                            style: _style(),
                          ),
                          Center(
                            child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  trendbooks[index].isFavorite =
                                      !trendbooks[index].isFavorite;
                                });
                                var favoriteBooksModel =
                                    context.read<FavoriteBooksModel>();
                                if (trendbooks[index].isFavorite) {
                                  favoriteBooksModel
                                      .addFavorite(trendbooks[index]);
                                } else {
                                  favoriteBooksModel
                                      .removeFavorite(trendbooks[index]);
                                }
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool(trendbooks[index].kitapAdi, trendbooks[index].isFavorite);
                              },
                              icon: Icon(
                                trendbooks[index].isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

TextStyle _style() {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
}

class TrendBooks {
  String image;
  String kitapAdi;
  String yayinEvi;
  String yazar;
  String fiyat;
  bool isFavorite;
  TrendBooks({
    required this.image,
    required this.kitapAdi,
    required this.yayinEvi,
    required this.yazar,
    required this.fiyat,
    this.isFavorite = false,
  });
}

class FavoriteBooksModel extends ChangeNotifier {
  List<TrendBooks> favoriteBooks = [];

  void addFavorite(TrendBooks book) {
    favoriteBooks.add(book);
    notifyListeners();
  }

  void removeFavorite(TrendBooks book) {
    favoriteBooks.remove(book);
    notifyListeners();
  }
}
