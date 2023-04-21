import 'package:flutter/material.dart';
import 'package:world_news/Screen/news.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "World News",
      home: HomeScreen(),
    );

  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 50), primary: Colors.blue, onSurface: Colors.white);
    return  Scaffold(
        appBar: AppBar(
          title:
          const Text("Мировые новости", style: TextStyle(fontSize: 30, color: Colors.black)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueGrey],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body:Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/2.jpg"),
                  fit: BoxFit.cover),),
            child:Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      style: style,
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> News() ));
                      },
                      child: const Text('Новости'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: style,
                      onPressed: null,
                      child: const Text('Мир'),
                    ),
                  ],
                ))
        ));
  }
}
