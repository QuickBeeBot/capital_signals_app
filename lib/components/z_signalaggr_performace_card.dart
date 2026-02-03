import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models_providers/app_controls_provider.dart';
import '../utils/z_format.dart';
import '../models/signal_aggr_open.dart';
import '../constants/app_colors.dart';

class ZSignalAggrPerformaceCard extends StatefulWidget {
  const ZSignalAggrPerformaceCard({super.key, required this.signalAggrOpen});
  final SignalAggrOpen signalAggrOpen;

  @override
  State<ZSignalAggrPerformaceCard> createState() => _ZSignalAggrPerformaceCardState();
}

class _ZSignalAggrPerformaceCardState extends State<ZSignalAggrPerformaceCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Premium color system matching ZSignalCard
    final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final surfaceColor = isDarkMode ? Color(0xFF252525) : Color(0xFFF9FAFB);
    final textPrimary = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212);
    final textSecondary = isDarkMode ? Color(0xFF999999) : Color(0xFF757575);
    final borderColor = isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6);
    final profitColor = Color(0xFF00C853); // Consistent with ZSignalCard
    final lossColor = Color(0xFFD32F2F);   // Consistent with ZSignalCard
    final mediumColor = Color(0xFFFFA726); // Vibrant but accessible orange
    final accentColor = AppCOLORS.yellow;

    AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context);
    final appControls = appControlsProvider.appControls;

    if (!appControls.showSignalAggrPerformance) return SizedBox.shrink();

    // Performance data with null safety
    final perf7 = widget.signalAggrOpen.performance7Days;
    final perf14 = widget.signalAggrOpen.performance14Days;
    final perf30 = widget.signalAggrOpen.performance30Days;

    // Determine if any performance periods should be displayed
    final shouldShow7 = appControls.showSignalAggrPerformance7Days && (perf7?.trades ?? 0) > 0;
    final shouldShow14 = appControls.showSignalAggrPerformance14Days && (perf14?.trades ?? 0) > 0;
    final shouldShow30 = appControls.showSignalAggrPerformance30Days && (perf30?.trades ?? 0) > 0;

    // Show empty state if no valid performance data to display
    final hasValidData = shouldShow7 || shouldShow14 || shouldShow30;
    if (!hasValidData) {
      return _buildEmptyState(isDarkMode, textPrimary, textSecondary, accentColor);
    }

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
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with refined styling
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(isDarkMode ? 0.15 : 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.analytics_outlined,
                        color: accentColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            'Tracked signal results',
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(isDarkMode ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: accentColor.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.signalAggrOpen.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),

                // Performance Rows
                if (shouldShow7)
                  _buildPerformanceRow(
                    days: 7,
                    trades: (perf7!.trades).toInt(),
                    winRate: perf7.winRate.toDouble(),
                    isDarkMode: isDarkMode,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    profitColor: profitColor,
                    mediumColor: mediumColor,
                    lossColor: lossColor,
                      surfaceColor: surfaceColor
                  ),
                if (shouldShow7 && (shouldShow14 || shouldShow30)) SizedBox(height: 8),

                if (shouldShow14)
                  _buildPerformanceRow(
                    days: 14,
                    trades: (perf14!.trades).toInt(),
                    winRate: perf14.winRate.toDouble(),
                    isDarkMode: isDarkMode,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    profitColor: profitColor,
                    mediumColor: mediumColor,
                    lossColor: lossColor,
                      surfaceColor: surfaceColor
                  ),
                if (shouldShow14 && shouldShow30) SizedBox(height: 8),

                if (shouldShow30)
                  _buildPerformanceRow(
                    days: 30,
                    trades: (perf30!.trades).toInt(),
                    winRate: perf30.winRate.toDouble(),
                    isDarkMode: isDarkMode,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    profitColor: profitColor,
                    mediumColor: mediumColor,
                    lossColor: lossColor,
                    surfaceColor: surfaceColor
                  ),

                // Legend - refined and compact
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(color: profitColor, label: '>60%', isDarkMode: isDarkMode),
                      _buildLegendItem(color: mediumColor, label: '40-60%', isDarkMode: isDarkMode),
                      _buildLegendItem(color: lossColor, label: '<40%', isDarkMode: isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceRow({
    required int days,
    required int trades,
    required double winRate,
    required bool isDarkMode,
    required Color textPrimary,
    required Color textSecondary,
    required Color profitColor,
    required Color mediumColor,
    required Color lossColor,
    required Color surfaceColor,
  }) {
    // Determine win rate color and status
    Color winRateColor;
    String statusLabel;

    if (winRate >= 0.6) {
      winRateColor = profitColor;
      statusLabel = 'Strong';
    } else if (winRate >= 0.4) {
      winRateColor = mediumColor;
      statusLabel = 'Moderate';
    } else {
      winRateColor = lossColor;
      statusLabel = 'Weak';
    }

    final winRatePercent = ZFormat.numToPercent(winRate);
    final winRateValue = winRate.clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Color(0xFF333333) : Color(0xFFE8E8E8),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Period badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppCOLORS.yellow.withOpacity(isDarkMode ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppCOLORS.yellow.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Text(
              '$days',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppCOLORS.yellow,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(width: 12),

          // Trades info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart, size: 14, color: textSecondary),
                    SizedBox(width: 4),
                    Text(
                      '$trades trades',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Completed signals',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Win rate with status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: winRateColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    winRatePercent,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: winRateColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 10.5,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Custom progress bar
          SizedBox(width: 10),
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: FractionallySizedBox(
                widthFactor: winRateValue,
                child: Container(
                  color: winRateColor,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isDarkMode,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Color(0xFFB0B0B0) : Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode, Color textPrimary, Color textSecondary, Color accentColor) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        border: Border.all(
          color: isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: accentColor.withOpacity(0.7),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance data unavailable',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Signal tracking will appear after sufficient trading activity',
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'z_card.dart';
// import '../models_providers/app_controls_provider.dart';
// import '../utils/z_format.dart';
// import '../models/signal_aggr_open.dart';
// import '../../constants/app_colors.dart';
//
// class ZSignalAggrPerformaceCard extends StatelessWidget {
//   const ZSignalAggrPerformaceCard({super.key, required this.signalAggrOpen});
//   final SignalAggrOpen signalAggrOpen;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context);
//     final appControls = appControlsProvider.appControls;
//
//     if (!appControls.showSignalAggrPerformance) return SizedBox.shrink();
//
//     // Theme-aware colors
//     final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
//     final surfaceColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5);
//     final textPrimaryColor = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
//     final textSecondaryColor = isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666);
//     final successColor = Color(0xFF4CAF50); // Green for positive
//     final warningColor = Color(0xFFFF9800); // Orange for neutral
//     final accentColor = AppCOLORS.yellow;
//
//     // Performance data with proper type conversion
//     final performance7Days = signalAggrOpen.performance7Days;
//     final performance14Days = signalAggrOpen.performance14Days;
//     final performance30Days = signalAggrOpen.performance30Days;
//
//     // Convert trades from num to int with proper null handling
//     final trades7Days = (performance7Days?.trades ?? 0).toInt();
//     final trades14Days = (performance14Days?.trades ?? 0).toInt();
//     final trades30Days = (performance30Days?.trades ?? 0).toInt();
//
//     // Win rates (these are likely doubles)
//     final winRate7Days = performance7Days?.winRate ?? 0.0;
//     final winRate14Days = performance14Days?.winRate ?? 0.0;
//     final winRate30Days = performance30Days?.winRate ?? 0.0;
//
//     // Calculate overall performance with proper type conversion
//     final overallTrades = [
//       trades7Days,
//       trades14Days,
//       trades30Days,
//     ].where((t) => t > 0).fold<int>(0, (a, b) => a + b);
//
//     final validWinRates = [
//       if (winRate7Days > 0) winRate7Days,
//       if (winRate14Days > 0) winRate14Days,
//       if (winRate30Days > 0) winRate30Days,
//     ];
//
//     final overallWinRate = validWinRates.isNotEmpty
//         ? validWinRates.reduce((a, b) => a + b) / validWinRates.length
//         : 0.0;
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(
//             color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0),
//             width: 1,
//           ),
//         ),
//         color: backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   Icon(
//                     Icons.trending_up_rounded,
//                     color: accentColor,
//                     size: 20,
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     'Performance Analytics',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: textPrimaryColor,
//                     ),
//                   ),
//                   Spacer(),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: accentColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           signalAggrOpen.name,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: accentColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//
//
//               if (appControls.showSignalAggrPerformance7Days)
//                 _buildPerformanceRow(
//                   days: 7,
//                   trades: trades7Days,
//                   winRate: winRate7Days.toDouble(),
//                   isDarkMode: isDarkMode,
//                   textSecondaryColor: textSecondaryColor,
//                   successColor: successColor,
//                   warningColor: warningColor,
//                 ),
//
//               if (appControls.showSignalAggrPerformance14Days)
//                 _buildPerformanceRow(
//                   days: 14,
//                   trades: trades14Days,
//                   winRate: winRate14Days.toDouble(),
//                   isDarkMode: isDarkMode,
//                   textSecondaryColor: textSecondaryColor,
//                   successColor: successColor,
//                   warningColor: warningColor,
//                 ),
//
//               if (appControls.showSignalAggrPerformance30Days)
//                 _buildPerformanceRow(
//                   days: 30,
//                   trades: trades30Days,
//                   winRate: winRate30Days.toDouble(),
//                   isDarkMode: isDarkMode,
//                   textSecondaryColor: textSecondaryColor,
//                   successColor: successColor,
//                   warningColor: warningColor,
//                 ),
//
//               // Performance Indicator Legend
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: surfaceColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildLegendItem(
//                       color: successColor,
//                       label: 'High (> 60%)',
//                       isDarkMode: isDarkMode,
//                     ),
//                     _buildLegendItem(
//                       color: warningColor,
//                       label: 'Medium (40-60%)',
//                       isDarkMode: isDarkMode,
//                     ),
//                     _buildLegendItem(
//                       color: Colors.red,
//                       label: 'Low (< 40%)',
//                       isDarkMode: isDarkMode,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverallStat({
//     required String label,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required bool isDarkMode,
//   }) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 20,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: isDarkMode ? Colors.white : Color(0xFF1A1A1A),
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPerformanceRow({
//     required int days,
//     required int trades,
//     required double winRate,
//     required bool isDarkMode,
//     required Color textSecondaryColor,
//     required Color successColor,
//     required Color warningColor,
//   }) {
//     final hasData = trades > 0 && winRate > 0;
//     final winRateStr = hasData ? ZFormat.numToPercent(winRate) : '---';
//     final tradesStr = trades > 0 ? trades.toString() : '---';
//
//     // Determine color based on win rate
//     Color winRateColor = textSecondaryColor;
//     if (hasData) {
//       if (winRate >= 0.6) {
//         winRateColor = successColor;
//       } else if (winRate >= 0.4) {
//         winRateColor = warningColor;
//       } else {
//         winRateColor = Colors.red;
//       }
//     }
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           // Time Period
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppCOLORS.yellow.withOpacity(isDarkMode ? 0.2 : 0.1),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               '$days days',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: AppCOLORS.yellow,
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//
//           // Trades Count
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Trades',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: textSecondaryColor,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.bar_chart_outlined,
//                       size: 14,
//                       color: textSecondaryColor,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       tradesStr,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: isDarkMode ? Colors.white : Color(0xFF1A1A1A),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Win Rate
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'Win Rate',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: textSecondaryColor,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: winRateColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       winRateStr,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: winRateColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Progress Indicator
//           if (hasData)
//             Padding(
//               padding: EdgeInsets.only(left: 12),
//               child: SizedBox(
//                 width: 60,
//                 height: 4,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(2),
//                   child: LinearProgressIndicator(
//                     value: winRate.clamp(0.0, 1.0),
//                     backgroundColor: isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFE0E0E0),
//                     color: winRateColor,
//                     minHeight: 4,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegendItem({
//     required Color color,
//     required String label,
//     required bool isDarkMode,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         SizedBox(width: 6),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
