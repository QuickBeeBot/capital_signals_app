import '../theme/colors.dart';
import 'package:flutter/material.dart';
import 'avatar_image.dart';

class CoinCard extends StatelessWidget {
  CoinCard({ Key? key, required this.cardData}) : super(key: key);
  final cardData;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AvatarImage(cardData["image"],
                  isSVG: false,
                  width: 60, height: 60,
                ),
                SizedBox(height: 10,),
                Text(cardData["name"], maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
              ],
            ),
        ],
        )
      );
  }
}
