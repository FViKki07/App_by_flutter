import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

//import 'package:world_news/common/fetch_http_rambler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:world_news/Screen/fullNews.dart';
import 'package:world_news/Screen/categories.dart';
import 'package:world_news/Screen/home_page.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => NewsFull();
}

class NewsFull extends State<News> {
  var _indexPage = 0;

  List<Widget> _pages = <Widget>[
    Home_Page().returnHomePage(),
    Categories().returnCategories(),
    Scaffold(
      body: Center(child: Text("Избранное")),
    )
  ];

  void _choicePage(int page) {
    setState(() {
      _indexPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Главная",
              style: TextStyle(color: Colors.white, fontSize: 30)),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        body: _pages.elementAt(_indexPage),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Категории"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Избранное")
          ],
          currentIndex: _indexPage,
          fixedColor: Colors.blue,
          onTap: _choicePage,
        ),
      ),
    );
  }
}
