import 'package:flutter/material.dart';

class FocusHighlight extends StatefulWidget {
  final Widget child;
  final Color focusColor;
  final Color normalColor;
  final Duration duration;
  final bool autofocus;
  final bool canRequestFocus;
  final FocusNode? focusNode;
  final FocusOnKeyEventCallback? onKeyEvent;
  final bool overlayMode;

  const FocusHighlight({
    super.key,
    required this.child,
    this.focusColor = Colors.yellow,
    this.normalColor = Colors.transparent,
    this.duration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.canRequestFocus = false,
    this.focusNode,
    this.onKeyEvent,
    this.overlayMode = false,
  });

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
      },
      onKeyEvent: widget.onKeyEvent,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      child: AnimatedContainer(
        duration: widget.duration,
        color: widget.overlayMode ? Colors.transparent : (_isFocused ? widget.focusColor : widget.normalColor),
        child: Stack(
          children: [
            widget.child,
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
