import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_news/model/news_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:world_news/Screen/fullNews.dart';

class List_of_Favorits extends StatefulWidget {
  const List_of_Favorits({super.key});

  @override
  State<List_of_Favorits> createState() => ReadList_of_Favorits();
}

class ReadList_of_Favorits extends State<List_of_Favorits> {
  final List lst_F = [];
  var lf ="ListFavorits";


  _getListOfFavorits() async {
    var hubs = await SharedPreferences.getInstance();

    var keys = hubs.getStringList(lf);
    if(keys == null)
      keys =[];

    for( int i=0;i<keys!.length;i++){
      var string_of_hubs = hubs.getString(keys!.elementAt(i));
      if(string_of_hubs != null) {
        var model_hubs = News_model.fromJson(json.decode(string_of_hubs));
        lst_F.add(model_hubs);
      }
    }
    return lst_F;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getListOfFavorits(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if(lst_F.length == 0){
              return Container(
                alignment: Alignment.center,
                child: Text("Избранных статей нет", style: TextStyle(color: Colors.grey)),
              );
            } else {
              return Container(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  scrollDirection: Axis.vertical,
                  itemCount: lst_F.length,
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
                                    '${lst_F[index].title}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FloatingActionButton.extended(
                                      heroTag: null,
                                      onPressed: () =>
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullNews(
                                                          urlNews:
                                                          '${lst_F[index]
                                                              .news_url}'))),
                                      label: Text('Читать'),
                                      icon: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                )
                              ],
                            )
                        )
                    );
                  },
                ),
              );
            }
        }
        }
    );
  }

}