import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_signal_subscribe_card.dart';
import '../../models/auth_user.dart';
import '../../models/signal_aggr_open.dart';
import '../../models_providers/auth_provider.dart';
import 'signals_closed_page.dart';
import '../../components/z_signal_card.dart';
import '../../components/z_signalaggr_performace_card.dart';
import '../../constants/app_colors.dart';

class SignalsPage extends StatefulWidget {
  const SignalsPage({
    Key? key,
    required this.type,
    required this.signalsAggrOpen,
    required this.controllerLength,
  }) : super(key: key);

  final String type;
  final List<SignalAggrOpen> signalsAggrOpen;
  final int controllerLength;

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String? _selectedSignalAggrId;
  bool _showAppBarShadow = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.controllerLength, vsync: this);
    _scrollController = ScrollController();

    if (widget.signalsAggrOpen.isNotEmpty) {
      _selectedSignalAggrId = widget.signalsAggrOpen[0].id;
    }

    _tabController.addListener(_handleTabChange);
    _scrollController.addListener(_handleScroll);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final index = _tabController.index;
      if (index < widget.signalsAggrOpen.length) {
        setState(() {
          _selectedSignalAggrId = widget.signalsAggrOpen[index].id;
        });
      }
    }
  }

  void _handleScroll() {
    setState(() {
      _showAppBarShadow = _scrollController.offset > 10;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _scrollController.removeListener(_handleScroll);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8F9FA);
    final surfaceColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
    final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
    final dividerColor = isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CapitalSignals',
              style: TextStyle(
                color: AppCOLORS.yellow,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Open Signals',
              style: TextStyle(
                color: textSecondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        elevation: _showAppBarShadow ? 4 : 0,
        shadowColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.black12,
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.grey[800],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(
                      () => SignalsClosedPage(type: _selectedSignalAggrId ?? ''),
                  fullscreenDialog: true,
                  transition: Transition.cupertino,
                  duration: Duration(milliseconds: 500),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCOLORS.yellow,
                foregroundColor: Colors.black,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              icon: Icon(Icons.history_outlined, size: 18),
              label: Text(
                'Results',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: surfaceColor,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: widget.controllerLength > 3,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppCOLORS.yellow.withOpacity(0.1),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppCOLORS.yellow,
                  unselectedLabelColor: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: widget.signalsAggrOpen.map((s) => Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )).toList(),
                ),
                Container(
                  height: 1,
                  color: dividerColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.signalsAggrOpen.map((signalAggr) {
          return _buildSignalAggrContent(signalAggr, isDarkMode, surfaceColor, textPrimaryColor);
        }).toList(),
      ),
    );
  }

  Widget _buildSignalAggrContent(
      SignalAggrOpen signalAggr,
      bool isDarkMode,
      Color surfaceColor,
      Color textPrimaryColor,
      ) {
    final signals = signalAggr.signals;

    if (signals.isEmpty) {
      return _buildEmptyState(
        title: 'No Open Signals',
        subtitle: 'No active signals for ${signalAggr.name}',
        isDarkMode: isDarkMode,
      );
    }

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
          // Performance Summary
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: ZSignalAggrPerformaceCard(signalAggrOpen: signalAggr),
            ),
          ),

          // Signals Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: surfaceColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Signals (${signals.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppCOLORS.yellow.withOpacity(isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.update_outlined,
                          size: 14,
                          color: AppCOLORS.yellow,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Live',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppCOLORS.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Signals List
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final signal = signals[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildSignalItem(signal),
                );
              },
              childCount: signals.length,
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalItem(Signal signal) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.authUser;
    final hasAccess = user?.hasActiveSubscription == true || signal.isFree;

    if (hasAccess) {
      return ZSignalCard(signal: signal);
    } else {
      return ZSignalSubscribeCard(signal: signal);
    }
  }

  Widget _buildEmptyState({
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    final emptyStateColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5);
    final emptyIconColor = isDarkMode ? Color(0xFF444444) : Color(0xFFCCCCCC);
    final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
    final cardBorderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);

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
                Icons.signal_cellular_alt_outlined,
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
                // Navigate to closed signals or refresh
                Get.to(
                      () => SignalsClosedPage(type: _selectedSignalAggrId ?? ''),
                  transition: Transition.cupertino,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppCOLORS.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: Icon(Icons.history_outlined),
              label: Text(
                'View Historical Results',
                style: TextStyle(
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

// Optional: Enhanced ShowEngineBottomSheet (if needed)
class ShowEngineBottomSheet extends StatefulWidget {
  const ShowEngineBottomSheet({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<ShowEngineBottomSheet> createState() => _ShowEngineBottomSheetState();
}

class _ShowEngineBottomSheetState extends State<ShowEngineBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
    final cardBorderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Select Trading Engine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close_rounded),
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: cardBorderColor,
          ),

          // Content would be added here based on your engine list
          // _buildEngineList(),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}