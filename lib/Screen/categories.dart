import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:world_news/model/categories_model.dart';
import 'package:world_news/Screen/list_of_categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => ReadCategories();
}

class ReadCategories extends State<Categories> {
  List<Categoria> list_cat = [];
  var lC = "ListCategories"; //keys for Map of categories

  Future<List<Categoria>> _addCategories() async {
    var hubs = await SharedPreferences.getInstance();
    var list_categories = hubs.getStringList(lC);

    if(list_categories == null) {
      await _setCategories();
      return list_cat;
    }
    else{
      await _getCategories();
      Future((){
        print('Running the Future');
        _setCategories();
      });
      return list_cat;

    }
  }

  Future _setCategories() async {
    var hubs = await SharedPreferences.getInstance();
    List<String> list_new_categ = [];
    var client = http.Client();
    var response = await client.get(Uri.parse("https://habr.com/ru/hubs/"));
    var _news = parse(response.body);
    var _cat = _news.getElementsByClassName("tm-hubs-list")[0].children;
    print(_cat.length);
    RegExp regex = new RegExp('href="(.*?)"');
    RegExp regex2 = new RegExp('href="https://habr.com/ru/rss/.*?" type="application/rss\\+xml"');


    for (int i = 0; i < _cat.length; i++) {
      var newModel = Categoria();
      newModel.title = _cat[i].getElementsByClassName("tm-hub__title")[0].text;
      newModel.description =
          _cat[i].getElementsByClassName("tm-hub__description")[0].text;

      var match = regex.firstMatch(
          _cat[i].getElementsByClassName("tm-hub__userpic-link")[0].outerHtml);
      var link_cat = match?.group(0);
      link_cat = link_cat!.substring(6, link_cat.length - 1);
      response = await client.get(Uri.parse("https://habr.com"+link_cat));
      _news = parse(response.body);
      var match2 = regex2.firstMatch(_news.outerHtml);
      var cc = match2?.group(0);
      var rss_link = cc!.substring(6,cc.length - 28);
      newModel.link = rss_link;

      newModel.rating = _cat[i]
          .getElementsByClassName("tm-hubs-list__hub-rating")[0]
          .text
          .trim() + "  ";
      newModel.subscribers = _cat[i]
          .getElementsByClassName("tm-hubs-list__hub-subscribers")[0]
          .text
          .trim();
      list_cat.add(newModel);

      if( newModel.title != null) {
        list_new_categ.add(newModel.title!);
        hubs.setString(newModel.title!, json.encode(newModel));
      }

    }
    hubs.setStringList(lC, list_new_categ);
  }

  Future _getCategories() async {
    var hubs = await SharedPreferences.getInstance();
    final hubsInfo= hubs.getStringList(lC);
    List<Categoria> ll = [];
    //print(hubsInfo);
    if(hubsInfo == null) return null;
    for(int i = 0; i< hubsInfo!.length;i++) {
      var categ = hubs.getString(hubsInfo.elementAt(i));
      ll.add(Categoria.fromJson(json.decode(categ!)));
    }
    list_cat = ll;
    return list_cat;
  }

  _getCategoris() async {
    var client = http.Client();
    var response = await client.get(Uri.parse("https://habr.com/ru/hubs/"));
    var _news = parse(response.body);
    var _cat = _news.getElementsByClassName("tm-hubs-list")[0].children;
    //print(_cat[0].text);
    print(_cat.length);
    //RegExp regex = new RegExp('(?<=src = ").*?(? = ")');
    RegExp regex = new RegExp('href="(.*?)"');
    //print(_cat[0].getElementsByClassName("tm-hub__description")[0].text);
    //print(_cat[0].getElementsByClassName("tm-hub__userpic-link")[0].outerHtml);
    //print(_cat[0].getElementsByClassName("tm-hubs-list__hub-rating")[0].text);
    //print(_cat[0].getElementsByClassName("tm-hubs-list__hub-subscribers")[0].text);
    RegExp regex2 = new RegExp('href="https://habr.com/ru/rss/.*?" type="application/rss\\+xml"');
   /* var match = regex.firstMatch(
        _cat[1].getElementsByClassName("tm-hub__userpic-link")[0].outerHtml);
    var link_cat = match?.group(0);
    link_cat = link_cat!.substring(6, link_cat.length - 1);

    response = await client.get(Uri.parse("https://habr.com"+link_cat));
    _news = parse(response.body);
    var html_categ = _news.outerHtml;
    var match2 = regex2.firstMatch(_news.outerHtml);
    var cc = match2?.group(0);
    var rss_link = cc!.substring(6,cc.length - 28);
    //print(cc);
    print(rss_link);*/

    for (int i = 0; i < _cat.length; i++) {
      var newModel = Categoria();
      newModel.title = _cat[i].getElementsByClassName("tm-hub__title")[0].text;
      newModel.description =
          _cat[i].getElementsByClassName("tm-hub__description")[0].text;

      var match = regex.firstMatch(
          _cat[i].getElementsByClassName("tm-hub__userpic-link")[0].outerHtml);
      var link_cat = match?.group(0);
      link_cat = link_cat!.substring(6, link_cat.length - 1);
      response = await client.get(Uri.parse("https://habr.com"+link_cat));
      _news = parse(response.body);
      var match2 = regex2.firstMatch(_news.outerHtml);
      var cc = match2?.group(0);
      var rss_link = cc!.substring(6,cc.length - 28);
      newModel.link = rss_link;

      newModel.rating = _cat[i]
          .getElementsByClassName("tm-hubs-list__hub-rating")[0]
          .text
          .trim() + "  ";
      newModel.subscribers = _cat[i]
          .getElementsByClassName("tm-hubs-list__hub-subscribers")[0]
          .text
          .trim();
      list_cat.add(newModel);
    }
    return list_cat;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _addCategories(),
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
                  itemCount: list_cat.length,
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
                              Text('${list_cat[index].title}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('${list_cat[index].description}',
                                  style: TextStyle(
                                      fontSize: 13.0)),
                              SizedBox(
                                height: 13.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                     // mainAxisAlignment:
                                        //  MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.bar_chart_outlined,
                                              color: Colors.blueAccent,
                                            ),
                                            Text('${list_cat[index].rating}')
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: Colors.blueAccent,
                                            ),
                                            Text(
                                                '${list_cat[index].subscribers}')
                                          ],
                                        ),
                                      ]),
                                  FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>  List_of_categories(title_categories: '${list_cat[index].title}', url_categories: '${list_cat[index].link}'))),
                                              //Home_Page(link_page: '${list_cat[index].link}').returnHomePage())),
                                    label: Text('Перейти'),
                                    icon: Icon(Icons.arrow_forward),
                                  )
                                ],
                              )
                            ],
                          )),
                    );
                  }),
            );
            ;
          }
        });
  }
}

