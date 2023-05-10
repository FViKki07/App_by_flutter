import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';
import 'package:world_news/Screen/fullNews.dart';

class Home_Page{
  final List _ramblerlist = [];
  var link_page;

  Home_Page({this.link_page});

  _getNewFromRambler() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(link_page));
    var chanel = RssFeed.parse(response.body);
    chanel.items?.forEach((element) {
      _ramblerlist.add(element);
    });

    return _ramblerlist;
  }

  Widget returnHomePage() {
    return FutureBuilder(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Text(
                                      '${_ramblerlist[index].title.trim()}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
