import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';
import '../../models/post_aggr.dart';
import '../../models/video_lesson_aggr.dart';
import '../../models_providers/app_provider.dart';
import 'post_details_page.dart';
import 'posts_page.dart';
import 'videos_page.dart';
import '../../utils/z_format.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../utils/z_launch_url.dart';
import '../../pages/learn/promos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromosList extends StatefulWidget {
  const PromosList({super.key});

  @override
  State<PromosList> createState() => _PromosListState();
}

class _PromosListState extends State<PromosList> {


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
        stream: db.collection("promos").orderBy('postDate', descending: true).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return ZCard(
                  borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
                  onTap: (){
                      ZLaunchUrl.launchUrl(doc["link"]);
                      // Get.to(() => PostDetailsPage(post: post), transition: Transition.cupertino, fullscreenDialog: true);
                    },
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.symmetric(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      SizedBox(height: 7,),
                      Hero(
                        tag: doc['id'],
                        child: ZImageDisplay(
                          image: doc['image'],
                          height: MediaQuery.of(context).size.width * .455,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(doc['title']),
                      ),
                      SizedBox(height: 4),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(ZFormat.dateFormatSignal(doc['postDate'].toDate())),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );

                /*Card(child: ListTile(
                  title: Text(doc['title']),
                ),
                );*/
              }).toList(),
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
