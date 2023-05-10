
class News_model {
  String? title;
  String? news_url;
  String? body;

  News_model({this.title, this.news_url, this.body });

  Map<String, dynamic> toJson() => {
    'title': title,
    'news_url': news_url,
    'body' : body
  };

  News_model.fromJson(Map<String, dynamic> json):
      title = json['title'],
      news_url = json['news_url'],
      body = json['body'];

}