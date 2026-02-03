import 'package:flutter/material.dart';
import 'z_card.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../utils/z_format.dart';
import '../../utils/z_launch_url.dart';
import '../models/announcement_aggr.dart';

class ZAnnoucementCard extends StatelessWidget {
  const ZAnnoucementCard({super.key, required this.announcement});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return ZCard(
        onTap: () {
          if (announcement.link != '') ZLaunchUrl.launchUrl(announcement.link);
        },
        borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ZFormat.dateFormatSignal(announcement.timestampCreated)}',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  Text(announcement.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(
                    announcement.body,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                ],
              ),
            ),
            if (announcement.image != '')
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZImageDisplay(
                      image: announcement.image,
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.width * .2,
                      borderRadius: BorderRadius.circular(8),
                    )
                  ],
                ),
              ),
          ],
        ));
  }
}
