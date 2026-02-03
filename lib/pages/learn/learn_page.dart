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

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarShadow = false;
  int _currentTabIndex = 0;

  // Add these to your StatefulWidget's State class
  bool _isButtonHovering = false;
  bool _isBackButtonHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;


// Tab hover states (for desktop)
  List<bool> _tabHoverStates = [false, false, false];

  @override
  void initState() {
    super.initState();


    // Initialize tab controller if not already done
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(_handleTabChange);
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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }



  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
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

    AppProvider appProvider = Provider.of<AppProvider>(context);
    final posts = appProvider.posts;
    final strategies = appProvider.strategies;
    final videos = appProvider.videoLessons;

    // Theme-aware colors
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8F9FA);
    final surfaceColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
    final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
    final accentColor = AppCOLORS.yellow;
    final tabUnselectedColor = isDarkMode ? Colors.grey[600] : Colors.grey[400];
    final dividerColor = isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            // onTap: () => Get.offAll(() => HomePage()), // Navigate to home/dashboard
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
                          color: accentColor,
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
                  'Learning Center',
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
        actions: [
          MouseRegion(
            onEnter: (_) => setState(() => _isButtonHovering = true),
            onExit: (_) => setState(() => _isButtonHovering = false),
            child: GestureDetector(
              onTapDown: (_) => _scaleController.forward(),
              onTapUp: (_) {
                _scaleController.reverse();
                // Navigation logic for Trade Results
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
                        accentColor.withOpacity(_isButtonHovering ? 1.0 : 0.92),
                        accentColor.withOpacity(_isButtonHovering ? 0.9 : 0.82),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(_isButtonHovering ? 0.45 : 0.3),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52), // Reduced from 60px for better density
          child: Container(
            color: surfaceColor,
            child: Column(
              children: [
                // Enhanced TabBar with micro-interactions
                TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Tighter radius
                    color: accentColor.withOpacity(0.15), // Slightly more visible
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: accentColor,
                  unselectedLabelColor: tabUnselectedColor,
                  labelStyle: TextStyle(
                    fontSize: 13.5, // Slightly smaller for density
                    fontWeight: FontWeight.w700, // Stronger weight for active tab
                    letterSpacing: 0.3,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  tabs: [
                    _buildTabItem(
                      icon: Icons.article_outlined,
                      text: 'Posts',
                      index: 0,
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                      isHovering: _tabHoverStates[0],
                      onHover: (value) => setState(() => _tabHoverStates[0] = value),
                    ),
                    _buildTabItem(
                      icon: Icons.leaderboard_outlined,
                      text: 'Strategies',
                      index: 1,
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                      isHovering: _tabHoverStates[1],
                      onHover: (value) => setState(() => _tabHoverStates[1] = value),
                    ),
                    _buildTabItem(
                      icon: Icons.play_circle_outline,
                      text: 'Videos',
                      index: 2,
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                      isHovering: _tabHoverStates[2],
                      onHover: (value) => setState(() => _tabHoverStates[2] = value),
                    ),
                  ],
                  padding: EdgeInsets.symmetric(horizontal: 8), // Better edge spacing
                ),
                // Subtle divider matching signal card borders
                Container(
                  height: 1,
                  color: isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContentList(
            items: posts,
            title: 'Educational Posts',
            subtitle: 'Learn trading concepts and market analysis',
            emptyTitle: 'No Posts Available',
            emptySubtitle: 'Check back later for educational content',
            isDarkMode: isDarkMode,
            surfaceColor: surfaceColor,
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
            builder: (item) => PostCard(post: item),
            onViewAll: () => Get.to(() => PostsPage(posts: posts)),
          ),
          _buildContentList(
            items: strategies,
            title: 'Trading Strategies',
            subtitle: 'Professional strategies for different market conditions',
            emptyTitle: 'No Strategies Available',
            emptySubtitle: 'Strategies will be added soon',
            isDarkMode: isDarkMode,
            surfaceColor: surfaceColor,
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
            builder: (item) => PostCard(post: item),
            onViewAll: () => Get.to(() => PostsPage(posts: strategies)),
          ),
          _buildContentList(
            items: videos,
            title: 'Video Lessons',
            subtitle: 'Watch and learn from expert traders',
            emptyTitle: 'No Videos Available',
            emptySubtitle: 'Video lessons coming soon',
            isDarkMode: isDarkMode,
            surfaceColor: surfaceColor,
            textPrimaryColor: textPrimaryColor,
            textSecondaryColor: textSecondaryColor,
            builder: (item) => VideoCard(videoLesson: item),
            onViewAll: () => Get.to(() => VideosPage(videos: videos)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String text,
    required int index,
    required bool isDarkMode,
    required Color accentColor,
    required bool isHovering,
    required ValueChanged<bool> onHover,
  }) {
    final isActive = _tabController.index == index;
    final baseColor = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212);
    final hoverColor = accentColor.withOpacity(0.15);

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: BoxDecoration(
          color: (isActive || isHovering) ? hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Tab(
          // icon: Icon(
          //   icon,
          //   size: 18, // Reduced from 20px for better proportion
          //   color: isActive ? accentColor : (isHovering ? accentColor.withOpacity(0.8) : baseColor.withOpacity(0.7)),
          // ),
          text: text,
          // iconMargin: EdgeInsets.only(bottom: 4), // Tighter icon-text spacing
        ),
      ),
    );
  }

  Widget _buildContentList<T>({
    required List<T> items,
    required String title,
    required String subtitle,
    required String emptyTitle,
    required String emptySubtitle,
    required bool isDarkMode,
    required Color surfaceColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Widget Function(T) builder,
    required VoidCallback onViewAll,
  }) {
    final first5Items = items.length > 5 ? items.sublist(0, 5) : items;
    final emptyIconColor = isDarkMode ? Color(0xFF444444) : Color(0xFFCCCCCC);
    final cardBorderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
      },
      color: AppCOLORS.yellow,
      backgroundColor: surfaceColor,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              color: surfaceColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textPrimaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.library_books_outlined,
                        value: items.length.toString(),
                        label: 'Total Items',
                        color: AppCOLORS.yellow,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.update_outlined,
                        value: _getLatestDate(items),
                        label: 'Last Updated',
                        color: Colors.blue,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (first5Items.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: surfaceColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                    ),
                    if (items.length > 5)
                      GestureDetector(
                        onTap: onViewAll,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              ),
            ),
          if (first5Items.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: builder(first5Items[index]),
                  );
                },
                childCount: first5Items.length,
              ),
            )
          else
            SliverFillRemaining(
              child: _buildEmptyState(
                icon: Icons.school_outlined,
                title: emptyTitle,
                subtitle: emptySubtitle,
                emptyIconColor: emptyIconColor,
                textSecondaryColor: textSecondaryColor,
                cardBorderColor: cardBorderColor,
                isDarkMode: isDarkMode,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
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
          color: isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0),
          ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLatestDate(List<dynamic> items) {
    if (items.isEmpty) return 'N/A';
    DateTime? latestDate;
    for (var item in items) {
      DateTime? itemDate;
      if (item is Post) {
        itemDate = item.postDate;
      } else if (item is VideoLesson) {
        itemDate = item.timestampCreated;
      }
      if (itemDate != null && (latestDate == null || itemDate.isAfter(latestDate))) {
        latestDate = itemDate;
      }
    }
    // return latestDate != null ? ZFormat.dateFormatShort(latestDate) : 'N/A';
    return latestDate != null ? ZFormat.dateFormatSignal(latestDate) : 'N/A';
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color emptyIconColor,
    required Color textSecondaryColor,
    required Color cardBorderColor,
    required bool isDarkMode,
  }) {
    final emptyStateColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5);

    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: emptyIconColor.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                size: 40,
                color: emptyIconColor,
              ),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: textSecondaryColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Retry loading content
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCOLORS.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: Icon(Icons.refresh_outlined, color: Colors.white,),
              label: Text(
                'Refresh Content',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final bool showCategory;

  const PostCard({
    Key? key,
    required this.post,
    this.showCategory = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardBorderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
    final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
    final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
    final surfaceColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: cardBorderColor,
          width: 1,
        ),
      ),
      color: surfaceColor,
      elevation: 0,
      child: InkWell(
        onTap: () => Get.to(
              () => PostDetailsPage(post: post),
          transition: Transition.cupertino,
          duration: Duration(milliseconds: 300),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: ZImageDisplay(
                      image: post.image,
                      height: 200,
                      width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  if (showCategory)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppCOLORS.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Educational',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: textSecondaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          ZFormat.dateFormatSignal(post.postDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppCOLORS.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Read More',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppCOLORS.yellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoLesson videoLesson;
  final bool showDuration;

  const VideoCard({
    Key? key,
    required this.videoLesson,
    this.showDuration = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardBorderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
    final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
    final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
    final surfaceColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: cardBorderColor,
          width: 1,
        ),
      ),
      color: surfaceColor,
      elevation: 0,
      child: InkWell(
        onTap: () => ZLaunchUrl.launchUrl(videoLesson.link),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: ZImageDisplay(
                      image: videoLesson.image,
                      height: 200,
                      width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppCOLORS.yellow.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Video',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      videoLesson.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: textSecondaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          ZFormat.dateFormatSignal(videoLesson.timestampCreated),
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 14,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Watch',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:signalbyt/pages/user/home_page.dart';
// import '../../components/z_card.dart';
// import '../../models/post_aggr.dart';
// import '../../models/video_lesson_aggr.dart';
// import '../../models_providers/app_provider.dart';
// import 'post_details_page.dart';
// import 'posts_page.dart';
// import 'videos_page.dart';
// import '../../utils/z_format.dart';
//
// import '../../components/z_image_display.dart';
// import '../../constants/app_colors.dart';
// import '../../utils/z_launch_url.dart';
// import '../../pages/learn/promos.dart';
//
// class LearnPage extends StatefulWidget {
//   LearnPage({Key? key}) : super(key: key);
//
//   @override
//   State<LearnPage> createState() => _LearnPageState();
// }
//
// class _LearnPageState extends State<LearnPage> with TickerProviderStateMixin{
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
//     final posts = appProvider.posts;
//     final strategies = appProvider.strategies;
//     final videos = appProvider.videoLessons;
//     final postsFirst5 = posts.length > 5 ? posts.sublist(0, 5) : posts;
//     final strategiesFirst5 = strategies.length > 5 ? strategies.sublist(0, 5) : strategies;
//     final videosFirst5 = videos.length > 5 ? videos.sublist(0, 5) : videos;
//     return Scaffold(
//       appBar: AppBar(
//           title: Text('Capital Signals'),
//           actions: [
//             Center(
//               child: ZCard(
//                 onTap: () {
//                   Get.to(() => EarnPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
//                 },
//                 color: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 inkColor: Colors.transparent,
//                 child: Text('Trade Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
//                 margin: EdgeInsets.only(right: 16),
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 borderRadiusColor: AppCOLORS.yellow,
//               ),
//             ),
//           ],
//       //     bottom: TabBar(
//       //         controller: _tabController,
//       //         indicatorColor: appColorYellow,
//       //         labelColor: appColorYellow,
//       //         tabs: <Widget>[
//       //           Tab(text: "Promos", icon: Icon(Icons.cloud_outlined)),
//       //           Tab(text: "Strategies", icon: Icon(Icons.leaderboard_rounded)),
//       //           Tab(text: "Videos", icon: Icon(Icons.ondemand_video_sharp,)),
//       //   ]
//       // )
//       ),
//         body: Column(
//           children: [
//             Column(children: [Column(children: [for (var video in videosFirst5) VideoCard(videoLesson: video)])]),
//           ],
//         )
//     //   body: TabBarView(
//     //   controller: _tabController,
//     //   children: [
//     //     PromosList(),
//     //     ListView(children: [Column(children: [for (var post in postsFirst5) PostCard(post: post)]),]),
//     //     //ListView(children: [Column(children: [for (var strategy in strategiesFirst5) PostCard(post: strategy)]),]),
//     //     ListView(children: [Column(children: [for (var video in videosFirst5) VideoCard(videoLesson: video)])]),
//     //   ],
//     // )
//     );
//     /*Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       body: ListView(
//         children: [
//           SizedBox(height: 16),
//           _buildHeading(title: 'Posts', onTap: () => Get.to(() => PostsPage(posts: posts), fullscreenDialog: true), length: posts.length),
//           Column(children: [for (var post in postsFirst5) PostCard(post: post)]),
//           SizedBox(height: 16),
//           _buildHeading(title: 'Videos', onTap: () => Get.to(() => VideosPage(videos: videos), fullscreenDialog: true), length: videos.length),
//           Column(children: [for (var video in videosFirst5) VideoCard(videoLesson: video)]),
//           SizedBox(height: 16),
//         ],
//       ),
//     );*/
//   }
//
//   Container _buildHeading({required String title, required Function() onTap, required int length}) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
//       child: Row(
//         children: [
//           Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppCOLORS.yellow)),
//           Spacer(),
//           if (length > 4)
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
// }
//
// class PostCard extends StatelessWidget {
//   const PostCard({Key? key, required this.post}) : super(key: key);
//   final Post post;
//
//   @override
//   Widget build(BuildContext context) {
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;
//     return ZCard(
//       borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
//       onTap: () => Get.to(() => PostDetailsPage(post: post), transition: Transition.cupertino, fullscreenDialog: true),
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.symmetric(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(),
//           SizedBox(height: 7,),
//           Hero(
//             tag: post.id,
//             child: ZImageDisplay(
//               image: post.image,
//               height: MediaQuery.of(context).size.width * .455,
//               width: MediaQuery.of(context).size.width,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             child: Text(post.title),
//           ),
//           SizedBox(height: 4),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             child: Text(ZFormat.dateFormatSignal(post.postDate)),
//           ),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
//
// class VideoCard extends StatelessWidget {
//   const VideoCard({Key? key, required this.videoLesson}) : super(key: key);
//   final VideoLesson videoLesson;
//
//   @override
//   Widget build(BuildContext context) {
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;
//     return ZCard(
//       onTap: () => ZLaunchUrl.launchUrl(videoLesson.link),
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       padding: EdgeInsets.symmetric(),
//       borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(),
//           ZImageDisplay(
//             image: videoLesson.image,
//             height: MediaQuery.of(context).size.width * .455,
//             width: MediaQuery.of(context).size.width,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(8),
//               topRight: Radius.circular(8),
//             ),
//           ),
//           SizedBox(height: 8),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             child: Text(videoLesson.title),
//           ),
//           SizedBox(height: 4),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             child: Text(ZFormat.dateFormatSignal(videoLesson.timestampCreated)),
//           ),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
