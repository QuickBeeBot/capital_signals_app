import 'package:flutter/material.dart';
import '../../models/news_aggr.dart';

import '../../components/z_news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key, required this.news}) : super(key: key);
  final List<News> news;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.news.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0) SizedBox(height: 8),
                ZNewsCard(news: widget.news[index]),
                if (index == widget.news.length - 1) SizedBox(height: 8),
              ],
            )),
      ),
    );
  }
}
