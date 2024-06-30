import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {

  const PercentageBar({
    super.key,
    required this.value,
    this.height = 20,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.borderWidth = 0.0,
    this.textStyle,
    this.direction = TextDirection.ltr,
    this.inverted = false,
    this.showLabel = true,
    this.onGenerateLabel,
  });

  final double value;
  final double height;
  final TextDirection direction;
  final bool inverted;
  final bool showLabel;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final String Function(double value)? onGenerateLabel;

  @override
  Widget build(BuildContext context) {
    return _buildRectangularIndicator(context, value, Colors.blue);
  }

  Widget _buildRectangularIndicator(BuildContext context, double value, Color color) {
    final generateLabel = onGenerateLabel ?? (value) => "${(value * 100).toStringAsFixed(1)}%";
    return Stack(
      children: [
        _buildRemaining(value),
        if (value > 0)
          _buildValue(value),
        if (showLabel)
          Positioned.fill(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  generateLabel(value),
                  textScaler: const TextScaler.linear(0.9),
                  style: textStyle ?? TextStyle(
                    color: foregroundColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildValue(double value) {
    return Align(
      alignment: direction == TextDirection.ltr ? AlignmentDirectional.centerEnd:AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0, 1.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: inverted ? backgroundColor.withOpacity(0.3):backgroundColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth),
          ),
        ),
      ),
    );
  }

  Widget _buildRemaining(double value) {
    return Align(
      alignment: direction == TextDirection.ltr ? AlignmentDirectional.centerStart:AlignmentDirectional.centerEnd,
      child: FractionallySizedBox(
        widthFactor: (1 - value).clamp(0, 1.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: inverted ? backgroundColor:backgroundColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth),
          ),
        ),
      ),
    );
  }
}
