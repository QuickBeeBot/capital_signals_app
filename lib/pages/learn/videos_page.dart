import 'package:flutter/material.dart';
import '../../models/video_lesson_aggr.dart';

import 'learn_page.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key, required this.videos}) : super(key: key);
  final List<VideoLesson> videos;

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.videos.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0) SizedBox(height: 8),
                VideoCard(videoLesson: widget.videos[index]),
                if (index == widget.videos.length - 1) SizedBox(height: 8),
              ],
            )),
      ),
    );
  }
}
