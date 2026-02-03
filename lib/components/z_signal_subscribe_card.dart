import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../models/signal_aggr_open.dart';
import '../pages/subsciption/subscription_page.dart';
import '../utils/z_format.dart';

class ZSignalSubscribeCard extends StatefulWidget {
  const ZSignalSubscribeCard({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<ZSignalSubscribeCard> createState() => _ZSignalSubscribeCardState();
}

class _ZSignalSubscribeCardState extends State<ZSignalSubscribeCard> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  bool _isButtonHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
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

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _scaleController.forward();
  }

  void _onTapUp() {
    _scaleController.reverse();
    // EXACT NAVIGATION YOU SPECIFIED
    Get.to(
          () => SubscriptionPage(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212);
    final textSecondary = isDarkMode ? Color(0xFF999999) : Color(0xFF757575);
    final accentColor = AppCOLORS.yellow;
    final borderColor = isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
          border: Border.all(
            color: _isHovering ? accentColor.withOpacity(0.4) : borderColor,
            width: _isHovering ? 1.5 : 1,
          ),
          boxShadow: [
            isDarkMode
                ? BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
                : BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
            if (_isHovering)
              BoxShadow(
                color: accentColor.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Signal Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.signal.entryType == 'Long'
                          ? Color(0xFF00C853).withOpacity(isDarkMode ? 0.1 : 0.05)
                          : Color(0xFFD32F2F).withOpacity(isDarkMode ? 0.1 : 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    _buildSignalTypeBadge(widget.signal.entryType, isDarkMode),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.signal.symbol,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Signal opened ${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(isDarkMode ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline, size: 12, color: accentColor),
                          SizedBox(width: 4),
                          Text(
                            'PREMIUM',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(height: 0.8, color: borderColor),

              // ===== PROMINENT CTA BUTTON =====
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity, // Ensure it takes available width
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isButtonHovering = true),
                  onExit: (_) => setState(() => _isButtonHovering = false),
                  child: GestureDetector(
                    onTap: () {
                      // Your tap handler
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor, // Start with solid color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stars, size: 18, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Join Premium Signals',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(16),
              //   child: MouseRegion(
              //     onEnter: (_) => setState(() => _isButtonHovering = true),
              //     onExit: (_) => setState(() => _isButtonHovering = false),
              //     child: GestureDetector(
              //       onTapDown: (_) => _onTapDown(),
              //       onTapUp: (_) => _onTapUp(),
              //       onTapCancel: () => _scaleController.reverse(),
              //       child: ScaleTransition(
              //         scale: _scaleAnimation,
              //         child: Container(
              //           height: 48,
              //           decoration: BoxDecoration(
              //             gradient: LinearGradient(
              //               colors: [
              //                 accentColor.withOpacity(_isButtonHovering ? 0.95 : 0.9),
              //                 accentColor.withOpacity(_isButtonHovering ? 0.85 : 0.8),
              //               ],
              //             ),
              //             borderRadius: BorderRadius.circular(12),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: accentColor.withOpacity(_isButtonHovering ? 0.45 : 0.35),
              //                 blurRadius: _isButtonHovering ? 14 : 10,
              //                 spreadRadius: _isButtonHovering ? 3 : 2,
              //               ),
              //             ],
              //           ),
              //           child: Center(
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Icon(Icons.stars, size: 18, color: Colors.white),
              //                 SizedBox(width: 10),
              //                 Text(
              //                   'Join Premium Signals',
              //                   style: TextStyle(
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.w700,
              //                     color: Colors.white,
              //                     letterSpacing: 0.4,
              //                   ),
              //                 ),
              //                 SizedBox(width: 8),
              //                 Icon(Icons.arrow_forward, size: 16, color: Colors.white),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // ================================

              // Subtle value proposition hint
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Live signals • Advanced analysis • Real-time alerts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalTypeBadge(String type, bool isDarkMode) {
    final isLong = type == 'Long';
    String signal = type == 'Long' ? 'BUY' : 'SELL';
    final badgeColor = isLong ? Color(0xFF00C853) : Color(0xFFD32F2F);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(isDarkMode ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: badgeColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLong ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: badgeColor,
          ),
          SizedBox(width: 4),
          Text(
            signal,
            // type.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: badgeColor,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../constants/app_colors.dart';
// import '../models/signal_aggr_open.dart';
// import '../pages/subsciption/subscription_page.dart';
// import '../utils/z_format.dart';
//
// class ZSignalSubscribeCard extends StatefulWidget {
//   const ZSignalSubscribeCard({Key? key, required this.signal}) : super(key: key);
//   final Signal signal;
//
//   @override
//   State<ZSignalSubscribeCard> createState() => _ZSignalSubscribeCardState();
// }
//
// class _ZSignalSubscribeCardState extends State<ZSignalSubscribeCard> with SingleTickerProviderStateMixin {
//   bool _isHovering = false;
//   late AnimationController _scaleController;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 150),
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.easeOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _scaleController.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown() {
//     _scaleController.forward();
//   }
//
//   void _onTapUp() {
//     _scaleController.reverse();
//     Get.to(
//           () => SubscriptionPage(),
//       fullscreenDialog: true,
//       transition: Transition.rightToLeft,
//       duration: Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     // Premium color palette matching ZSignalCard
//     final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
//     final surfaceColor = isDarkMode ? Color(0xFF252525) : Color(0xFFF9FAFB);
//     final textPrimary = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212);
//     final textSecondary = isDarkMode ? Color(0xFF999999) : Color(0xFF757575);
//     final accentColor = AppCOLORS.yellow;
//     final borderColor = isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6);
//     final gradientStart = isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F2F5);
//     final gradientEnd = isDarkMode ? Color(0xFF222222) : Color(0xFFE8EAED);
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovering = true),
//       onExit: (_) => setState(() => _isHovering = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 250),
//         margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: backgroundColor,
//           border: Border.all(
//             color: _isHovering ? accentColor.withOpacity(0.4) : borderColor,
//             width: _isHovering ? 1.5 : 1,
//           ),
//           boxShadow: [
//             isDarkMode
//                 ? BoxShadow(
//               color: Colors.black.withOpacity(0.4),
//               blurRadius: 16,
//               spreadRadius: 1,
//               offset: Offset(0, 3),
//             )
//                 : BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 16,
//               spreadRadius: 1,
//               offset: Offset(0, 4),
//             ),
//             if (_isHovering)
//               BoxShadow(
//                 color: accentColor.withOpacity(0.15),
//                 blurRadius: 20,
//                 spreadRadius: 2,
//               ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Column(
//             children: [
//               // Signal Header with "Limited Access" indicator
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       widget.signal.entryType == 'Long'
//                           ? Color(0xFF00C853).withOpacity(isDarkMode ? 0.1 : 0.05)
//                           : Color(0xFFD32F2F).withOpacity(isDarkMode ? 0.1 : 0.05),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     // Signal Type Badge
//                     _buildSignalTypeBadge(widget.signal.entryType, isDarkMode),
//                     SizedBox(width: 10),
//
//                     // Symbol & Time
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.signal.symbol,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: textPrimary,
//                               letterSpacing: -0.4,
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             'Signal opened ${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
//                             style: TextStyle(
//                               fontSize: 11.5,
//                               color: textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Limited Access Badge
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: accentColor.withOpacity(isDarkMode ? 0.15 : 0.08),
//                         borderRadius: BorderRadius.circular(4),
//                         border: Border.all(
//                           color: accentColor.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.lock_outline,
//                             size: 12,
//                             color: accentColor,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'PREMIUM',
//                             style: TextStyle(
//                               fontSize: 9.5,
//                               fontWeight: FontWeight.w800,
//                               color: accentColor,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Divider
//               Container(
//                 height: 0.8,
//                 color: borderColor,
//               ),
//
//               // CTA Section with animated scale
//               GestureDetector(
//                 onTapDown: (_) => _onTapDown(),
//                 onTapUp: (_) => _onTapUp(),
//                 onTapCancel: () => _scaleController.reverse(),
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: Container(
//                     height: 68,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           gradientStart,
//                           gradientEnd,
//                         ],
//                       ),
//                       border: Border(
//                         top: BorderSide(color: borderColor, width: 0.8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Animated Shine Effect
//                         AnimatedBuilder(
//                           animation: _scaleController,
//                           builder: (context, child) {
//                             return Container(
//                               width: 28,
//                               height: 28,
//                               decoration: BoxDecoration(
//                                 color: accentColor.withOpacity(0.15),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.stars,
//                                 size: 16,
//                                 color: accentColor,
//                               ),
//                             );
//                           },
//                         ),
//                         SizedBox(width: 10),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Unlock Full Signal Access',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 color: textPrimary,
//                                 letterSpacing: -0.3,
//                               ),
//                             ),
//                             SizedBox(height: 2),
//                             Text(
//                               'Live signals • Advanced analysis • Real-time alerts',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: textSecondary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                         SizedBox(width: 8),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 14,
//                           color: accentColor.withOpacity(0.85),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignalTypeBadge(String type, bool isDarkMode) {
//     final isLong = type == 'Long';
//     final badgeColor = isLong ? Color(0xFF00C853) : Color(0xFFD32F2F);
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//       decoration: BoxDecoration(
//         color: badgeColor.withOpacity(isDarkMode ? 0.15 : 0.08),
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//           color: badgeColor.withOpacity(0.25),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isLong ? Icons.trending_up : Icons.trending_down,
//             size: 12,
//             color: badgeColor,
//           ),
//           SizedBox(width: 4),
//           Text(
//             type.toUpperCase(),
//             style: TextStyle(
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               color: badgeColor,
//               letterSpacing: 0.7,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }