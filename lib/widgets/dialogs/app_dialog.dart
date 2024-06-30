
import 'package:flutter/material.dart';

import '../../common/layout_constants.dart';
import '../../models/app_settings.dart';
import '../../utils/utils.dart';
import '../common/alternating_color_squares.dart';
import '../common/responsive_layout.dart';
import '../settings_aware_builder.dart';
import 'common.dart';

class AppDialog extends StatefulWidget {

  const AppDialog({
    super.key,
    required this.title,
    required this.contents,
    required this.actions,
    this.width,
    this.height,
    this.padding,
    this.insetPadding,
  });

  final ContentBuilder title;
  final ContentBuilder contents;
  final ActionBuilder actions;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
      builder: (context, settingsProvider){
        return ValueListenableBuilder(
          valueListenable: settingsProvider,
          builder: (context, settings, child) {
            return FocusScope(
              child: _buildDialog(context, settingsProvider)
            );
        }
        );
      },
    );
  }

  Widget _buildDialog(BuildContext context, ValueNotifier<AppSettings> settings) {

    final layout = context.layout;
    final screenCoverPct = layout.get<Size>(DialogLayoutConstants.screenCoverPctKey);
    final padding = layout.get<EdgeInsets>(DialogLayoutConstants.paddingKey);
    final insetPadding = layout.get<EdgeInsets>(DialogLayoutConstants.insetPaddingKey);
    final scheme = settings.value.currentScheme;

    return Dialog(
      insetPadding: widget.insetPadding ?? insetPadding,
      surfaceTintColor: scheme.dialog.surfaceTintColor,
      child: Container(
        width: widget.width ?? (MediaQuery.of(context).size.width * screenCoverPct.width),
        height: widget.height ?? (MediaQuery.of(context).size.height * screenCoverPct.height),
        color: scheme.dialog.background,
        child: Stack(
          children: [
            Padding(
              padding: widget.padding ?? padding,
              child: _buildContents(context, settings),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: AlternatingColorSquares(
                  color1: scheme.dialog.background,
                  color2: scheme.dialog.text,
                  squareSize: 4,
                )
              )
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AlternatingColorSquares(
                  color1: scheme.dialog.text,
                  color2: scheme.dialog.background,
                  squareSize: 4,
                )
              )
            ),
          ],
        ),
      )
    );
  }

  Widget _buildContents(BuildContext context, ValueNotifier<AppSettings> settingsProvider) {

    final buttons = widget.actions(context, settingsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.title(context, settingsProvider),
        Expanded(
          child: widget.contents(context, settingsProvider)
        ),
        if (buttons.isNotEmpty)
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons.toList(),
            ),
          ),
      ],
    );
  }
}

class DefaultDialogTitle extends StatelessWidget {
  const DefaultDialogTitle({
    super.key,
    required this.builder,
  });

  final ContentBuilder builder;

  @override
  Widget build(BuildContext context) => SettingsAwareBuilder(
      builder: (context, settingsProvider)=> _buildTitle(context, settingsProvider),
    );

  Widget _buildTitle(BuildContext context, ValueNotifier<AppSettings> settingsProvider) {
    final scheme = settingsProvider.value.currentScheme;
    return Semantics(
      header: true,
      container: true,
      child: Container(
        color: scheme.dialog.text.withOpacity(0.3),
        padding: const EdgeInsets.only(bottom: 4, top: 10),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: scheme.dialog.textHighlight),
            child: Text.rich(
              textAlign: TextAlign.center,
              WidgetSpan(
                child: builder(context, settingsProvider)
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonDialogAction extends DialogAction {
  const ButtonDialogAction({
    super.key,
    required super.builder,
    required this.onAction,
    this.onLongPressAction,
    this.isDefault = false,
    this.autofocus = false,
  }) : super();

  final bool isDefault;
  final bool autofocus;
  final void Function(CloseWithResult close) onAction;
  final void Function(CloseWithResult close)? onLongPressAction;

  @override
  Widget build(BuildContext context) => SettingsAwareBuilder(
      builder: (context, settingsProvider)=> _buildButton(context, settingsProvider),
    );

  Widget _buildButton(BuildContext context, ValueNotifier<AppSettings> settingsProvider) {

    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final scheme = settingsProvider.value.currentScheme;
    final buttonTheme = isDefault ? scheme.dialog.defaultButton : scheme.dialog.button;

    return MergeSemantics(
      child: ElevatedButton(
        autofocus: autofocus,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonTheme.background,
          foregroundColor: buttonTheme.text,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          padding: EdgeInsets.zero,
        ).copyWith(
          overlayColor: StateDependentColor(buttonTheme.text),
        ),
        onLongPress: () {
          onLongPressAction?.call((result) => Navigator.of(context, rootNavigator: true).pop(result));
        },
        onPressed: () {
          onAction((result) => Navigator.of(context, rootNavigator: true).pop(result));
        },
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: bodyFontSize,
            color: buttonTheme.text,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: builder(context, settingsProvider),
          ),
        )
      ),
    );
  }
}
