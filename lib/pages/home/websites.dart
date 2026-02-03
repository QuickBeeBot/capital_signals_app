import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';
import '../../models/post_aggr.dart';
import '../../models/video_lesson_aggr.dart';
import '../../models_providers/app_provider.dart';
import '../../utils/z_format.dart';
import '../../theme/colors.dart';
import '../../widgets/avatar_image.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../utils/z_launch_url.dart';
import '../../pages/learn/promos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebsitesList extends StatefulWidget {
  const WebsitesList({super.key});

  @override
  State<WebsitesList> createState() => _WebsitesListState();
}

class _WebsitesListState extends State<WebsitesList> {


  final db = FirebaseFirestore.instance;
  Future getListData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("promos").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return StreamBuilder<QuerySnapshot>(
        stream: db.collection("websites").orderBy('postDate', descending: true).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasData){
            return SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs.map((doc) {
                  return GestureDetector(
                    onTap: (){
                      ZLaunchUrl.launchUrl(doc["link"]);
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(10),
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                AvatarImage(doc["image"],
                                  isSVG: false,
                                  width: 60, height: 60,
                                ),
                                SizedBox(height: 10,),
                                Text(doc["name"], maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        )
                    ),
                  );

                  /*Card(child: ListTile(
                    title: Text(doc['title']),
                  ),
                  );*/
                }).toList(),
              ),
            );
          } else if(snapshot.hasError){
            return Text("data");
          }
          else {
            return Text("data");
          }
        });
  }
}
