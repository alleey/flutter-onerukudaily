import 'package:flutter/material.dart';

import '../../localizations/app_localizations.dart';
import '../common/layout_constants.dart';
import '../models/app_settings.dart';
import '../utils/utils.dart';
import 'common/responsive_layout.dart';
import 'settings_aware_builder.dart';

typedef CustomTimePickerCallback = void Function(TimeOfDay selected);

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final List<TimeOfDay> selectedTimes;
  final CustomTimePickerCallback onSelect;

  const CustomTimePickerDialog({super.key,
    required this.initialTime,
    required this.selectedTimes,
    required this.onSelect,
  });

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {

  late int _selectedHour;
  late int _selectedMinute;
  bool _isAm = true;
  bool _isTimeValid = true;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hourOfPeriod;
    _selectedMinute = widget.initialTime.minute - widget.initialTime.minute % 10;
    _isAm = widget.initialTime.period == DayPeriod.am;
  }

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: settingsNotifier,
          builder: (context, settings, child) =>  _buildContents(context, settings)
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final layout = ResponsiveLayoutProvider.layout(context);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final scheme = settings.currentScheme.dialog;

    final buttonStle = SegmentedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      backgroundColor: scheme.button.background,
      foregroundColor: scheme.button.text,
      selectedForegroundColor: scheme.button.background,
      selectedBackgroundColor: scheme.button.text,
      textStyle: TextStyle(
        fontSize: bodyFontSize
      )
    ).copyWith(
      overlayColor: StateDependentColor(scheme.button.overlay)
    );

    final labelAM = context.localizations.translate("dlg_picktime_am");
    final labelPM = context.localizations.translate("dlg_picktime_pm");
    final labelMinute = context.localizations.translate("dlg_picktime_minute");

    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: bodyFontSize,
        color: scheme.text,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SegmentedButton(
              showSelectedIcon: false,
              segments: [
                ButtonSegment<bool>(
                  label: Text(labelAM),
                  value: true,
                ),
                ButtonSegment<bool>(
                  label: Text(labelPM),
                  value: false,
                )
              ],
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  // item in the selected set.
                  _isAm = newSelection.first;
                  _isTimeValid = _handleTimeSelection();
                });
              },
              selected: <bool>{_isAm},
              style: buttonStle,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Semantics(
                container: true,
                child: Text(
                  semanticsLabel: context.localizations.translate("dlg_picktime_hour"),
                  context.localizations.translate("dlg_picktime_hour")
                ),
              ),
            ),

            Column(
              children:
              [
                SegmentedButton(
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  segments: List.generate(6, (index) =>
                    ButtonSegment<int>(
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$index',
                          semanticsLabel: "$index ${_isAm ? labelAM : labelPM}",
                        )
                      ),
                      value: index,
                    )
                  ),
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _selectedHour = newSelection.first;
                      _isTimeValid = _handleTimeSelection();
                    });
                  },
                  selected: <int>{_selectedHour},
                  style: buttonStle,
                ),

                SegmentedButton(
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  segments: List.generate(6, (index) =>
                    ButtonSegment<int>(
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${index + 6}',
                          semanticsLabel: "${index + 6} ${_isAm ? labelAM : labelPM}",
                        )
                      ),
                      value: index + 6,
                    )
                  ),
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _selectedHour = newSelection.first;
                      _isTimeValid = _handleTimeSelection();
                    });
                  },
                  selected: <int>{_selectedHour},
                  style: buttonStle,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Semantics(
                container: true,
                child: Text(labelMinute)
              ),
            ),

            SegmentedButton(
              showSelectedIcon: false,
              segments: List.generate(6, (index) =>
                ButtonSegment<int>(
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${index * 10}',
                      semanticsLabel: "${index * 10} $labelMinute",
                    )
                  ),
                  value: index * 10,
                )
              ),
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedMinute = newSelection.first;
                  _isTimeValid = _handleTimeSelection();
                });
              },
              selected: <int>{_selectedMinute},
              style: buttonStle,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Semantics(
                label: context.localizations.translate(
                  "dlg_picktime_semantic_selected",
                  placeholders: {
                    "time": formatTime(_getSelectedTime())
                  }
                ),
                container: true,
                excludeSemantics: true,
                child: Text(
                  "${formatTime(_getSelectedTime())} - ${formatTime24Hour(_getSelectedTime())}"
                )
              ),
            ),

            if (!_isTimeValid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  context.localizations.translate(
                    "dlg_picktime_reminder_already_set",
                    placeholders: {
                      "time": "${formatTime(_getSelectedTime())}/${formatTime24Hour(_getSelectedTime())}"
                    }
                  ),
                  textScaler: const TextScaler.linear(0.9),
                  style: TextStyle(
                    color: scheme.textHighlight,
                  ),
                ),
              ),
          ]
        ),
    );
  }

  bool _handleTimeSelection() {
    final selectedTime = _getSelectedTime();
    widget.onSelect(selectedTime);
    return !widget.selectedTimes.contains(selectedTime);
  }

  TimeOfDay _getSelectedTime() {
    return TimeOfDay(hour: _selectedHour + (_isAm ? 0 : 12), minute: _selectedMinute);
  }
}