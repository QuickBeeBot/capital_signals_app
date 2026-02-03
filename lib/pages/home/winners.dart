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

class WinnersList extends StatefulWidget {
  const WinnersList({super.key});

  @override
  State<WinnersList> createState() => _WinnersListState();
}

class _WinnersListState extends State<WinnersList> {


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
        // stream: db.collection("winners").snapshots(),
        stream: db.collection("winners").orderBy('postDate', descending: true).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasData){
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                height: 500,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: glassColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AvatarImage(
                                  doc['image'],
                                  isSVG: false,
                                  width: 30, height:30,
                                  radius: 50,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child:
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Container(
                                                    child: Text(doc['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))
                                                )
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                                child: Text(doc['price'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                  child: Text("Growth: "+doc['profit'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 13,))
                                              ),
                                            ),
                                            Container(
                                                child: Text(doc['change'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: upColor))
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                            child: Text(doc['name_abb'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 13,))
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                    /*Card(child: ListTile(
                      title: Text(doc['title']),
                    ),
                    );*/
                  }).toList(),
                ),
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
