import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../common/app_color_scheme.dart';
import '../common/custom_traversal_policy.dart';
import '../common/layout_constants.dart';
import 'common/focus_highlight.dart';
import 'common/responsive_layout.dart';

typedef ColorSchemeSelectionCallback = void Function(String schmeName);

class ColorSchemePicker extends StatefulWidget {

  final String selectedTheme;
  final ColorSchemeSelectionCallback onSelect;
  final WrapAlignment alignment;

  const ColorSchemePicker({
    super.key,
    required this.selectedTheme,
    required this.onSelect,
    this.alignment = WrapAlignment.center,

  });

  @override
  State<ColorSchemePicker> createState() => _ColorSchemePickerState();
}

class _ColorSchemePickerState extends State<ColorSchemePicker> {

  late ValueNotifier<(int, String)> _changeNotifier;
  final List<FocusNode> _focusNodes = List.generate(AppColorSchemes.all.length, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    focusSelectedTheme();
    //log("ColorSchemePicker:initState");
  }

  @override
  void didUpdateWidget(ColorSchemePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTheme != oldWidget.selectedTheme) {
      focusSelectedTheme();
      //log("ColorSchemePicker:didUpdateWidget: ${widget.selectedTheme} - ${oldWidget.selectedTheme}");
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    _changeNotifier.dispose();
    super.dispose();
  }

  void focusSelectedTheme() {
    int selectedThemeIndex = AppColorSchemes.all
      .mapIndexed((i,e) => (i, e.key))
      .where((e) => e.$2 == widget.selectedTheme)
      .map((e) => e.$1)
      .firstOrNull ?? -1;
    //log("ColorSchemePicker:focusSelectedTheme ${widget.selectedTheme} = $selectedThemeIndex");
    _changeNotifier = ValueNotifier<(int, String)>((selectedThemeIndex, widget.selectedTheme));
  }

  @override
  Widget build(BuildContext context) {

    final layout = context.layout;
    final itemSize = layout.get<Size>(AppLayoutConstants.colorSchemePickerItemSizeKey);

    return Focus(
      canRequestFocus: false,
      onFocusChange:(value) {
        //log("ColorSchemePicker:onFocusChange top-level");
        if (value) {
          focusSelectedTheme();
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _changeNotifier,
        builder: (context, value, child) {

          final (selectedIndex, _) = value;

          return Wrap(
            alignment: widget.alignment,
            runSpacing: 2,
            spacing: 2,
            children: AppColorSchemes.all.mapIndexed((index, e) {

              return Semantics(
                label: selectedIndex == index ? "Theme ${index + 1} is active!" : "Apply theme ${index + 1}.",
                button: true,
                child: FocusTraversalOrder(
                  order: GroupFocusOrder(GroupFocusOrder.groupPageCommands, index),
                  child: FocusHighlight(
                    focusColor: e.value.dialog.text.withOpacity(0.5),
                    child: InkWell(
                      focusNode: _focusNodes[index],
                      canRequestFocus: true,
                      onTap: () {
                        _changeNotifier.value = (index, e.key);
                        widget.onSelect(e.key);
                      },
                      child: SizedBox(
                        height: itemSize.height,
                        width: itemSize.width,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: _buildThemeBar(e.value, itemSize),
                        ),
                      ),
                    )
                  ),
                )
              );
            }).toList()
          );
        },
      ),
    );
  }

  Widget _buildThemeBar(AppColorScheme scheme, Size itemSize) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: scheme.palette.color1,
              child: SizedBox(height: itemSize.height, width: itemSize.width,),
            ),
          ),
          Expanded(
            child: Container(
              color: scheme.palette.color2,
              child: SizedBox(height: itemSize.height, width: itemSize.width,),
            ),
          ),
          Expanded(
            child: Container(
              color: scheme.palette.color3,
              child: SizedBox(height: itemSize.height, width: itemSize.width,),
            ),
          ),
          Expanded(
            child: Container(
              color: scheme.palette.color4,
              child: SizedBox(height: itemSize.height, width: itemSize.width,),
            ),
          ),
        ]
      ),
    );
  }
}
