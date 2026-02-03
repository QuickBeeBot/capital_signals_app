import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:signalbyt/pages/signals/signal_analysis_page.dart';
import 'package:signalbyt/pages/user/tradingview_page.dart';
import '../constants/app_colors.dart';
import '../models/signal_aggr_open.dart';
import '../models_providers/app_controls_provider.dart';
import '../utils/Z_get_pips_percent.dart';
import '../utils/z_format.dart';
import 'z_card.dart';
import 'package:rive/rive.dart' as rive;

class ZSignalCard extends StatefulWidget {
  const ZSignalCard({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<ZSignalCard> createState() => _ZSignalCardState();
}

class _ZSignalCardState extends State<ZSignalCard> with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    _isExpanded ? _expandController.forward() : _expandController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const Color profitColor = Color(0xFF00C853);
    const Color lossColor = Color(0xFFD32F2F);

    final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final surfaceColor = isDarkMode ? Color(0xFF252525) : Color(0xFFF9FAFB);
    final textPrimary = isDarkMode ? Color(0xFFE8E8E8) : Color(0xFF121212);
    final textSecondary = isDarkMode ? Color(0xFF999999) : Color(0xFF757575);
    final accentColor = AppCOLORS.yellow;
    final borderColor = isDarkMode ? Color(0xFF303030) : Color(0xFFE6E6E6);
    final cardShadow = isDarkMode
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
    );

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
            cardShadow,
            if (_isHovering)
              BoxShadow(
                color: accentColor.withOpacity(0.12),
                blurRadius: 24,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Header with subtle gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.signal.entryType == 'Long'
                          ? profitColor.withOpacity(isDarkMode ? 0.12 : 0.06)
                          : lossColor.withOpacity(isDarkMode ? 0.12 : 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Symbol and Type
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildSignalTypeBadge(widget.signal.entryType, isDarkMode, profitColor, lossColor),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.signal.symbol,
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Opened ${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Status Indicator
                          _buildStatusIndicator(widget.signal, isDarkMode, profitColor, lossColor),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Entry Price and Stop Loss
                      Row(
                        children: [
                          _buildPriceCard(
                            label: 'Entry',
                            value: ZFormat.toPrecision(widget.signal.entryPrice, 6).toString(),
                            icon: Icons.price_change_outlined,
                            color: accentColor,
                            isDarkMode: isDarkMode,
                          ),
                          SizedBox(width: 10),
                          _buildPriceCard(
                            label: 'Stop Loss',
                            value: ZFormat.toPrecision(widget.signal.stopLoss, 6).toString(),
                            icon: Icons.gpp_bad_outlined,
                            color: lossColor,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              Container(
                height: 0.8,
                color: borderColor,
              ),

              // Current Price / Expandable Section
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: _buildCurrentPriceSection(isDarkMode, textPrimary, textSecondary, profitColor, lossColor),
                  ),
                ),
              ),

              // Expandable Targets Section
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1.0,
                child: _buildTargetsSection(isDarkMode, textPrimary, textSecondary, accentColor, profitColor, lossColor),
              ),

              // Action Buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border(
                    top: BorderSide(color: borderColor, width: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    _buildActionButton(
                      label: 'Chart',
                      icon: Icons.candlestick_chart_outlined,
                      onTap: () => Get.to(
                            () => TradingViewPage(symbol: widget.signal.symbol),
                        transition: Transition.cupertino,
                        duration: Duration(milliseconds: 400),
                      ),
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                    ),
                    if (widget.signal.gerHasAnalysis()) SizedBox(width: 10),
                    if (widget.signal.gerHasAnalysis())
                      _buildActionButton(
                        label: 'Analysis',
                        icon: Icons.auto_graph_outlined,
                        onTap: () => Get.to(
                              () => SignalAnalysisPage(signal: widget.signal),
                          transition: Transition.cupertino,
                          duration: Duration(milliseconds: 400),
                        ),
                        isDarkMode: isDarkMode,
                        accentColor: accentColor,
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

  Widget _buildSignalTypeBadge(String type, bool isDarkMode, final profitColor, final lossColor) {
    final isLong = type == 'Long';
    String signal = type == 'Long' ? 'BUY' : 'SELL';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLong
            ? profitColor.withOpacity(isDarkMode ? 0.15 : 0.08)
            : lossColor.withOpacity(isDarkMode ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isLong ? profitColor.withOpacity(0.25) : lossColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLong ? Icons.trending_up : Icons.trending_down,
            size: 13,
            color: isLong ? profitColor : lossColor,
          ),
          SizedBox(width: 5),
          Text(
            signal,
            // type.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isLong ? profitColor : lossColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Signal signal, bool isDarkMode, final profitColor, final lossColor) {
    String status = 'Active';
    Color statusColor = AppCOLORS.yellow;
    IconData statusIcon = Icons.bolt_outlined;

    if (signal.takeProfit3Hit) {
      status = 'TP3';
      statusColor = profitColor;
      statusIcon = Icons.star;
    } else if (signal.takeProfit2Hit) {
      status = 'TP2';
      statusColor = profitColor;
      statusIcon = Icons.star_half;
    } else if (signal.takeProfit1Hit) {
      status = 'TP1';
      statusColor = profitColor;
      statusIcon = Icons.star_border;
    } else if (signal.stopLossHit) {
      status = 'Stopped';
      statusColor = lossColor;
      statusIcon = Icons.close;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(isDarkMode ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 13, color: statusColor),
          SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF282828) : Color(0xFFFBFCFD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Color(0xFF383838) : Color(0xFFE8E8E8),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Color(0xFFB0B0B0) : Color(0xFF757575),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : Color(0xFF121212),
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 3),
            Text(
              getPipsOrPercentStr(
                isPips: widget.signal.market == 'forex',
                pips: widget.signal.stopLossPips,
                percent: widget.signal.stopLossPct,
              ),
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Color(0xFF999999) : Color(0xFF888888),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPriceSection(bool isDarkMode, Color textPrimary, Color textSecondary, final profitColor, final lossColor) {
    final AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context);
    final hasApiAccess = appControlsProvider.appControls.apiHasAccess;
    final isForex = widget.signal.market == 'forex';
    final entryVsCurrentPrice = widget.signal.compareEntryPriceWithCurrentPrice(
      price: appControlsProvider.getWSSymbolPrice(widget.signal),
      isPips: isForex,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasApiAccess ? 'Current' : 'Targets',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              if (hasApiAccess) SizedBox(height: 3),
              if (hasApiAccess)
                Text(
                  appControlsProvider.getWSSymbolPrice(widget.signal).toString(),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
            ],
          ),
        ),
        if (hasApiAccess)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'P/L',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                getPipsOrPercentStr(
                  isPips: isForex,
                  pips: entryVsCurrentPrice,
                  percent: entryVsCurrentPrice,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: entryVsCurrentPrice < 0 ? lossColor : profitColor,
                ),
              ),
            ],
          ),
        SizedBox(width: 12),
        RotationTransition(
          turns: Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation),
          child: Icon(
            Icons.expand_more,
            color: Colors.blue,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetsSection(bool isDarkMode, Color textPrimary, Color textSecondary, Color accentColor, final profitColor, final lossColor) {
    final targets = [
      _TargetData('Target 1', widget.signal.takeProfit1, widget.signal.takeProfit1Pct,
          widget.signal.takeProfit1Pips, widget.signal.takeProfit1Result, widget.signal.takeProfit1DateTime),
      _TargetData('Target 2', widget.signal.takeProfit2, widget.signal.takeProfit2Pct,
          widget.signal.takeProfit2Pips, widget.signal.takeProfit2Result, widget.signal.takeProfit2DateTime),
      _TargetData('Target 3', widget.signal.takeProfit3, widget.signal.takeProfit3Pct,
          widget.signal.takeProfit3Pips, widget.signal.takeProfit3Result, widget.signal.takeProfit3DateTime),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF282828) : Color(0xFFFBFCFD),
        border: Border(
          top: BorderSide(color: isDarkMode ? Color(0xFF383838) : Color(0xFFE8E8E8), width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profit Targets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 10),
          ...targets.map((target) => _buildTargetCard(target, isDarkMode, textPrimary, textSecondary, profitColor, lossColor)),
          SizedBox(height: 14),
          if (widget.signal.comment.isNotEmpty)
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(isDarkMode ? 0.09 : 0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: accentColor.withOpacity(0.18),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 14, color: accentColor),
                      SizedBox(width: 6),
                      Text(
                        'Comment',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    widget.signal.comment,
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                      height: 1.45,
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

  Widget _buildTargetCard(_TargetData target, bool isDarkMode, Color textPrimary, Color textSecondary, final profitColor, final lossColor) {
    final isHit = target.result == 'profit';
    final isForex = widget.signal.market == 'forex';

    return Container(
      margin: EdgeInsets.only(bottom: 7),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isHit
            ? profitColor.withOpacity(isDarkMode ? 0.15 : 0.08)
            : (isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFFBFCFD)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHit
              ? profitColor.withOpacity(0.25)
              : (isDarkMode ? Color(0xFF383838) : Color(0xFFE8E8E8)),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Target Number
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isHit ? profitColor : (isDarkMode ? Color(0xFF383838) : Color(0xFFE6E6E6)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                target.name.split(' ')[1],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isHit ? Colors.white : textSecondary,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),

          // Target Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  ZFormat.toPrecision(target.price, 6).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isHit ? profitColor : textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Pips/Percent
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isForex ? 'Pips' : '%',
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 3),
              Text(
                getPipsOrPercentStr(
                  isPips: isForex,
                  pips: target.pips,
                  percent: target.percent,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isHit ? profitColor : textPrimary,
                ),
              ),
            ],
          ),

          // Status Icon
          if (isHit) ...[
            SizedBox(width: 10),
            Icon(Icons.check, color: profitColor, size: 18),
            if (target.resultTime != null) SizedBox(width: 6),
            if (target.resultTime != null)
              Text(
                ZFormat.dateFormatSignal(target.resultTime!),
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                  height: 1.3,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
    required Color accentColor,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11, horizontal: 14),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDarkMode ? Color(0xFF383838) : Color(0xFFE8E8E8),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: accentColor),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Color(0xFF121212),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetData {
  final String name;
  final num price;
  final num percent;
  final num pips;
  final String result;
  final DateTime? resultTime;

  _TargetData(this.name, this.price, this.percent, this.pips, this.result, this.resultTime);
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:rive/rive.dart' hide LinearGradient;
// import 'package:signalbyt/pages/signals/signal_analysis_page.dart';
// import 'package:signalbyt/pages/user/tradingview_page.dart';
// import '../constants/app_colors.dart';
// import '../models/signal_aggr_open.dart';
// import '../models_providers/app_controls_provider.dart';
// import '../utils/Z_get_pips_percent.dart';
// import '../utils/z_format.dart';
// import 'z_card.dart';
// import 'package:rive/rive.dart' as rive;
// import 'package:rive/rive.dart' hide LinearGradient;
//
// class ZSignalCard extends StatefulWidget {
//   const ZSignalCard({Key? key, required this.signal}) : super(key: key);
//   final Signal signal;
//
//   @override
//   State<ZSignalCard> createState() => _ZSignalCardState();
// }
//
// class _ZSignalCardState extends State<ZSignalCard> with SingleTickerProviderStateMixin {
//   late AnimationController _expandController;
//   late Animation<double> _expandAnimation;
//   bool _isExpanded = false;
//   bool _isHovering = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _expandController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     _expandAnimation = CurvedAnimation(
//       parent: _expandController,
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _expandController.dispose();
//     super.dispose();
//   }
//
//   void _toggleExpand() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//     });
//     if (_isExpanded) {
//       _expandController.forward();
//     } else {
//       _expandController.reverse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     // Premium color palette - ADD THESE LINES
//     const Color profitColor = Color(0xFF00C853); // Material Green A700
//     const Color lossColor = Color(0xFFD32F2F); // Material Red 700
//
//     // Premium color palette
//     final backgroundColor = isDarkMode ? Color(0xFF1A1A1A) : Colors.white;
//     final surfaceColor = isDarkMode ? Color(0xFF242424) : Color(0xFFF8F9FA);
//     final textPrimary = isDarkMode ? Color(0xFFE1E1E1) : Color(0xFF1A1A1A);
//     final textSecondary = isDarkMode ? Color(0xFF888888) : Color(0xFF666666);
//     final accentColor = AppCOLORS.yellow;
//     //final profitColor = Color(0xFF00C853); // Material Green A700
//     // final lossColor = Color(0xFFD32F2F); // Material Red 700
//     final borderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
//     final cardShadow = isDarkMode
//         ? BoxShadow(
//       color: Colors.black.withOpacity(0.5),
//       blurRadius: 20,
//       spreadRadius: 2,
//       offset: Offset(0, 4),
//     )
//         : BoxShadow(
//       color: Colors.blueGrey.withOpacity(0.1),
//       blurRadius: 20,
//       spreadRadius: 2,
//       offset: Offset(0, 8),
//     );
//
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovering = true),
//       onExit: (_) => setState(() => _isHovering = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: backgroundColor,
//           border: Border.all(
//             color: _isHovering ? accentColor.withOpacity(0.3) : borderColor,
//             width: _isHovering ? 2 : 1,
//           ),
//           boxShadow: [
//             cardShadow,
//             if (_isHovering)
//               BoxShadow(
//                 color: accentColor.withOpacity(0.1),
//                 blurRadius: 30,
//                 spreadRadius: 5,
//               ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Column(
//             children: [
//               // Header with gradient
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       widget.signal.entryType == 'Long'
//                           ? profitColor.withOpacity(isDarkMode ? 0.2 : 0.1)
//                           : lossColor.withOpacity(isDarkMode ? 0.2 : 0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Symbol and Type
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   _buildSignalTypeBadge(widget.signal.entryType, isDarkMode, profitColor, lossColor),
//                                   SizedBox(width: 12),
//                                   Text(
//                                     widget.signal.symbol,
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.w800,
//                                       color: textPrimary,
//                                       letterSpacing: -0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'Opened ${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: textSecondary,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Status Indicator
//                           _buildStatusIndicator(widget.signal, isDarkMode, profitColor, lossColor),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       // Entry Price and Stop Loss
//                       Row(
//                         children: [
//                           _buildPriceCard(
//                             label: 'Entry Price',
//                             value: ZFormat.toPrecision(widget.signal.entryPrice, 8).toString(),
//                             icon: Icons.price_change_outlined,
//                             color: accentColor,
//                             isDarkMode: isDarkMode,
//                           ),
//                           SizedBox(width: 12),
//                           _buildPriceCard(
//                             label: 'Stop Loss',
//                             value: ZFormat.toPrecision(widget.signal.stopLoss, 8).toString(),
//                             icon: Icons.warning_outlined,
//                             color: lossColor,
//                             isDarkMode: isDarkMode,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Divider
//               Container(
//                 height: 1,
//                 color: borderColor,
//               ),
//
//               // Current Price / Expandable Section
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: _toggleExpand,
//                   borderRadius: BorderRadius.zero,
//                   child: Padding(
//                     padding: EdgeInsets.all(20),
//                     child: _buildCurrentPriceSection(isDarkMode, textPrimary, textSecondary, profitColor, lossColor),
//                   ),
//                 ),
//               ),
//
//               // Expandable Targets Section - Now using SizeTransition
//               SizeTransition(
//                 sizeFactor: _expandAnimation,
//                 axisAlignment: -1.0,
//                 child: _buildTargetsSection(isDarkMode, textPrimary, textSecondary, accentColor, profitColor, lossColor),
//               ),
//
//               // Action Buttons
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: surfaceColor,
//                   border: Border(
//                     top: BorderSide(color: borderColor, width: 1),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     _buildActionButton(
//                       label: 'View Chart',
//                       icon: Icons.timeline_outlined,
//                       onTap: () => Get.to(
//                             () => TradingViewPage(symbol: widget.signal.symbol),
//                         transition: Transition.cupertino,
//                         duration: Duration(milliseconds: 500),
//                       ),
//                       isDarkMode: isDarkMode,
//                       accentColor: accentColor,
//                     ),
//                     if (widget.signal.gerHasAnalysis()) SizedBox(width: 12),
//                     if (widget.signal.gerHasAnalysis())
//                       _buildActionButton(
//                         label: 'Analysis',
//                         icon: Icons.analytics_outlined,
//                         onTap: () => Get.to(
//                               () => SignalAnalysisPage(signal: widget.signal),
//                           transition: Transition.cupertino,
//                           duration: Duration(milliseconds: 500),
//                         ),
//                         isDarkMode: isDarkMode,
//                         accentColor: accentColor,
//                       ),
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
//   Widget _buildSignalTypeBadge(String type, bool isDarkMode, final profitColor, final lossColor) {
//     final isLong = type == 'Long';
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isLong
//             ? profitColor.withOpacity(isDarkMode ? 0.2 : 0.1)
//             : lossColor.withOpacity(isDarkMode ? 0.2 : 0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isLong ? profitColor.withOpacity(0.3) : lossColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isLong ? Icons.trending_up : Icons.trending_down,
//             size: 14,
//             color: isLong ? profitColor : lossColor,
//           ),
//           SizedBox(width: 6),
//           Text(
//             type.toUpperCase(),
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: isLong ? profitColor : lossColor,
//               letterSpacing: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusIndicator(Signal signal, bool isDarkMode, final profitColor, final lossColor) {
//     String status = 'In Progress';
//     Color statusColor = AppCOLORS.yellow;
//     IconData statusIcon = Icons.timelapse_outlined;
//
//     if (signal.takeProfit3Hit) {
//       status = 'Target 3';
//       statusColor = profitColor;
//       statusIcon = Icons.star_outlined;
//     } else if (signal.takeProfit2Hit) {
//       status = 'Target 2';
//       statusColor = profitColor;
//       statusIcon = Icons.star_half_outlined;
//     } else if (signal.takeProfit1Hit) {
//       status = 'Target 1';
//       statusColor = profitColor;
//       statusIcon = Icons.star_border_outlined;
//     } else if (signal.stopLossHit) {
//       status = 'Stopped';
//       statusColor = lossColor;
//       statusIcon = Icons.close_outlined;
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(isDarkMode ? 0.2 : 0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: statusColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(statusIcon, size: 14, color: statusColor),
//           SizedBox(width: 6),
//           Text(
//             status,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: statusColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriceCard({
//     required String label,
//     required String value,
//     required IconData icon,
//     required Color color,
//     required bool isDarkMode,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isDarkMode ? Color(0xFF242424) : Color(0xFFF5F5F5),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isDarkMode ? Color(0xFF333333) : Color(0xFFEEEEEE),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: 16, color: color),
//                 SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isDarkMode ? Color(0xFFAAAAAA) : Color(0xFF666666),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isDarkMode ? Colors.white : Color(0xFF1A1A1A),
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               getPipsOrPercentStr(
//                 isPips: widget.signal.market == 'forex',
//                 pips: widget.signal.stopLossPips,
//                 percent: widget.signal.stopLossPct,
//               ),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isDarkMode ? Color(0xFF888888) : Color(0xFF888888),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCurrentPriceSection(bool isDarkMode, Color textPrimary, Color textSecondary, final profitColor, final lossColor) {
//     final AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context);
//     final hasApiAccess = appControlsProvider.appControls.apiHasAccess;
//     final isForex = widget.signal.market == 'forex';
//     final entryVsCurrentPrice = widget.signal.compareEntryPriceWithCurrentPrice(
//       price: appControlsProvider.getWSSymbolPrice(widget.signal),
//       isPips: isForex,
//     );
//
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 hasApiAccess ? 'Current Price' : 'Target Overview',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: textSecondary,
//                 ),
//               ),
//               if (hasApiAccess) SizedBox(height: 4),
//               if (hasApiAccess)
//                 Text(
//                   appControlsProvider.getWSSymbolPrice(widget.signal).toString(),
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     color: textPrimary,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         if (hasApiAccess)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'P/L',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: textSecondary,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 getPipsOrPercentStr(
//                   isPips: isForex,
//                   pips: entryVsCurrentPrice,
//                   percent: entryVsCurrentPrice,
//                 ),
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                   color: entryVsCurrentPrice < 0 ? lossColor : profitColor,
//                 ),
//               ),
//             ],
//           ),
//         SizedBox(width: 16),
//         AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: _expandAnimation,
//           color: AppCOLORS.yellow,
//           size: 28,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTargetsSection(bool isDarkMode, Color textPrimary, Color textSecondary, Color accentColor, final profitColor, final lossColor) {
//     final targets = [
//       _TargetData('Target 1', widget.signal.takeProfit1, widget.signal.takeProfit1Pct,
//           widget.signal.takeProfit1Pips, widget.signal.takeProfit1Result, widget.signal.takeProfit1DateTime),
//       _TargetData('Target 2', widget.signal.takeProfit2, widget.signal.takeProfit2Pct,
//           widget.signal.takeProfit2Pips, widget.signal.takeProfit2Result, widget.signal.takeProfit2DateTime),
//       _TargetData('Target 3', widget.signal.takeProfit3, widget.signal.takeProfit3Pct,
//           widget.signal.takeProfit3Pips, widget.signal.takeProfit3Result, widget.signal.takeProfit3DateTime),
//     ];
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Color(0xFF242424) : Color(0xFFF8F9FA),
//         border: Border(
//           top: BorderSide(color: isDarkMode ? Color(0xFF333333) : Color(0xFFEEEEEE), width: 1),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Profit Targets',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: textPrimary,
//             ),
//           ),
//           SizedBox(height: 12),
//           ...targets.map((target) => _buildTargetCard(target, isDarkMode, textPrimary, textSecondary, profitColor, lossColor)),
//           SizedBox(height: 16),
//           if (widget.signal.comment.isNotEmpty)
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: accentColor.withOpacity(isDarkMode ? 0.1 : 0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: accentColor.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.comment_outlined, size: 16, color: accentColor),
//                       SizedBox(width: 8),
//                       Text(
//                         'Trader\'s Comment',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: accentColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     widget.signal.comment,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: textSecondary,
//                       height: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTargetCard(_TargetData target, bool isDarkMode, Color textPrimary, Color textSecondary, final profitColor, final lossColor) {
//     final isHit = target.result == 'profit';
//     final isForex = widget.signal.market == 'forex';
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isHit
//             ? profitColor.withOpacity(isDarkMode ? 0.2 : 0.1)
//             : (isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFF5F5F5)),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isHit
//               ? profitColor.withOpacity(0.3)
//               : (isDarkMode ? Color(0xFF333333) : Color(0xFFEEEEEE)),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Target Number
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: isHit ? profitColor : (isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 target.name.split(' ')[1],
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   color: isHit ? Colors.white : textSecondary,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//
//           // Target Price
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   target.name,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   ZFormat.toPrecision(target.price, 8).toString(),
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: isHit ? profitColor : textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Pips/Percent
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 isForex ? 'Pips' : '%',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: textSecondary,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 getPipsOrPercentStr(
//                   isPips: isForex,
//                   pips: target.pips,
//                   percent: target.percent,
//                 ),
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: isHit ? profitColor : textPrimary,
//                 ),
//               ),
//             ],
//           ),
//
//           // Status Icon
//           if (isHit) ...[
//             SizedBox(width: 12),
//             Icon(Icons.check_circle_outlined, color: profitColor, size: 20),
//             if (target.resultTime != null) SizedBox(width: 8),
//             if (target.resultTime != null)
//               Text(
//                 ZFormat.dateFormatSignal(target.resultTime!),
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: textSecondary,
//                 ),
//               ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required String label,
//     required IconData icon,
//     required VoidCallback onTap,
//     required bool isDarkMode,
//     required Color accentColor,
//   }) {
//     return Expanded(
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//             decoration: BoxDecoration(
//               color: isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isDarkMode ? Color(0xFF333333) : Color(0xFFEEEEEE),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 18, color: accentColor),
//                 SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isDarkMode ? Colors.white : Color(0xFF1A1A1A),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _TargetData {
//   final String name;
//   final num price;
//   final num percent;
//   final num pips;
//   final String result;
//   final DateTime? resultTime;
//
//   _TargetData(this.name, this.price, this.percent, this.pips, this.result, this.resultTime);
// }
//
//
//
