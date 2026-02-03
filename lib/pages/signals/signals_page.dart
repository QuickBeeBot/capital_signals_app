import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_signal_subscribe_card.dart';
import '../../models/auth_user.dart';
import '../../models/signal_aggr_open.dart';
import '../../models_providers/auth_provider.dart';
import 'signals_closed_page.dart';

import '../../components/z_card.dart';
import '../../components/z_signal_card.dart';
import '../../components/z_signalaggr_performace_card.dart';
import '../../constants/app_colors.dart';

class SignalsPage extends StatefulWidget {
  const SignalsPage({Key? key, required this.type, required this.signalsAggrOpen, required this.controllerLength}) : super(key: key);
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

  String search = '';
  bool isLoadingInit = true;
  int signalsCount = 0;
  late TabController _controller;
  String? selectSignalAggrId;

  @override
  void initState() {
    _controller = TabController(length: widget.controllerLength, vsync: this);
    if (widget.signalsAggrOpen.length > 0) selectSignalAggrId = widget.signalsAggrOpen[0].id;

    _controller = TabController(length: widget.controllerLength, vsync: this);
    _controller.addListener(() {
      int index = _controller.index;
      selectSignalAggrId = widget.signalsAggrOpen[index].id;
    });

    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    );
  }

  // Add these to your StatefulWidget's State class
  bool _isButtonHovering = false;
  bool _isBackButtonHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;


  @override
  void dispose() {
    _scaleController.dispose();
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
      key: ObjectKey(widget.key),

      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Get.back(),
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
                  'Active Signals',
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
        elevation: _showAppBarShadow ? 0 : 0,
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
                _scaleController.reverse();
                Get.to(
                      () => SignalsClosedPage(type: _selectedSignalAggrId ?? ''),
                  fullscreenDialog: true,
                  transition: Transition.cupertino,
                  duration: Duration(milliseconds: 400),
                );
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
                        Icons.history,
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
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'CapitalSignals',
      //         style: TextStyle(
      //           color: AppCOLORS.yellow,
      //           fontSize: 25,
      //           fontWeight: FontWeight.w700,
      //           letterSpacing: -0.5,
      //         ),
      //       ),
      //       Text(
      //         'Open Signals',
      //         style: TextStyle(
      //           color: textSecondaryColor,
      //           fontSize: 14,
      //           fontWeight: FontWeight.w400,
      //         ),
      //       ),
      //     ],
      //   ),
      //   elevation: _showAppBarShadow ? 4 : 0,
      //   shadowColor: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.black12,
      //   backgroundColor: surfaceColor,
      //   surfaceTintColor: surfaceColor,
      //   iconTheme: IconThemeData(
      //     color: isDarkMode ? Colors.white : Colors.grey[800],
      //   ),
      //   actions: [
      //     Container(
      //       margin: EdgeInsets.only(right: 16),
      //       child: ElevatedButton.icon(
      //         onPressed: () {
      //           Get.to(
      //                 () => SignalsClosedPage(type: _selectedSignalAggrId ?? ''),
      //             fullscreenDialog: true,
      //             transition: Transition.cupertino,
      //             duration: Duration(milliseconds: 500),
      //           );
      //         },
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: AppCOLORS.yellow,
      //           foregroundColor: Colors.black,
      //           elevation: 0,
      //           shadowColor: Colors.transparent,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //         ),
      //         icon: Icon(Icons.history_outlined, size: 18, color: Colors.white,),
      //         label: Text(
      //           'Results',
      //           style: TextStyle(
      //             fontSize: 14,
      //             color: Colors.white,
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: TabBarView(
        controller: _controller,
        children: [
          for (var s in widget.signalsAggrOpen) _buildList(s.signals, s),
        ],
      ),
    );
  }

  _buildList(List<Signal> signals, SignalAggrOpen signalAggrOpen) {
    if (signals.isEmpty)
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 3),
          Center(child: Text('No signals available')),
        ],
      );
    return _buildListView(signals, signalAggrOpen);
  }

  Scrollbar _buildListView(List<Signal> signals, SignalAggrOpen signalAggrOpen) {
    ScrollController scrollController = ScrollController(initialScrollOffset: 0);
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: signals.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0)
                  Column(
                    children: [SizedBox(height: 4), ZSignalAggrPerformaceCard(signalAggrOpen: signalAggrOpen)],
                  ),
                getSignalCard(signals[index]),
                if (index == signals.length - 1) SizedBox(height: 32),
              ],
            )),
      ),
    );
  }

  List<Signal> getFilteredSignals(String s, List<Signal> signals) {
    if (s == '') return signals;
    return signals.where((signal) {
      return signal.symbol.toLowerCase().contains(s.toLowerCase());
    }).toList();
  }

  getSignalCard(Signal signal) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthUser? user = authProvider.authUser;

    if (user?.hasActiveSubscription == true) return ZSignalCard(signal: signal);
    if (signal.isFree) return ZSignalCard(signal: signal);

    return ZSignalSubscribeCard(signal: signal);
  }
}

class ShowEngineBottomSheet extends StatefulWidget {
  ShowEngineBottomSheet({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<ShowEngineBottomSheet> createState() => _ShowEngineBottomSheetState();
}

class _ShowEngineBottomSheetState extends State<ShowEngineBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text('Please select an engine below', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Spacer(),
              ZCard(
                color: Colors.transparent,
                onTap: (() => Get.back()),
                child: Icon(AntDesign.close, size: 20),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(6),
              ),
            ],
          ),
          // _buildSignalWrapper(signalAggrs, 'Crypto Engines'),
        ],
      ),
    );
  }

  buildEngineItem(SignalAggrOpen signalAggr) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        SizedBox(height: 12),
        ZCard(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            // if (widget.type == 'long') appProvider.setSelectSignalAggrIdLong(signalAggr.id);
            // if (widget.type == 'short') appProvider.setSelectSignalAggrIdShort(signalAggr.id);
          },
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${signalAggr.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(width: 8),
                  Spacer(),
                  SvgPicture.asset('assets/svg/exchange.svg', colorFilter: ColorFilter.mode(isLightTheme ? Colors.black54 : Colors.white, BlendMode.srcIn), height: 16, width: 16),
                ],
              ),
              Divider(height: 20),
              Text(signalAggr.name, style: TextStyle(fontSize: 14, height: 1.5))
            ],
          ),
        ),
      ],
    );
  }
}
