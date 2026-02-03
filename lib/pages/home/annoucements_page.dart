import 'package:flutter/material.dart';
import '../../components/z_annoucement_card.dart';

import '../../models/announcement_aggr.dart';

class AnnoucementsPage extends StatefulWidget {
  const AnnoucementsPage({Key? key, required this.announcements}) : super(key: key);
  final List<Announcement> announcements;

  @override
  State<AnnoucementsPage> createState() => _AnnoucementsPageState();
}

class _AnnoucementsPageState extends State<AnnoucementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.announcements.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0) SizedBox(height: 8),
                ZAnnoucementCard(announcement: widget.announcements[index]),
                if (index == widget.announcements.length - 1) SizedBox(height: 8),
              ],
            )),
      ),
    );
  }
}
