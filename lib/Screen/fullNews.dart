import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:world_news/model/news_model.dart';
import 'package:world_news/common/fetch_http_rambler.dart';

class FullNews extends StatefulWidget {
  final urlNews;

  FullNews({@required this.urlNews});

  @override
  _ReadFullNews createState() => _ReadFullNews();
}

class _ReadFullNews extends State<FullNews> {
  var _newModel = News_model();

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
    _newModel.title = _news.getElementsByClassName('article__header')[0].children[0]!.text;
    var body = _news.getElementsByClassName('article__text');//[0].children;//getElementsByClassName('article__text')[0]!.text;
    String text = "";
    for( int i=0; i<body.length;i++){
      text += body[i]!.text + "\n\n";
    }
    _newModel.body = text;
    _newModel.news_url = widget.urlNews;
    
    return _newModel;
  }
}