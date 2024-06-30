import 'package:flutter/material.dart';

typedef FocusHighlightBuilder = Widget Function(bool focused);

class FocusHighlight extends StatefulWidget {
  final Widget? child;
  final FocusHighlightBuilder? builder;
  final Color? focusColor;
  final Color? normalColor;
  final Duration duration;
  final bool autofocus;
  final bool canRequestFocus;
  final FocusNode? focusNode;
  final FocusOnKeyEventCallback? onKeyEvent;
  final ValueChanged<bool>? onFocusChange;
  final bool overlayMode;
  final AlignmentGeometry? alignment;

  const FocusHighlight({
    super.key,
    this.child,
    this.builder,
    this.focusColor = Colors.yellow,
    this.normalColor = Colors.transparent,
    this.duration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.canRequestFocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onKeyEvent,
    this.overlayMode = false,
    this.alignment,
  }) : assert(child != null || builder != null);

  @override
  _FocusHighlightState createState() => _FocusHighlightState();
}

class _FocusHighlightState extends State<FocusHighlight> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        setState(() {
          _isFocused = focus;
        });
        widget.onFocusChange?.call(focus);
      },
      onKeyEvent: widget.onKeyEvent,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      child: AnimatedContainer(
        alignment: widget.alignment,
        duration: widget.duration,
        color: widget.overlayMode ? Colors.transparent : (_isFocused ? widget.focusColor : widget.normalColor),
        child: Stack(
          children: [
            (widget.child ?? widget.builder?.call(_isFocused))!,
            if (widget.overlayMode && _isFocused)
              Positioned(
                top:0, bottom: 0, left: 0, right: 0,
                child: AnimatedContainer(
                  duration: widget.duration,
                  color: widget.focusColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
