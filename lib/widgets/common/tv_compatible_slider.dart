import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TvCompatibleSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const TvCompatibleSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  _TvCompatibleSliderState createState() => _TvCompatibleSliderState();
}

class _TvCompatibleSliderState extends State<TvCompatibleSlider> {
  double _sliderValue = 0.0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.value;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(KeyEvent event) {
    var result = KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _sliderValue = (_sliderValue - (widget.max - widget.min) / widget.divisions).clamp(widget.min, widget.max);
          result = KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _sliderValue = (_sliderValue + (widget.max - widget.min) / widget.divisions).clamp(widget.min, widget.max);
          result = KeyEventResult.handled;
        }
        widget.onChanged(_sliderValue);
      });

    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        return _handleKey(event);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Focus(
          canRequestFocus: false,
          descendantsAreFocusable: false,
          skipTraversal: true,
          child: Slider(
            value: _sliderValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            activeColor: widget.activeColor,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}