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
import 'package:world_news/Screen/list_of_favorits.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => NewsFull();
}

class NewsFull extends State<News> {
  var _indexPage = 0;
  final List<String> _name_page = ["Главная","Категории","Избранное"];

  /*List<Widget> _pages = <Widget>[
    Home_Page(link_page: 'https://habr.com/ru/rss/all/all/?fl=ru').returnHomePage(),
    Categories().returnCategories(),
    List_of_Favorits().getWidgetWithList()
  ];*/
  final _pages = <Widget>[
     Home_Page(link_page: 'https://habr.com/ru/rss/all/all/?fl=ru'),
    Categories(),
    List_of_Favorits()
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
          title: Text(_name_page.elementAt(_indexPage),
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
