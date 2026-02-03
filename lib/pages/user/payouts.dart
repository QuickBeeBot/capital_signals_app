import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/avatar_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PayOutsList extends StatefulWidget {
  const PayOutsList({super.key});

  @override
  State<PayOutsList> createState() => _PayOutsListState();
}

class _PayOutsListState extends State<PayOutsList> {


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
        stream: db.collection("payouts").orderBy('postDate', descending: true).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasData){
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                height: 350,
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
                                                  child: Text(doc['name_abb'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 13,))
                                              ),
                                            ),
                                            Container(
                                                child: Text(doc['change'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: upColor))
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );/*ZCard(
                      borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
                      onTap: (){
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
                    );*/

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
