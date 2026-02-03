import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

typedef Null ValueChangeCallback(String value);

class ZSearch extends StatefulWidget {
  const ZSearch({Key? key, this.onValueChanged, this.controller, this.initialValue, this.margin}) : super(key: key);
  final ValueChangeCallback? onValueChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final EdgeInsets? margin;

  @override
  State<ZSearch> createState() => _ZSearchState();
}

class _ZSearchState extends State<ZSearch> {
  TextEditingController? valueController;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    valueController = widget.controller ?? TextEditingController.fromValue(TextEditingValue(text: widget.initialValue ?? ""));
    valueController?.addListener(() {
      if (widget.onValueChanged != null) widget.onValueChanged!(valueController?.text ?? '');
      setState(() {});
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade400, size: 22),
          Container(
            child: Expanded(
              child: Container(
                child: TextField(
                  onChanged: (v) {
                    if (widget.onValueChanged != null) widget.onValueChanged!(v);
                  },
                  cursorColor: appColorYellow,
                  controller: valueController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
