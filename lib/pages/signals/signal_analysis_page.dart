import 'package:flutter/material.dart';

import '../../components/z_image_display.dart';
import '../../models/signal_aggr_open.dart';

class SignalAnalysisPage extends StatefulWidget {
  SignalAnalysisPage({Key? key, required this.signal}) : super(key: key);
  final Signal signal;

  @override
  State<SignalAnalysisPage> createState() => _SignalAnalysisPageState();
}

class _SignalAnalysisPageState extends State<SignalAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analysis')),
      body: ListView(
        children: [
          if (widget.signal.analysisImage != '')
            ZImageDisplay(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              image: widget.signal.analysisImage,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .25,
              borderRadius: BorderRadius.circular(8),
            ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.signal.analysisText, style: TextStyle(height: 1.5)),
          )
        ],
      ),
    );
  }
}
