import 'package:flutter/material.dart';

class Categoria{
  String? title;
  String? description;
  String? link;
  String? rating;
  String? subscribers;

  Categoria( { this.title, this.description, this.link, this.rating, this.subscribers});

  Map<String, dynamic> toJson() => {
    'title': title,
    'description' : description,
    'link' : link,
    'rating' : rating,
    'subscribers' : subscribers
  };

  Categoria.fromJson(Map<String, dynamic> json):
        title = json['title'],
        description = json['description'],
        link = json['link'],
        rating = json['rating'],
        subscribers = json['subscribers'];

}