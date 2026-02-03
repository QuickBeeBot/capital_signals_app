import '../components/z_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';

class ZGetUtils {
  /// Safely get context - prefers overlay for dialogs/toasts
  static BuildContext get safeContext {
    return Get.overlayContext ?? Get.context!;
  }

  static showToastSuccess({required String message, Duration? duration}) {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 75),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          color: Color(0xFF5EEDA5),
        ),
        child: Text(message, style: TextStyle(color: Colors.black87)),
      ),
      context: safeContext,
      animation: StyledToastAnimation.fadeScale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(seconds: 1),
      duration: duration ?? Duration(seconds: 4),
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linear,
    );
  }

  static showToastError({required String message, Duration? duration}) {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 75),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          color: Colors.red[300],
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
      context: safeContext,
      animation: StyledToastAnimation.fadeScale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(seconds: 1),
      duration: duration ?? Duration(seconds: 4),
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linear,
    );
  }

  /// Modern animated confirmation dialog using Flutter's built-in showDialog
  static Future<void> showDialogConfirm({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? message,
    String? subTitle,
    BuildContext? context,
  }) async {
    final safeCtx = context ?? safeContext;
    final isLightTheme = Theme.of(safeCtx).brightness == Brightness.light;
    final cardColor = isLightTheme ? Colors.white : Color(0xFF29313C);
    final barrierColor = Colors.black.withOpacity(0.5);

    return showDialog<void>(
      context: safeCtx,
      barrierDismissible: false,
      barrierColor: barrierColor,
      builder: (BuildContext dialogContext) {
        return AnimatedDialog(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cardColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message ?? 'Are you sure you want to proceed?',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                      ),
                      SizedBox(height: 12),
                      Text(
                        subTitle ?? "Once you proceed with this action it can't be undone.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Theme.of(dialogContext).textTheme.bodySmall?.color,
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ZCard(
                            color: Colors.transparent,
                            margin: EdgeInsets.zero,
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              onCancel?.call();
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 14)),
                          ),
                          SizedBox(width: 8),
                          ZCard(
                            color: Colors.transparent,
                            margin: EdgeInsets.zero,
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              onConfirm();
                            },
                            child: Text('Confirm', style: TextStyle(color: Colors.blue, fontSize: 14)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Reusable animated dialog wrapper (fade + scale)
class AnimatedDialog extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedDialog({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}