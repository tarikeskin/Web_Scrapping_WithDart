import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:web_scrapping_sample/bottomNavigationBar/home_page.dart';
import 'package:web_scrapping_sample/bottomNavigationBar/trending_books.dart';
import 'package:web_scrapping_sample/bottomNavigationBar/your_library.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => FavoriteBooksModel(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;
  List<TrendBooks> favoriteBooks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey.shade400,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: "Child Books ",
            selectedIcon: Icon(
              Icons.home,
              size: 30,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_sharp),
            label: "Your Libary",
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_sharp),
            label: "Trending Books",
          ),
        ],
      ),
      body: <Widget>[
        HomePage(),
        YourLibrary(favoriteBooks: favoriteBooks),
        TrendingBooks(),
      ][currentPageIndex],
    );
  }
}
