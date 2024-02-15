import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scrapping_sample/bottomNavigationBar/trending_books.dart';
import 'package:web_scrapping_sample/profleinfo/profile_info.dart';

class YourLibrary extends StatelessWidget {
  final List<TrendBooks> favoriteBooks;
  const YourLibrary({super.key, required this.favoriteBooks});

  @override
  Widget build(BuildContext context) {
    var favoriteBooksModel = context.watch<FavoriteBooksModel>();
    var favoriteBooks = favoriteBooksModel.favoriteBooks;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
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
                  )))
        ],
        centerTitle: true,
        title: Text(
          "YOUR LİBRARY",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
      ),
      backgroundColor: Colors.grey[700],
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.43,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey[900],
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        favoriteBooks[index].image,
                      ),
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
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Kitap ismi: " + favoriteBooks[index].kitapAdi,
                  style: _style()
                ),
                SizedBox(height: 8),
                Text(
                  "Yayınevi:  " + favoriteBooks[index].yayinEvi,
                  style: _style(),
                ),
                SizedBox(height: 8),
                Text(
                  favoriteBooks[index].yazar,
                  style: _style(),
                ),
                SizedBox(height: 8),
                Text(
                  favoriteBooks[index].fiyat,
                  style: _style(),
                )
              ],
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
    fontSize: 16,
  );
}
