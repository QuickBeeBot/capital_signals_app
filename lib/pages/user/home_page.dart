import 'package:signalbyt/constants/app_colors.dart';
import 'package:signalbyt/pages/wallet_page.dart';

import '../../data/json.dart';
import '../../theme/colors.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/card_slider.dart';
import '../../widgets/coin_card.dart';
import '../../widgets/coin_item.dart';
import 'package:flutter/material.dart';

class EarnPage extends StatefulWidget {
  const EarnPage({ Key? key }) : super(key: key);

  @override
  _EarnPageState createState() => _EarnPageState();
}

class _EarnPageState extends State<EarnPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Earn', style: TextStyle(color: AppCOLORS.yellow)),),
        body: WalletPage()    );
  }

  getBody(){
    return
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const SizedBox(height: 30,),
                Center(child: Image.asset("assets/logo.png", height: 45)),
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
                            Text("Wasswa Geofrey", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18,)),
                          ],
                        )
                      ),
                      AvatarImage("https://avatars.githubusercontent.com/u/86506519?v=4", 
                        isSVG: false,
                        width: 35, height: 35, 
                        radius: 10,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                // CardSlider(slides: slides),
                getBalanceCards(),
                const SizedBox(height: 25,),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Text("Get Daily Coin Rewords", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                ),
                const SizedBox(height: 15,),
                getCoinCards(),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(height: 165,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white ?? Theme.of(context).cardColor, width: 2),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      image: const DecorationImage(image: NetworkImage("https://amaghanaonline.com/wp-content/uploads/2022/01/how-to-register-and-open-a-trading-account-in-exness.jpg"), fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(height: 95,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white ?? Theme.of(context).cardColor, width: 2),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      image: const DecorationImage(image: NetworkImage("https://www.jobstoday.com.ng/wp-content/uploads/2022/11/Telegram-1.png"), fit: BoxFit.cover),
                    ),
                  ),
                ),
                //Im("https://amaghanaonline.com/wp-content/uploads/2022/01/how-to-register-and-open-a-trading-account-in-exness.jpg"),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Text("Big Cash Outs", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)),
                const SizedBox(height: 15,),
                getNewCoins(),
                const SizedBox(height: 10,),
                Center(child: Image.asset("assets/logo_c.png", height: 55)),
                const SizedBox(height: 30,),
              ]
          ),
        ),
      );
  }

  getBalanceCards(){
    return CardSlider(balanceCards: balanceCards);
      Center(child: BalanceCard(cardData: balanceCards[0]));
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

  getNewCoins(){
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