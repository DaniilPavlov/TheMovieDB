import 'package:flutter/material.dart';

class NewsListWidget extends StatefulWidget {
  const NewsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  List<Image> images = [
    Image.network(
      'https://pbs.twimg.com/media/D9MPesKXoAEhtdt.jpg:large',
      filterQuality: FilterQuality.high,
    ),
    Image.network(
      'https://avatars.mds.yandex.net/get-kinopoisk-blog-post-thumb/40130/59fdb7199d77ef1505da63f4d8581318/orig',
      filterQuality: FilterQuality.high,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: ListView(
        children: images,
      ),
    );
  }
}