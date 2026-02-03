import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/app_colors.dart';
import '../../models_providers/app_provider.dart';
import 'signals_page.dart';

class SignalsInitPage extends StatefulWidget {
  const SignalsInitPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<SignalsInitPage> createState() => _SignalsInitPageState();
}

class _SignalsInitPageState extends State<SignalsInitPage> {
  bool _isFirstLoad = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSignals();
    });
  }

  Future<void> _loadSignals() async {
    if (_isFirstLoad) {
      setState(() => _isFirstLoad = false);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    AppProvider appProvider = Provider.of<AppProvider>(context);
    final signalsAggrOpen = appProvider.signalAggrsOpen;

    // Theme-aware colors
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8F9FA);
    final surfaceColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final shimmerBase = isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFE0E0E0);
    final shimmerHighlight = isDarkMode ? Color(0xFF3D3D3D) : Color(0xFFF0F0F0);

    if (signalsAggrOpen.isEmpty) {
      return _SignalsLoadingPage(
        isDarkMode: isDarkMode,
        backgroundColor: backgroundColor,
        surfaceColor: surfaceColor,
        shimmerBase: shimmerBase,
        shimmerHighlight: shimmerHighlight,
      );
    }

    return SignalsPage(
      key: ValueKey('signals_${signalsAggrOpen.length}'),
      type: widget.type,
      signalsAggrOpen: signalsAggrOpen,
      controllerLength: signalsAggrOpen.length,
    );
  }
}

class _SignalsLoadingPage extends StatefulWidget {
  final bool isDarkMode;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const _SignalsLoadingPage({
    required this.isDarkMode,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.shimmerBase,
    required this.shimmerHighlight,
    Key? key,
  }) : super(key: key);

  @override
  State<_SignalsLoadingPage> createState() => __SignalsLoadingPageState();
}

class __SignalsLoadingPageState extends State<_SignalsLoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: _buildLoadingAppBar(),
        elevation: 4,
        shadowColor: widget.isDarkMode ? Colors.black.withOpacity(0.4) : Colors.black12,
        backgroundColor: widget.surfaceColor,
        surfaceTintColor: widget.surfaceColor,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        color: AppCOLORS.yellow,
        backgroundColor: widget.surfaceColor,
        child: CustomScrollView(
          slivers: [
            // Stats Header
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerText(width: 120, height: 24),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard()),
                        SizedBox(width: 12),
                        Expanded(child: _buildStatCard()),
                        SizedBox(width: 12),
                        Expanded(child: _buildStatCard()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading Signals List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildSignalCard(),
                    );
                  },
                  childCount: 8,
                ),
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingAppBar() {
    return Shimmer.fromColors(
      baseColor: widget.shimmerBase,
      highlightColor: widget.shimmerHighlight,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerText({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: widget.shimmerBase,
      highlightColor: widget.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 40,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 60,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard() {
    return Container(
      decoration: BoxDecoration(
        color: widget.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: widget.shimmerBase,
        highlightColor: widget.shimmerHighlight,
        child: Column(
          children: [
            // Header with badge
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: widget.isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFEEEEEE),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              width: 90,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 80,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 40,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
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
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../constants/app_colors.dart';
// import '../../models_providers/app_provider.dart';
// import 'signals_page.dart';
//
// import '../../components/z_card.dart';
//
// class SignalsInitPage extends StatefulWidget {
//   SignalsInitPage({Key? key, required this.type}) : super(key: key);
//   final String type;
//
//   @override
//   State<SignalsInitPage> createState() => _SignalsInitPageState();
// }
//
// class _SignalsInitPageState extends State<SignalsInitPage> with TickerProviderStateMixin {
//   String search = '';
//   bool isLoadingInit = true;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     final signalsAggrOpen = appProvider.signalAggrsOpen;
//     print('signalsAggrOpen.length: ${signalsAggrOpen.length}');
//
//     if (signalsAggrOpen.length == 0) return SignalsInitLoadingPage();
//
//     return SignalsPage(
//       key: ObjectKey(signalsAggrOpen.length),
//       type: widget.type,
//       signalsAggrOpen: signalsAggrOpen,
//       controllerLength: signalsAggrOpen.length,
//     );
//   }
// }
//
// class SignalsInitLoadingPage extends StatelessWidget {
//   const SignalsInitLoadingPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;
//     return Scaffold(
//       appBar: AppBar(
//         title: Shimmer.fromColors(
//           baseColor: Colors.grey.shade700,
//           highlightColor: Colors.grey.shade500,
//           child: Row(
//             children: [
//               Container(
//                 width: 200.0,
//                 height: 20.0,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4.0),
//                   child: Container(color: Colors.white),
//                 ),
//               ),
//               SizedBox(width: 8),
//               Spacer(),
//               SizedBox(width: 32),
//               Container(
//                 width: 60.0,
//                 height: 20.0,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4.0),
//                   child: Container(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           for (var i = 0; i < 10; i++)
//             ZCard(
//               padding: EdgeInsets.all(10),
//               borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
//               margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey.shade700,
//                 highlightColor: Colors.grey.shade500,
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 60.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Container(
//                               width: 90.0,
//                               height: 20.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 child: Container(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 32),
//                           Container(
//                             width: 60.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Container(
//                             width: 80.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Spacer(),
//                           SizedBox(width: 32),
//                           Container(
//                             width: 60.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Container(
//                             width: 100.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Spacer(),
//                           SizedBox(width: 32),
//                           Container(
//                             width: 60.0,
//                             height: 20.0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4.0),
//                               child: Container(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               width: 100.0,
//                               height: 20.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 child: Container(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               width: 100.0,
//                               height: 20.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(4.0),
//                                 child: Container(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
