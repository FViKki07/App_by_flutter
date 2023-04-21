import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Categories{

  Widget returnCategories(){
    return FutureBuilder(
        future: _getCategoris(),
        builder: (context, AsyncSnapshot snapshot){
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else{
          return Scaffold(body: Text("Categories"),);
          }
    });
  }

   _getCategoris() async {
     var client = http.Client();
     var response = await client.get(Uri.parse("https://ria.ru"));
     var _news = parse(response.body);
     print(_news);
     var list_cat = _news.getElementsByClassName("content")[0].getElementsByClassName("section__content");//[0].getElementsByClassName("the-in-carousel__frame m-scroll");
     print(list_cat.length);
     for(int i = 0; i< list_cat.length ;i++){
       print(list_cat[i].children[0].children[0]!.text);
     }
   }

}

  /* return Scaffold(
       body: Center(
       child: Text("Categories"),
       )
   );*/
