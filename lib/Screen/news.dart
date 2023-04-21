import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:world_news/common/fetch_http_rambler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:world_news/Screen/fullNews.dart';

class News extends StatelessWidget {
  final List _ramblerlist = [];
  var _currentPage = 0;

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
        body: FutureBuilder(
          future: _getNewFromRambler(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                    scrollDirection: Axis.vertical,
                    itemCount: _ramblerlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Text('${_ramblerlist[index].title}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('dd.mm.yyyy kk.mm').format(
                                        DateTime.parse(
                                            '${_ramblerlist[index].pubDate}'))),
                                    FloatingActionButton.extended(
                                      heroTag: null,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullNews(
                                                  urlNews:
                                                      '${_ramblerlist[index].link}'))),
                                      label: Text('Читать'),
                                      icon: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                )
                              ],
                            )),
                      );
                    }),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: "Категории"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Избранное")
          ],
          currentIndex: _currentPage,
          fixedColor: Colors.blue,
          onTap: null,
        ),
      ),
    );
  }

  _getNewFromRambler() async {
    var client = http.Client();
    var response =
        await client.get(Uri.parse('http://www.ria.ru/export/rss2/index.xml'));
    var chanel = RssFeed.parse(response.body);
    print(chanel.items == null);
    chanel.items?.forEach((element) {
      _ramblerlist.add(element);
    });

    return _ramblerlist;
  }
}
