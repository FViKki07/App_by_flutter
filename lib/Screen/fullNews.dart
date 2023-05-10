import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_news/model/news_model.dart';
//import 'package:world_news/common/fetch_http_rambler.dart';

class FullNews extends StatefulWidget {
  final urlNews;

  FullNews({@required this.urlNews});

  @override
  _ReadFullNews createState() => _ReadFullNews();
}

class _ReadFullNews extends State<FullNews> {
  var _newModel = News_model();
  String? _keyNews;
  Color _colorFavorite = Colors.white;
  int i = 0;

  void _addFavorite() async {
    var hubs = await SharedPreferences.getInstance();

    if(_colorFavorite == Colors.white) {
      _colorFavorite = Colors.yellow;
      await _setFavorits();
      i = 1;
    }

    if(i == 2 && _colorFavorite == Colors.yellow) {
      await hubs.remove(_keyNews!);
      _colorFavorite = Colors.white;
      i = 0;
    }

    setState(() {
    });

    i = 2;
  }

  Future _setFavorits() async {
    var hubs = await SharedPreferences.getInstance();
    hubs.setString(_keyNews!, json.encode(_newModel));
  }

  Future _getFavorits() async {
    i+=1;
    var hubs = await SharedPreferences.getInstance();
    final hubsInfo= hubs.getString(_keyNews!);
    //print(hubsInfo);
    if(hubsInfo == null) return null;
    return News_model.fromJson(json.decode(hubsInfo));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: ()=> Navigator.pop(context),
          ),
          title: Text('News'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.star),
              focusColor: Colors.orange.withOpacity(0.3),
              color: _colorFavorite,
              tooltip: 'Add to favorite',
              onPressed: _addFavorite,
            ),
          ],
        ),
        body: _getNews()
      );
  }

  _getNews(){
    return FutureBuilder(
      future: _getHttpNews(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else{
          return ListView(
            padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 40.0),
            children: [
              Text('${_newModel.title}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0,),
              Text('${_newModel.body}', style: TextStyle(fontSize: 18.0 ),)
            ],
          );
        }
      });
  }

  _getHttpNews() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(widget.urlNews));
    var _news = parse(response.body);
    _newModel.title = _news.getElementsByClassName('tm-title tm-title_h1')[0].text;
    _keyNews = _newModel.title;
    //print(_news.getElementsByClassName('tm-title tm-title_h1')[0]!.text);
    var body =_news.getElementById("post-content-body")!.children[0].text;
    _newModel.body = body;
    _newModel.news_url = widget.urlNews;

    if(i == 0) {
      var hubs = await _getFavorits();
      if (hubs != null && _colorFavorite == Colors.white) {
        _colorFavorite = Colors.yellow;
        _addFavorite();
      }
    }

    return _newModel;
  }
}