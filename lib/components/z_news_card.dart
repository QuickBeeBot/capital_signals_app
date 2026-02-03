import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'z_card.dart';
import '../models/news_aggr.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../utils/z_format.dart';
import '../pages/_app/render_html_url_page.dart';

class ZNewsCard extends StatelessWidget {
  const ZNewsCard({super.key, required this.news});
  final News news;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
        child: ZCard(
            borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
            onTap: () => Get.to(() => RenderHTMLUrlPage(url: news.url), fullscreenDialog: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(news.site.toUpperCase()),
                    Text(
                      '${ZFormat.dateFormatSignal(news.publishedDate)}',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 11),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.625,
                      child: Text(
                        news.text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    ZImageDisplay(
                      image: news.image,
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.width * .2,
                      borderRadius: BorderRadius.circular(8),
                    )
                  ],
                ),
              ],
            )));
  }
}
