import 'package:flutter/material.dart';

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
  late int selectedHour;
  late int selectedMinute;
  bool isAm = true;
  bool isTimeValid = true;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hourOfPeriod;
    selectedMinute = widget.initialTime.minute - widget.initialTime.minute % 10;
    isAm = widget.initialTime.period == DayPeriod.am;
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
              segments: const [
                ButtonSegment<bool>(
                  label: Text('AM'),
                  value: true,
                ),
                ButtonSegment<bool>(
                  label: Text('PM'),
                  value: false,
                )
              ],
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  // item in the selected set.
                  isAm = newSelection.first;
                  isTimeValid = _handleTimeSelection();
                });
              },
              selected: <bool>{isAm},
              style: buttonStle,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Hour"),
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
                        child: Text('$index')
                      ),
                      value: index,
                    )
                  ),
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      selectedHour = newSelection.first;
                      isTimeValid = _handleTimeSelection();
                    });
                  },
                  selected: <int>{selectedHour},
                  style: buttonStle,
                ),

                SegmentedButton(
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  segments: List.generate(6, (index) =>
                    ButtonSegment<int>(
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('${index + 6}')
                      ),
                      value: index + 6,
                    )
                  ),
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      selectedHour = newSelection.first;
                      isTimeValid = _handleTimeSelection();
                    });
                  },
                  selected: <int>{selectedHour},
                  style: buttonStle,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Minute"),
            ),
            SegmentedButton(
              showSelectedIcon: false,
              segments: List.generate(6, (index) =>
                ButtonSegment<int>(
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${index * 10}')
                  ),
                  value: index * 10,
                )
              ),
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  selectedMinute = newSelection.first;
                  isTimeValid = _handleTimeSelection();
                });
              },
              selected: <int>{selectedMinute},
              style: buttonStle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("${formatTime(_getSelectedTime())} - ${formatTime24Hour(_getSelectedTime())}"),
            ),

            if (!isTimeValid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "A reminder for ${formatTime(_getSelectedTime())}/${formatTime24Hour(_getSelectedTime())} is already set!",
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
    return TimeOfDay(hour: selectedHour + (isAm ? 0 : 12), minute: selectedMinute);
  }
}