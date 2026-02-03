import 'package:flutter/material.dart';
import '../../components/z_text_form_field_search.dart';

import '../../models/signal_aggr_open.dart';

import '../../components/z_signal_card_closed.dart';
import '../../models_services/firestore_service.dart';

class SignalsClosedPage extends StatefulWidget {
  SignalsClosedPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<SignalsClosedPage> createState() => _SignalsClosedPageState();
}

class _SignalsClosedPageState extends State<SignalsClosedPage> with TickerProviderStateMixin {
  String search = '';
  bool isLoadingInit = true;
  List<Signal> signals = [];

  @override
  void initState() {
    getSignalAggr();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Signal> _signals = getFilteredSignals(search, signals);
    print(widget.type);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Closed Signals (${signals.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5)),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          if (isLoadingInit) Expanded(child: Center(child: CircularProgressIndicator())),
          if (!isLoadingInit && signals.isEmpty) Expanded(child: Center(child: Text('No Signals'))),
          if (signals.length > 0)
            Column(
              children: [
                ZSearch(
                  onValueChanged: ((value) {
                    search = value;
                    setState(() {});
                  }),
                ),
                SizedBox(height: 8)
              ],
            ),
          if (signals.length > 0) Expanded(child: _buildListView(_signals)),
        ],
      ),
    );
  }

  List<Signal> getFilteredSignals(String s, List<Signal> signals) {
    if (s == '') return signals;
    return signals.where((signal) {
      return signal.symbol.toLowerCase().contains(s.toLowerCase());
    }).toList();
  }

  void getSignalAggr() async {
    signals = await FirestoreService.getSignals(type: widget.type);

    isLoadingInit = false;
    setState(() {});
  }

  Scrollbar _buildListView(List<Signal> signals) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: signals.length,
        itemBuilder: ((context, index) => Column(
              children: [ZSignalClosedCard(signal: signals[index])],
            )),
      ),
    );
  }

  Expanded buildSignalItem({required String title, required String value, String type = 'Bull', isStopLoss = false}) {
    Color textColor = (isStopLoss && type == 'Bull')
        ? Color(0xFF0AD61E)
        : (isStopLoss && type == 'Bear')
            ? Color(0xFFFF0002)
            : Colors.white;
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Color(0xFFA9A9A9), fontSize: 10)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 13, color: textColor)),
      ],
    ));
  }
}
