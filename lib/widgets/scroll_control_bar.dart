import 'package:flutter/material.dart';

import '../../localizations/app_localizations.dart';
import 'common/focus_highlight.dart';

typedef ScrollControlBarDecorator = Widget Function(AxisDirection direction, Widget child);

class ScrollControlBar extends StatelessWidget {

  const ScrollControlBar({
    super.key,
    required ScrollController controller,
    this.scrollDelta = 25,
    this.textColor,
    this.backgroundColor,
    this.focusColor,
    this.direction = TextDirection.ltr,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.decorator,
  }) : _controller = controller;

  final ScrollController _controller;
  final double scrollDelta;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final MainAxisAlignment alignment;
  final TextDirection direction;
  final ScrollControlBarDecorator? decorator;

  @override
  Widget build(BuildContext context) {
    final decorateFunc = decorator ?? (_, widget) => widget;
    return Directionality(
      textDirection: direction,
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Semantics(
            label: context.localizations.translate("page_reader_scroll_down"),
            button: true,
            excludeSemantics: true,
            child: decorateFunc(
              AxisDirection.down,
              FocusHighlight(
                focusColor: focusColor,
                child: IconButton(
                  icon: Icon(Icons.arrow_downward, color: textColor),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _controller.animateTo(
                      _controller.offset + scrollDelta,
                      curve: Curves.easeIn,
                      duration: const Duration (milliseconds: 250)
                    );
                  },
                  color: backgroundColor,
                ),
              ),
            ),
          ),
          Semantics(
            label: context.localizations.translate("page_reader_scroll_up"),
            button: true,
            excludeSemantics: true,
            child: decorateFunc(
              AxisDirection.up,
              FocusHighlight(
                focusColor: focusColor,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero
                  ),
                  icon: Icon(Icons.arrow_upward, color: textColor),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _controller.animateTo(
                      _controller.offset - scrollDelta,
                      curve: Curves.easeIn,
                      duration: const Duration (milliseconds: 250)
                    );
                  },
                  color: backgroundColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
