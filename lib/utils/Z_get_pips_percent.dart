import 'z_format.dart';

String getPipsOrPercentStr({bool isPips = false, num pips = 0, num percent = 0}) {
  if (isPips) {
    return '${pips} pips';
  } else {
    return ZFormat.numToPercent(percent);
  }
}
