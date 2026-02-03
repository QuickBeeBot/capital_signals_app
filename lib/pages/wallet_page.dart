import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signalbyt/pages/withdraw.dart';
import '../../data/json.dart';
import '../../theme/colors.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/card_slider.dart';
import '../../widgets/coin_card.dart';
import '../../widgets/coin_item.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../components/z_card.dart';

import 'dart:io' show Platform;

import 'dart:developer';

import 'user/payouts.dart';


class WalletPage extends StatefulWidget {
  const WalletPage({ Key? key }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  final box = GetStorage();

  Future<String> getUserBalance() async {
    return await box.read("balance");;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: appBgColor,
        body: Container(
          decoration: const BoxDecoration(
          ),
          child: getBody(),
        )
    );
  }

  getBody(){
    return
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const SizedBox(height: 10,),
                Center(child: Image.asset("assets/icon/app_logo.png", height: 65)),
                const SizedBox(height: 30,),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),),
                          SizedBox(height: 3,),
                          Text("Guest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18,)),
                        ],
                      )
                      ),
                      AvatarImage("https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
                        isSVG: false,
                        width: 35, height: 35,
                        radius: 10,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                // CardSlider(slides: slides),
                getBalanceCards2(context),
                const SizedBox(height: 25,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Get More Coin Rewards", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                ),
                const SizedBox(height: 15,),
                Row(children: [
                  SizedBox(width: 20,),
                  Expanded(
                    child: ZCard(
                      onTap: () {
                        //Get.to(() => SignalsClosedPage(type: selectSignalAggrId ?? ''), fullscreenDialog: true, duration: Duration(milliseconds: 500));
                      },
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      inkColor: Colors.transparent,
                      child: Center(
                        child: Text('Share App', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900)),
                      ),
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      borderRadiusColor: AppCOLORS.yellow,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ZCard(
                      onTap: () {
                        //_showRewardedInterstitialAd();
                        //Get.to(() => LoadAdsPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
                        //Get.to(() => SignalsClosedPage(type: selectSignalAggrId ?? ''), fullscreenDialog: true, duration: Duration(milliseconds: 500));
                      },
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      inkColor: Colors.transparent,
                      child: Center(
                        child: Text('View Ads', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900)),
                      ),
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      borderRadiusColor: AppCOLORS.yellow,
                    ),
                  ),
                  SizedBox(width: 10,),
                ],),
                //getCoinCards(),
                const SizedBox(height: 40,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Big Cash Outs", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)),
                const SizedBox(height: 15,),
                PayOutsList(),
                const SizedBox(height: 10,),
                Center(child: Image.asset("assets/icon/winbirdfx_logo.png", height: 75)),
                const SizedBox(height: 30,),
              ]
          ),
        ),
      );
  }



  getBalanceCards2(BuildContext context){

    Future<String> getUserBalance() async {
      return await box.read("balance");;
    }

    return FutureBuilder(
        future: getUserBalance(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            String balanceText = snapshot.data!.toString();
            return Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: primary.withOpacity(.4),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    colors: [
                      primary.withOpacity(.4),
                      primary.withOpacity(.7),
                    ],
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                    SizedBox(height: 5,),
                    // Text("\$"+balanceText, maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    // Text("\$"+balanceText, maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    Text(balanceText == null? "\$0.00" : "\$"+balanceText, maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Monthly profit", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            final current = box.read("balance");
                            var currentBalance = double.parse(current);
                            if(currentBalance<50.0){
                              final snackBar = SnackBar(
                                content: Text('The minimum withdraw is \$50!'),
                                backgroundColor: Colors.yellow,
                                elevation: 10,
                                margin: EdgeInsets.all(5),
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else {
                              Get.to(() => WithdrawPage(), fullscreenDialog: true,
                                  duration: Duration(milliseconds: 500));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.2),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_drop_up_sharp),
                                Text("Withdraw", style: TextStyle(color: Colors.white, fontSize: 10,),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
            );
          } else if(snapshot.hasError){
            return Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: primary.withOpacity(.4),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    colors: [
                      primary.withOpacity(.4),
                      primary.withOpacity(.7),
                    ],
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                    SizedBox(height: 5,),
                    // Text("\$"+balanceText, maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Monthly profit", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            // toast
                            final snackBar = SnackBar(
                              content: Text('The minimum withdraw is \$50!'),
                              backgroundColor: Colors.yellow,
                              elevation: 10,
                              margin: EdgeInsets.all(5),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.2),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_drop_up_sharp),
                                Text("Withdraw", style: TextStyle(color: Colors.white, fontSize: 10,),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
            );
          } else {
            // String balanceText = snapshot.data!.toString();
            return Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: primary.withOpacity(.4),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    colors: [
                      primary.withOpacity(.4),
                      primary.withOpacity(.7),
                    ],
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                    SizedBox(height: 5,),
                    // Text("\$"+balanceText, maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Monthly profit", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            // toast
                            final snackBar = SnackBar(
                              content: Text('The minimum withdraw is \$50!'),
                              backgroundColor: Colors.yellow,
                              elevation: 10,
                              margin: EdgeInsets.all(5),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.2),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_drop_up_sharp),
                                Text("Withdraw", style: TextStyle(color: Colors.white, fontSize: 10,),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
            );

          }
        });
  }


  getBalanceCards(){
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: primary.withOpacity(.4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              primary.withOpacity(.4),
              primary.withOpacity(.7),
            ],
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Balance", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
            SizedBox(height: 5,),
            Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Monthly profit", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                    SizedBox(height: 5,),
                    Text("\$0.00", maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    // toast
                    final snackBar = SnackBar(
                      content: Text('The minimum withdraw is \$50!'),
                      backgroundColor: Colors.yellow,
                      elevation: 10,
                      margin: EdgeInsets.all(5),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },







                  child: Container(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_drop_up_sharp),
                        Text("Withdraw", style: TextStyle(color: Colors.white, fontSize: 10,),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )
    );
  }

  getCoinCards(){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(coins.length,
                (index) => CoinCard(cardData: coins[index])
        ),
      ),
    );
  }

  getCasOuts(){
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
          children: List.generate(cashOuts.length,
                  (index) => CoinItem(cashOuts[index])
          )
      ),
    );
  }



}