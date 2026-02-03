import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/pages/home/websites.dart';
import 'package:signalbyt/pages/home/winners.dart';
import 'package:signalbyt/widgets/winners_card.dart';
import '../../components/z_card.dart';
import '../../models_providers/app_provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../components/z_annoucement_card.dart';
import '../../components/z_news_card.dart';
import '../../constants/app_colors.dart';
import '../user/home_page.dart';
import 'annoucements_page.dart';
import 'brokers.dart';
import 'news_page.dart';


import '../../data/json.dart';
import '../../widgets/comps_card.dart';


import '../../widgets/coin_item.dart';

class HomePage2 extends StatefulWidget {
  HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin{

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final announcements = appProvider.announcements;
    final news = appProvider.newsAll;
    final announcementsFirst5 = announcements.length > 2 ? announcements.sublist(0, 2) : announcements;
    final newsFirst5 = news.length > 5 ? news.sublist(0, 5) : news;
    return Scaffold(
      appBar: AppBar(
          title: Text('Capital Signals', style: TextStyle(color: AppCOLORS.yellow)),
          actions: [
            Center(
              child: ZCard(
                onTap: () {
                  Get.to(() => EarnPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
                },
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                inkColor: Colors.transparent,
                child: Text('Trade Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                borderRadiusColor: AppCOLORS.yellow,
              ),
            ),
          ],
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: appColorYellow,
              labelColor: appColorYellow,
              tabs: <Widget>[
                Tab(text: "Home", icon: Icon(Icons.cloud_outlined)),
                Tab(text: "Forex Trading", icon: Icon(Icons.link)),
                // Tab(text: "WinBirdFx", icon: Icon(Icons.add_business_outlined,)),
              ]
          )),
      body: TabBarView(
          controller: _tabController,
          children: [
            ListView(
                children: [
                  SizedBox(height: 16),
                  _buildHeading(
                      title: 'Announcements', onTap: () => Get.to(() => AnnoucementsPage(announcements: announcements), fullscreenDialog: true), showViewAll: announcements.length > 2),
                  Column(children: [for (var post in announcementsFirst5) ZAnnoucementCard(announcement: post)]),
                  SizedBox(height: 16),
                  /* ---------------------------------- NEWS ---------------------------------- */
                  if (news.length > 0) _buildHeading(title: 'News', onTap: () => Get.to(() => NewsPage(news: news), fullscreenDialog: true), showViewAll: true),
                  Column(children: [for (var n in newsFirst5) ZNewsCard(news: n)]),
                  SizedBox(height: 16),
                ],
              ),
            ListView(
              children:[

                const SizedBox(height: 25,),
                // WebsitesList(),
                const SizedBox(height: 15,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Trading Competitions", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                ),
                const SizedBox(height: 15,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("To get into the Competitions Register with one of our Recommended Brokers, deposit any amount of your choice with a minimum of \$100 and grow it to a minimum of 1,000% for a period of 1 month to win a prise.", style: TextStyle(color: Colors.white),)
                ),
                const SizedBox(height: 15,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("The one that grows his or account with the highest percentage for the particular month will be listed onto the app", style: TextStyle(color: Colors.white),)
                ),

                const SizedBox(height: 20,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Last 5 Months Top Winners", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)),
                const SizedBox(height: 15,),
                WinnersList(),

                const SizedBox(height: 25,),
                Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Trading Competitions Summery", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                ),
                const SizedBox(height: 15,),
                HtmlWidget(
                  "<ul><li>Broker(s): Listed below</li>"+
                      "<li>Minimum Deposit: \$100</li>"+
                      "<li>Growth Target: 1000%</li>"+
                      "<li>Duration:  1 Month</li></ul>"+

                      "<p>With WinBirdFx, you can!</p>",

                     textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 25,),Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const Text("Recommended Brokers", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                ),
                const SizedBox(height: 15,),
                BrokersList(),
                const SizedBox(height: 20,),
              ]
            ),
            ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/icon/winbirdfx_logo.png", height: 200),
                      SizedBox(height: 8),
                      Text(
                        "WinBirdFx",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Unlock Your Winning Potential",
                        style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 16),
                      HtmlWidget(
                        "<p>Empowering individuals to unlock their trading potential, WinBirdFx is more than just a forex education platform or signal service. We're a community of passionate traders united by a shared desire to master the markets and achieve financial freedom.</p>"+

                        "<p>What sets us apart?</p>"+

                        "<ul><li>Comprehensive Education: From beginner-friendly Forex 101 courses to personalized mentorship programs, we cater to every trader's level and learning style. Our experienced instructors guide you through the fundamentals and advanced strategies, equipping you with the knowledge and confidence to trade with purpose.</li>"+
                        "<li>AI-Powered Insights: Our cutting-edge signal service leverages sophisticated algorithms to analyze market data and deliver high-probability trading opportunities. But we don't just hand you signals; we empower you to understand the reasoning behind them, fostering true trading independence.</li>"+
                        "<li>Supportive Community: WinBirdFx is more than just a platform; it's a thriving community of like-minded individuals. Our interactive forums and live webinars provide a space to learn from each other, share experiences, and stay motivated on your trading journey.</li></ul>"+

                            "<p>With WinBirdFx, you can:</p>"+

    "<ul><li>Gain a deep understanding of the forex market and its dynamics.</li>"+
    "<li>Develop profitable trading strategies tailored to your risk tolerance and goals.</li>"+
    "<li>Receive actionable trading signals backed by AI and expert analysis.</li>"+
    "<li>Connect with a supportive community of fellow traders on a similar path.</li>"+
    "<li>Take control of your financial future and achieve your trading aspirations.</li></ul>  "+
    "<p>WinBirdFx is not just about making money; it's about empowering individuals to become confident, independent traders. We believe everyone deserves the opportunity to spread their wings and soar above the ordinary in the world of forex trading.</p>",
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ])
    );
  }

  Container _buildHeading({required String title, required Function() onTap, bool showViewAll = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppCOLORS.yellow)),
          Spacer(),
          if (showViewAll)
            ZCard(
              margin: EdgeInsets.symmetric(),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('View all'),
              borderRadiusColor: AppCOLORS.yellow,
              onTap: onTap,
            ),
        ],
      ),
    );
  }



  getCoinCards(){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(links.length,
                (index) => CoinCard(cardData: links[index])
        ),
      ),
    );
  }


  getCoinCards2(){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(brokers.length,
                (index) => CoinCard(cardData: brokers[index])
        ),
      ),
    );
  }



  getNewCoins(){
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
          children: List.generate(winners.length,
                  (index) => WinnersCard(winners[index])
          )
      ),
    );
  }

}
