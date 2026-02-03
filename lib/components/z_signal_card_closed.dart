import 'package:flutter/material.dart';
import 'z_card.dart';
import '../models/signal_aggr_open.dart';

import '../utils/Z_get_pips_percent.dart';
import '../utils/z_format.dart';
import '../constants/app_colors.dart';
import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile_null_safety.dart';

class ZSignalClosedCard extends StatefulWidget {
  ZSignalClosedCard({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<ZSignalClosedCard> createState() => _ZSignalClosedCardState();
}

class _ZSignalClosedCardState extends State<ZSignalClosedCard> {
  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        ZCard(
          padding: EdgeInsets.all(10),
          borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Closed:'),
                    Spacer(),
                    Text(
                      '${ZFormat.dateFormatSignal(widget.signal.getSignalClosedDateTime())}',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Opened:'),
                    Spacer(),
                    Text(
                      '${ZFormat.dateFormatSignal(widget.signal.entryDateTime)}',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: widget.signal.entryType == 'Long' ? appColorGreen : appColorRed, borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      margin: EdgeInsets.only(bottom: 3),
                      child: Text('${widget.signal.entryType.toUpperCase()} !!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                    SizedBox(width: 6),
                    Text(widget.signal.symbol, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 0)),
                    Spacer(),
                    getStatus(widget.signal),
                  ],
                ),
                SizedBox(height: 8),
                Row(children: [
                  Text(
                    'Entry price',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                  SizedBox(width: 4),
                  Spacer(),
                  SizedBox(width: 4),
                  Text(widget.signal.entryPrice.toString()),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Text(
                    'Stop Loss',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                  SizedBox(width: 4),
                  Text(getPipsOrPercentStr(
                    isPips: widget.signal.market == 'forex' ? true : false,
                    pips: widget.signal.stopLossPips,
                    percent: widget.signal.stopLossPct,
                  )),
                  Spacer(),
                  SizedBox(width: 4),
                  Text('${ZFormat.toPrecision(widget.signal.stopLoss, 8)}'),
                ]),
                SizedBox(height: 8),
                ConfigurableExpansionTile(
                  headerExpanded: Flexible(
                    child: ZCard(
                      borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
                      color: isLightTheme ? appColorCardButtonLight : appColorCardButtonDark,
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                      margin: EdgeInsets.zero,
                      child: Row(children: [Text("View Targets", style: TextStyle()), Spacer(), Icon(Icons.keyboard_arrow_up, size: 16)]),
                    ),
                  ),
                  header: (isExpanded, _,__,  heightFactor) => Flexible(
                    child: ZCard(
                      borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
                      color: isLightTheme ? appColorCardButtonLight : appColorCardButtonDark,
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                      margin: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("View Targets", style: TextStyle()),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down, size: 18),
                        ],
                      ),
                    ),
                  ),
                  childrenBody: Column(
                    children: [
                      SizedBox(height: 8),
                      _buildTargetCard(
                          name: 'Target 1',
                          target: widget.signal.takeProfit1,
                          targetPct: widget.signal.takeProfit1Pct,
                          targetPips: widget.signal.takeProfit1Pips,
                          result: widget.signal.takeProfit1Result,
                          resultTimeUtc: widget.signal.takeProfit1DateTime,
                          signal: widget.signal),
                      _buildTargetCard(
                          name: 'Target 2',
                          target: widget.signal.takeProfit2,
                          targetPct: widget.signal.takeProfit2Pct,
                          targetPips: widget.signal.takeProfit2Pips,
                          result: widget.signal.takeProfit2Result,
                          resultTimeUtc: widget.signal.takeProfit2DateTime,
                          signal: widget.signal),
                      _buildTargetCard(
                          name: 'Target 3',
                          target: widget.signal.takeProfit3,
                          targetPct: widget.signal.takeProfit3Pct,
                          targetPips: widget.signal.takeProfit3Pips,
                          result: widget.signal.takeProfit3Result,
                          resultTimeUtc: widget.signal.takeProfit3DateTime,
                          signal: widget.signal),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
                if (widget.signal.comment != '')
                  Column(
                    children: [SizedBox(height: 8), Text('Comment: ${widget.signal.comment}')],
                  ),
              ],
            ),
          ),
        ),
        // Divider(color: Colors.white12, height: 10, thickness: 1)
      ],
    );
  }

  _buildTargetCard({
    required String name,
    required String result,
    required num target,
    required num targetPct,
    required num targetPips,
    required DateTime? resultTimeUtc,
    required Signal signal,
  }) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: result == 'profit'
            ? appColorGreen.withOpacity(.4)
            : isLightTheme
                ? appColorCardButtonLight
                : appColorCardButtonDark,
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(children: [
        Container(
          width: MediaQuery.of(context).size.width * .375,
          child: Text('${name}', style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 4),
        Text('${ZFormat.toPrecision(target, 8)}'),
        Spacer(),
        Text(
            getPipsOrPercentStr(
              isPips: widget.signal.market == 'forex' ? true : false,
              pips: targetPips,
              percent: targetPct,
            ),
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontWeight: FontWeight.bold)),
        if (result == 'profit') Icon(Icons.check, color: Theme.of(context).textTheme.bodySmall!.color, size: 16),
      ]),
    );
  }

  String getSignalCloseDate(Signal signal) {
    if (signal.takeProfit3Hit) return '${ZFormat.dateFormatSignal(signal.takeProfit3DateTime)}';
    if (signal.stopLossHit) return '${ZFormat.dateFormatSignal(signal.stopLossDateTime)}';
    return '';
  }

  String getStatusText(Signal signal) {
    if (signal.takeProfit3Hit) return 'Bagged full profit  ${ZFormat.dateFormatSignal(signal.takeProfit3DateTime)}';
    if (signal.takeProfit2Hit) return 'Bagged target 2 profit  ${ZFormat.dateFormatSignal(signal.takeProfit2DateTime)}';
    if (signal.takeProfit1Hit) return 'Bagged target 1 profit  ${ZFormat.dateFormatSignal(signal.takeProfit1DateTime)}';
    if (signal.stopLossHit) return 'Stopped out @ ${ZFormat.dateFormatSignal(signal.takeProfit1DateTime)}';
    return 'In progress';
  }

  getStatus(Signal signal) {
    if (signal.takeProfit3Hit) return _buildStatusContainer(text: 'Target 3', isProfit: true);
    if (signal.takeProfit2Hit) return _buildStatusContainer(text: 'Target 2', isProfit: true);
    if (signal.takeProfit1Hit) return _buildStatusContainer(text: 'Target 1', isProfit: true);
    if (signal.stopLossHit) return _buildStatusContainer(text: 'Stop Loss hit', isProfit: false);
    return _buildStatusContainer(text: 'In progress', isProfit: true, isInProgress: true);
  }

  _buildStatusContainer({required String text, required bool isProfit, bool isInProgress = false}) {
    if (isInProgress)
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xFFF7931A).withOpacity(.15)),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Text(text, style: TextStyle(color: Color(0xFFF7931A), fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(width: 4),
            Icon(isProfit ? Icons.incomplete_circle_outlined : Icons.close, color: Color(0xFFF7931A), size: 13),
          ],
        ),
      );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isProfit ? Color(0xFF12533B).withOpacity(.6) : Color(0XFF332229),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: isProfit ? Color(0xFF0CAF60) : Color(0xFFFF637E), fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(width: 4),
          Icon(isProfit ? Icons.check : Icons.close, color: isProfit ? Color(0xFF0CAF60) : Color(0xFFFF637E), size: 13),
        ],
      ),
    );
  }
}
