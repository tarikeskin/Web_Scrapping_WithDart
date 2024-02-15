import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scrapping_sample/kitap.dart';
import 'package:web_scrapping_sample/profleinfo/profile_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = Uri.parse(
      "https://www.kitapyurdu.com/index.php?route=product/category&filter_category_all=true&path=1_2&sort=publish_date&order=DESC");
  List<Kitap> kitaplar = [];
  bool isLoading = false;

  Future getData() async {
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
        kitaplar.add(Kitap(
          image: element
              .children[2].children[0].children[0].children[0].attributes['src']
              .toString(),
          kitapAdi: element.children[3].text.toString(),
          yayinEvi: element.children[4].text.toString(),
          yazar: element.children[5].text.toString(),
          fiyat: element.children[8].text.toString(),
        ));
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              size: 40,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          "CHİLD BOOKS",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[700],
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.43,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1),
              itemCount: kitaplar.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: .0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
                              child: Image.network(kitaplar[index].image),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kitap İsmi: ${kitaplar[index].kitapAdi} ",
                          style: _style(),
                        ),
                        Text(
                          "Kitap yayınevi: ${kitaplar[index].yayinEvi} ",
                          style: _style(),
                        ),
                        Text(
                          "Kitap yazarı: ${kitaplar[index].yazar} ",
                          style: _style(),
                        ),
                        Text(
                          "Kitap fiyatı: ${kitaplar[index].fiyat}  ",
                          style: _style(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
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
