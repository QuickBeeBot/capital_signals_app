import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';
import '../../models_providers/app_provider.dart';
import '../../components/z_annoucement_card.dart';
import '../../components/z_news_card.dart';
import '../../constants/app_colors.dart';
import 'annoucements_page.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarShadow = false;

  // Add these to your StatefulWidget's State class
  bool _isButtonHovering = false;
  bool _isBackButtonHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }


  void _onScroll() {
    setState(() {
      _showAppBarShadow = _scrollController.offset > 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Complete color palette for both modes
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppCOLORS.yellow,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    // Light Mode Colors
    Color backgroundColor = isDarkMode
        ? Color(0xFF121212)  // True black
        : Color(0xFFF8F9FA); // Very light grey

    Color surfaceColor = isDarkMode
        ? Color(0xFF1E1E1E)  // Dark grey surface
        : Colors.white;      // Pure white

    Color textPrimaryColor = isDarkMode
        ? Color(0xFFE1E1E1)  // Off-white (92% white)
        : Color(0xFF1A1A1A); // Almost black (10% white)

    Color textSecondaryColor = isDarkMode
        ? Color(0xFFAAAAAA)  // Light grey (67% white)
        : Color(0xFF666666); // Medium grey (40% white)

    Color textTertiaryColor = isDarkMode
        ? Color(0xFF888888)  // Medium grey (53% white)
        : Color(0xFF999999); // Light grey (60% white)

    Color dividerColor = isDarkMode
        ? Color(0xFF2D2D2D)  // Dark divider
        : Color(0xFFEEEEEE); // Very light divider

    Color emptyStateColor = isDarkMode
        ? Color(0xFF242424)  // Slightly lighter than surface
        : Color(0xFFF5F5F5); // Slightly darker than background

    Color emptyIconColor = isDarkMode
        ? Color(0xFF444444)  // Dark grey icons
        : Color(0xFFCCCCCC); // Light grey icons

    Color cardBorderColor = isDarkMode
        ? Color(0xFF333333)  // Dark border
        : Color(0xFFE0E0E0); // Light border

    Color shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.08);

    Color errorColor = isDarkMode
        ? Color(0xFFCF6679)  // Material Dark Mode Red
        : Color(0xFFD32F2F); // Material Red 700

    Color successColor = isDarkMode
        ? Color(0xFF03DAC6)  // Material Teal 200
        : Color(0xFF2E7D32); // Material Green 700

    AppProvider appProvider = Provider.of<AppProvider>(context);
    final announcements = appProvider.announcements;
    final news = appProvider.newsAll;
    final announcementsFirst3 = announcements.length > 3 ? announcements.sublist(0, 3) : announcements;
    final newsFirst3 = news.length > 3 ? news.sublist(0, 3) : news;

    // Theme-aware colors
    // final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[50];
    // final surfaceColor = isDarkMode ? Colors.grey[800] : Colors.white;
    // final textPrimaryColor = isDarkMode ? Colors.white : Colors.grey[900];
    // final textSecondaryColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    // final textTertiaryColor = isDarkMode ? Colors.grey[500] : Colors.grey[500];
    // final dividerColor = isDarkMode ? Colors.grey[700] : Colors.grey[200];
    // final emptyStateColor = isDarkMode ? Colors.grey[800] : Colors.grey[50];
    // final emptyIconColor = isDarkMode ? Colors.grey[600] : Colors.grey[300];
    // final shadowColor = isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black12;
    // final cardBorderColor = isDarkMode ? Colors.grey[700] : Colors.grey[200];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Get.back(), // Optional: Navigate to home/dashboard
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Capital',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Color(0xFF121212),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      TextSpan(
                        text: 'Signals',
                        style: TextStyle(
                          color: AppCOLORS.yellow,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Announcements',
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        elevation: 0, // Clean floating appearance
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212),
          size: 20,
        ),
        actions: [
          MouseRegion(
            onEnter: (_) => setState(() => _isButtonHovering = true),
            onExit: (_) => setState(() => _isButtonHovering = false),
            child: GestureDetector(
              onTapDown: (_) => _scaleController.forward(),
              onTapUp: (_) {
                // _scaleController.reverse();
                // // Navigation logic for Trade Results
                // Get.to(
                //       () => SignalsClosedPage(type: _selectedSignalAggrId ?? ''),
                //   fullscreenDialog: true,
                //   transition: Transition.cupertino,
                //   duration: Duration(milliseconds: 400),
                // );
              },
              onTapCancel: () => _scaleController.reverse(),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: EdgeInsets.only(right: 14),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppCOLORS.yellow.withOpacity(_isButtonHovering ? 1.0 : 0.92),
                        AppCOLORS.yellow.withOpacity(_isButtonHovering ? 0.9 : 0.82),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppCOLORS.yellow.withOpacity(_isButtonHovering ? 0.45 : 0.3),
                        blurRadius: _isButtonHovering ? 16 : 10,
                        spreadRadius: _isButtonHovering ? 2 : 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 17,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Image.asset(
            'assets/icon/app_logo.png', // Replace with your actual logo path
            width: 30,
            height: 30,
            color: isDarkMode ? Colors.white : Colors.black,
            fit: BoxFit.contain,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(Duration(seconds: 1));
        },
        color: AppCOLORS.yellow,
        backgroundColor: surfaceColor,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                color: surfaceColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Updates',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stay informed with the latest announcements and news',
                      style: TextStyle(
                        fontSize: 16,
                        color: textSecondaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Stats row (optional - can be removed)
                    Row(
                      children: [
                        _buildStatItem(
                          icon: Icons.announcement_outlined,
                          value: announcements.length.toString(),
                          label: 'Announcements',
                          color: AppCOLORS.yellow,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 16),
                        _buildStatItem(
                          icon: Icons.article_outlined,
                          value: news.length.toString(),
                          label: 'News',
                          color: Colors.blue,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Divider(height: 1, color: dividerColor),
            ),

            // Announcements Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Announcements',
                count: announcements.length,
                onTap: () => Get.to(
                      () => AnnoucementsPage(announcements: announcements),
                  fullscreenDialog: true,
                  transition: Transition.rightToLeft,
                ),
                isDarkMode: isDarkMode,
                surfaceColor: surfaceColor,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
              ),
            ),

            if (announcementsFirst3.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ZAnnoucementCard(
                      announcement: announcementsFirst3[index],
                      // showDivider: index < announcementsFirst3.length - 1,
                    ),
                  ),
                  childCount: announcementsFirst3.length,
                ),
              )
            else
              SliverToBoxAdapter(
                child: _buildEmptyState(
                  icon: Icons.announcement_outlined,
                  title: 'No Announcements',
                  subtitle: 'Check back later for updates',
                  emptyStateColor: emptyStateColor,
                  emptyIconColor: emptyIconColor,
                  textSecondaryColor: textSecondaryColor,
                  cardBorderColor: cardBorderColor,
                ),
              ),

            // Divider between sections
            SliverToBoxAdapter(
              child: Divider(height: 1, color: dividerColor),
            ),

            // News Section
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Market News',
                count: news.length,
                onTap: () => Get.to(
                      () => NewsPage(news: news),
                  fullscreenDialog: true,
                  transition: Transition.rightToLeft,
                ),
                isDarkMode: isDarkMode,
                surfaceColor: surfaceColor,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
              ),
            ),

            if (newsFirst3.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ZNewsCard(
                      news: newsFirst3[index],
                      // showDivider: index < newsFirst3.length - 1,
                    ),
                  ),
                  childCount: newsFirst3.length,
                ),
              )
            else
              SliverToBoxAdapter(
                child: _buildEmptyState(
                  icon: Icons.article_outlined,
                  title: 'No News',
                  subtitle: 'Stay tuned for market updates',
                  emptyStateColor: emptyStateColor,
                  emptyIconColor: emptyIconColor,
                  textSecondaryColor: textSecondaryColor,
                  cardBorderColor: cardBorderColor,
                ),
              ),

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
    required VoidCallback onTap,
    required bool isDarkMode,
    required Color surfaceColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      color: surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '$count items',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppCOLORS.yellow.withOpacity(isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppCOLORS.yellow.withOpacity(isDarkMode ? 0.4 : 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: AppCOLORS.yellow,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppCOLORS.yellow,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.grey[900],
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color emptyStateColor,
    required Color emptyIconColor,
    required Color textSecondaryColor,
    required Color cardBorderColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: emptyStateColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: emptyIconColor,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:signalbyt/pages/home/websites.dart';
// import 'package:signalbyt/pages/home/winners.dart';
// import 'package:signalbyt/widgets/winners_card.dart';
// import '../../components/z_card.dart';
// import '../../models_providers/app_provider.dart';
// import '../../components/z_annoucement_card.dart';
// import '../../components/z_news_card.dart';
// import '../../constants/app_colors.dart';
// import '../user/home_page.dart';
// import 'annoucements_page.dart';
// import 'brokers.dart';
// import 'news_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final ScrollController _scrollController = ScrollController();
//   bool _showAppBarShadow = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     setState(() {
//       _showAppBarShadow = _scrollController.offset > 10;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     final announcements = appProvider.announcements;
//     final news = appProvider.newsAll;
//     final announcementsFirst3 = announcements.length > 3 ? announcements.sublist(0, 3) : announcements;
//     final newsFirst3 = news.length > 3 ? news.sublist(0, 3) : news;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'CapitalSignals',
//               style: TextStyle(
//                 color: AppCOLORS.yellow,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             Text(
//               'Announcements',
//               style: TextStyle(
//                 color: Colors.grey[700],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//         elevation: _showAppBarShadow ? 4 : 0,
//         shadowColor: Colors.black12,
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         actions: [
//           Container(
//             margin: EdgeInsets.only(right: 16),
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.to(
//                       () => EarnPage(),
//                   fullscreenDialog: true,
//                   duration: Duration(milliseconds: 500),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppCOLORS.yellow,
//                 foregroundColor: Colors.black,
//                 elevation: 0,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.trending_up, size: 18),
//                   SizedBox(width: 6),
//                   Text(
//                     'Trade Results',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Add refresh logic here
//           setState(() {});
//           await Future.delayed(Duration(seconds: 1));
//         },
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [
//             // Header Section
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Market Updates',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.grey[900],
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Stay informed with the latest announcements and news',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Announcements Section
//             SliverToBoxAdapter(
//               child: _buildSectionHeader(
//                 title: 'Announcements',
//                 count: announcements.length,
//                 onTap: () => Get.to(
//                       () => AnnoucementsPage(announcements: announcements),
//                   fullscreenDialog: true,
//                   transition: Transition.rightToLeft,
//                 ),
//               ),
//             ),
//             if (announcementsFirst3.isNotEmpty)
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) => Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: ZAnnoucementCard(
//                       announcement: announcementsFirst3[index],
//                       // showDivider: index < announcementsFirst3.length - 1,
//                     ),
//                   ),
//                   childCount: announcementsFirst3.length,
//                 ),
//               )
//             else
//               SliverToBoxAdapter(
//                 child: _buildEmptyState(
//                   icon: Icons.announcement_outlined,
//                   title: 'No Announcements',
//                   subtitle: 'Check back later for updates',
//                 ),
//               ),
//
//             // News Section
//             SliverToBoxAdapter(
//               child: _buildSectionHeader(
//                 title: 'Market News',
//                 count: news.length,
//                 onTap: () => Get.to(
//                       () => NewsPage(news: news),
//                   fullscreenDialog: true,
//                   transition: Transition.rightToLeft,
//                 ),
//               ),
//             ),
//             if (newsFirst3.isNotEmpty)
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) => Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: ZNewsCard(
//                       news: newsFirst3[index],
//                       // showDivider: index < newsFirst3.length - 1,
//                     ),
//                   ),
//                   childCount: newsFirst3.length,
//                 ),
//               )
//             else
//               SliverToBoxAdapter(
//                 child: _buildEmptyState(
//                   icon: Icons.article_outlined,
//                   title: 'No News',
//                   subtitle: 'Stay tuned for market updates',
//                 ),
//               ),
//
//             // Quick Actions Section
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Quick Access',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.grey[900],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildQuickActionCard(
//                             icon: Icons.people_outline,
//                             label: 'Brokers',
//                             color: Colors.blue[50]!,
//                             iconColor: Colors.blue,
//                             onTap: () => Get.to(() => BrokersList()
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: _buildQuickActionCard(
//                             icon: Icons.web_outlined,
//                             label: 'Websites',
//                             color: Colors.green[50]!,
//                             iconColor: Colors.green,
//                             onTap: () => Get.to(() => WebsitesList()),
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: _buildQuickActionCard(
//                             icon: Icons.emoji_events_outlined,
//                             label: 'Winners',
//                             color: Colors.orange[50]!,
//                             iconColor: Colors.orange,
//                             onTap: () => Get.to(() => WinnersList()),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Bottom spacing
//             SliverToBoxAdapter(
//               child: SizedBox(height: 40),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader({
//     required String title,
//     required int count,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey[900],
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 '$count items',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[500],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           GestureDetector(
//             onTap: onTap,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 color: AppCOLORS.yellow.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppCOLORS.yellow.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'View All',
//                     style: TextStyle(
//                       color: AppCOLORS.yellow,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(width: 6),
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 14,
//                     color: AppCOLORS.yellow,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickActionCard({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required Color iconColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 icon,
//                 color: iconColor,
//                 size: 24,
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Tap to view',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//       padding: EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.grey,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 64,
//             color: Colors.grey[300],
//           ),
//           SizedBox(height: 16),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[400],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[400],
//               fontWeight: FontWeight.w400,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:signalbyt/pages/home/websites.dart';
// import 'package:signalbyt/pages/home/winners.dart';
// import 'package:signalbyt/widgets/winners_card.dart';
// import '../../components/z_card.dart';
// import '../../models_providers/app_provider.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import '../../components/z_annoucement_card.dart';
// import '../../components/z_news_card.dart';
// import '../../constants/app_colors.dart';
// import '../user/home_page.dart';
// import 'annoucements_page.dart';
// import 'brokers.dart';
// import 'news_page.dart';
//
//
// import '../../data/json.dart';
// import '../../widgets/comps_card.dart';
//
//
// import '../../widgets/coin_item.dart';
//
// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
//
//   late final TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     final announcements = appProvider.announcements;
//     final news = appProvider.newsAll;
//     final announcementsFirst5 = announcements.length > 2 ? announcements.sublist(0, 2) : announcements;
//     final newsFirst5 = news.length > 5 ? news.sublist(0, 5) : news;
//     return Scaffold(
//         appBar: AppBar(
//             title: Text('Announcements', style: TextStyle(color: AppCOLORS.yellow, fontSize: 25)),
//             actions: [
//               Center(
//                 child: ZCard(
//                   onTap: () {
//                     Get.to(() => EarnPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
//                   },
//                   color: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   inkColor: Colors.transparent,
//                   child: Text('Trade Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
//                   margin: EdgeInsets.only(right: 16),
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   borderRadiusColor: AppCOLORS.yellow,
//                 ),
//               ),
//             ],),
//         body: Column(
//             children: [
//               Column(
//                 children: [
//                   SizedBox(height: 16),
//                   _buildHeading(
//                       title: 'Announcements', onTap: () => Get.to(() => AnnoucementsPage(announcements: announcements), fullscreenDialog: true), showViewAll: announcements.length > 2),
//                   Column(children: [for (var post in announcementsFirst5) ZAnnoucementCard(announcement: post)]),
//                   SizedBox(height: 16),
//                   /* ---------------------------------- NEWS ---------------------------------- */
//                   if (news.length > 0) _buildHeading(title: 'News', onTap: () => Get.to(() => NewsPage(news: news), fullscreenDialog: true), showViewAll: true),
//                   Column(children: [for (var n in newsFirst5) ZNewsCard(news: n)]),
//                   SizedBox(height: 16),
//                 ],
//               ),
//
//
//             ])
//     );
//   }
//
//   Container _buildHeading({required String title, required Function() onTap, bool showViewAll = false}) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
//       child: Row(
//         children: [
//           // Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppCOLORS.yellow)),
//           // Spacer(),
//           if (showViewAll)
//             ZCard(
//               margin: EdgeInsets.symmetric(),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: Text('View all'),
//               borderRadiusColor: AppCOLORS.yellow,
//               onTap: onTap,
//             ),
//         ],
//       ),
//     );
//   }
//
//
//
//   getCoinCards(){
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 5, left: 15),
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(links.length,
//                 (index) => CoinCard(cardData: links[index])
//         ),
//       ),
//     );
//   }
//
//
//   getCoinCards2(){
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 5, left: 15),
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(brokers.length,
//                 (index) => CoinCard(cardData: brokers[index])
//         ),
//       ),
//     );
//   }
//
//
//
//   getNewCoins(){
//     return Container(
//       padding: const EdgeInsets.only(left: 15, right: 15),
//       child: Column(
//           children: List.generate(winners.length,
//                   (index) => WinnersCard(winners[index])
//           )
//       ),
//     );
//   }
//
// }
