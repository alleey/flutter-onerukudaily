import 'dart:developer';

import 'package:flutter/material.dart';

import '../../blocs/reader_bloc.dart';
import '../../localizations/app_localizations.dart';
import '../common/layout_constants.dart';
import '../models/app_settings.dart';
import '../services/asset_service.dart';
import 'common/responsive_layout.dart';
import 'dialogs/app_dialog.dart';
import 'loading_indicator.dart';
import 'settings_aware_builder.dart';

typedef RukuPickerCallback = void Function(int rukuNum);

class RukuPickerDialog extends StatefulWidget {

  final int? selectedSura;
  final int? selectedRuku;
  final RukuPickerCallback onSelect;

  const RukuPickerDialog({super.key,
    this.selectedSura,
    this.selectedRuku,
    required this.onSelect,
  });

  @override
  _RukuPickerDialogState createState() => _RukuPickerDialogState();
}

class _RukuPickerDialogState extends State<RukuPickerDialog> {

  late ValueNotifier<int> suraSelectionNotifier;
  late ValueNotifier<int> rukuSelectionNotifier;

  String selectedRuku = "";
  Map<String, Map<String, int>> suraMap = {};

  @override
  void initState() {
    super.initState();
    suraSelectionNotifier = ValueNotifier((widget.selectedSura ?? 1) - 1);
    rukuSelectionNotifier = ValueNotifier((widget.selectedRuku ?? 1) - 1);
  }

  @override
  void dispose() {
    rukuSelectionNotifier.dispose();
    suraSelectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: settingsNotifier,
          builder: (context, settings, child) {

            return FutureBuilder(
              future: AssetService().loadSuraRukuMap(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  suraMap = snapshot.data!;

                  WidgetsBinding.instance.addPostFrameCallback((_) => _handleSuraRukuSelection());
                  return _buildContents(context, settings);
                }

                return const Center(child: LoadingIndicator());
              }
            );

          }
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final layout = ResponsiveLayoutProvider.layout(context);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final scheme = settings.currentScheme.dialog;
    final buttonScheme = scheme.button;

    final suraList = suraMap.keys.toList();

    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: bodyFontSize,
        color: scheme.text,
      ),

      child: ValueListenableBuilder(
        valueListenable: suraSelectionNotifier,
        builder: (context, suraId, child) {

          final rukuInfo = suraMap[suraList[suraId]]!;
          final totalRuku = rukuInfo["total"] as int;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.localizations.translate("dlg_pickruku_sura")),
                  DropdownButton<String>(
                    value: suraList[suraId],
                    style: TextStyle(
                      color: buttonScheme.text
                    ),
                    dropdownColor: scheme.background,
                    items: suraList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.center,
                        value: value,
                        child: Text(
                          value,
                          textDirection: TextDirection.rtl,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      suraSelectionNotifier.value = suraList.indexOf(value!);
                      rukuSelectionNotifier.value = 0;
                      _handleSuraRukuSelection();
                    }
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.localizations.translate("dlg_pickruku_ruku")),
                  ValueListenableBuilder(
                    valueListenable: rukuSelectionNotifier,
                    builder: (context, rukuId, child) {

                      log("selected rukuId $rukuId");

                      return DropdownButton<int>(
                        value: rukuId,
                        style: TextStyle(
                          color: buttonScheme.text
                        ),
                        dropdownColor: scheme.background,
                        items: Iterable<int>.generate(totalRuku).map((int v) {

                          log("adding dropdown value $v");

                          return DropdownMenuItem<int>(
                            alignment: AlignmentDirectional.center,
                            value: v,
                            child: Text(
                              "${v + 1}",
                            ),
                          );

                        }).toList(),
                        onChanged: (int? value) {
                          rukuSelectionNotifier.value = value!;
                          _handleSuraRukuSelection();
                        }
                      );
                    },
                  ),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonDialogAction(
                    onAction: (close) {
                      _handleDailyRukuSelection();
                    },
                    builder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(context.localizations.translate("dlg_pickruku_dailyruku")),
                    ),
                  ),
              ]),

              Divider(color: scheme.text, indent: 5, endIndent: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  context.localizations.translate("dlg_pickruku_selected", placeholders: {
                    "selectedRuku": selectedRuku
                  })
                ),
              ])

            ]
          );
        },
      ),
    );
  }

  void _handleSuraRukuSelection() {

    final suraList = suraMap.keys.toList();
    final rukuInfo = suraMap[suraList[suraSelectionNotifier.value]]!;
    final firstRuku = rukuInfo["first"] as int;
    final ruku = firstRuku + rukuSelectionNotifier.value;

    setState(() {
      selectedRuku = ruku.toString();
      widget.onSelect(ruku);
    });
  }

  void _handleDailyRukuSelection() {

    final ruku = context.readerBloc.dailyRukuNumber;
    setState(() {
      selectedRuku = ruku.toString();
      widget.onSelect(ruku);
    });
  }

}