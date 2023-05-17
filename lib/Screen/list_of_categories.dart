import 'package:flutter/material.dart';
import 'package:world_news/Screen/home_page.dart';

class List_of_categories extends StatefulWidget {
  final title_categories;
  final url_categories;

  List_of_categories({@required this.title_categories, @required this.url_categories});

  @override
  _ReadCateg createState() => _ReadCateg();
}

class _ReadCateg extends State<List_of_categories> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text('${widget.title_categories}'),
        centerTitle: true,
      ),
        body: Home_Page(link_page: '${widget.url_categories}'),
    );
  }
}