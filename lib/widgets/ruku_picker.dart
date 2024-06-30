import 'dart:developer';

import 'package:collection/collection.dart';
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

  late ValueNotifier<int> _suraSelectionNotifier;
  late ValueNotifier<int> _rukuSelectionNotifier;

  String _selectedRuku = "";
  Map<String, Map<String, int>> _suraMap = {};
  bool _fireInitial = false;

  @override
  void initState() {
    super.initState();
    _suraSelectionNotifier = ValueNotifier((widget.selectedSura ?? 1) - 1);
    _rukuSelectionNotifier = ValueNotifier((widget.selectedRuku ?? 1) - 1);
  }

  @override
  void dispose() {
    _rukuSelectionNotifier.dispose();
    _suraSelectionNotifier.dispose();
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
                  _suraMap = snapshot.data!;

                  if (!_fireInitial) {
                    _fireInitial = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSuraRukuSelection(setState));
                  }
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

    final suraList = _suraMap.keys.toList();

    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: bodyFontSize,
        color: scheme.text,
      ),

      child: ValueListenableBuilder(
        valueListenable: _suraSelectionNotifier,
        builder: (context, suraId, child) {

          final rukuInfo = _suraMap[suraList[suraId]]!;
          final totalRuku = rukuInfo["total"] as int;

          return StatefulBuilder(
            builder: (context, setstate) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ExcludeSemantics(child: Text(context.localizations.translate("dlg_pickruku_sura"))),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Semantics(
                          label: context.localizations.translate("dlg_pickruku_semantic_sura"),
                          child: DropdownButton<String>(
                            value: suraList[suraId],
                            style: TextStyle(
                              color: buttonScheme.text
                            ),
                            dropdownColor: scheme.background,
                            items: suraList.mapIndexed<DropdownMenuItem<String>>((index, String value) {
                              return DropdownMenuItem<String>(
                                alignment: AlignmentDirectional.centerStart,
                                value: value,
                                child: Text(
                                  "${index+1} - $value",
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              _suraSelectionNotifier.value = suraList.indexOf(value!);
                              _rukuSelectionNotifier.value = 0;
                              _handleSuraRukuSelection(setstate);
                            }
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ExcludeSemantics(child: Text(context.localizations.translate("dlg_pickruku_ruku"))),
                      ValueListenableBuilder(
                        valueListenable: _rukuSelectionNotifier,
                        builder: (context, rukuId, child) {

                          //log("selected rukuId $rukuId");

                          return Semantics(
                            label: context.localizations.translate("dlg_pickruku_semantic_ruku"),
                            child: DropdownButton<int>(
                              value: rukuId,
                              style: TextStyle(
                                color: buttonScheme.text
                              ),
                              dropdownColor: scheme.background,
                              items: Iterable<int>.generate(totalRuku).map((int rukuId) {

                                return DropdownMenuItem<int>(
                                  alignment: AlignmentDirectional.center,
                                  value: rukuId,
                                  child: Text(
                                    "${rukuId + 1}",
                                  ),
                                );

                              }).toList(),
                              onChanged: (int? value) {
                                _rukuSelectionNotifier.value = value!;
                                _handleSuraRukuSelection(setstate);
                              }
                            ),
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
                          _handleDailyRukuSelection(setstate);
                        },
                        builder: (_, __) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(context.localizations.translate("dlg_pickruku_dailyruku")),
                        ),
                      ),
                  ]),

                  Divider(color: scheme.text, indent: 5, endIndent: 5),

                  Semantics(
                    container: true,
                    excludeSemantics: true,
                    label: context.localizations.translate("dlg_pickruku_semantic_selected", placeholders: {
                      "selectedRuku": _selectedRuku
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                        context.localizations.translate("dlg_pickruku_selected", placeholders: {
                          "selectedRuku": _selectedRuku
                        })
                      ),
                    ]),
                  )

                ]
              );
            },
          );
        },
      ),
    );
  }

  void _handleSuraRukuSelection(StateSetter setstate) {

    final suraList = _suraMap.keys.toList();
    final rukuInfo = _suraMap[suraList[_suraSelectionNotifier.value]]!;
    final firstRuku = rukuInfo["first"] as int;
    final ruku = firstRuku + _rukuSelectionNotifier.value;

    setstate(() {
      _selectedRuku = ruku.toString();
      widget.onSelect(ruku);
    });

  }

  void _handleDailyRukuSelection(StateSetter setstate) {

    final ruku = context.readerBloc.dailyRukuNumber;

    setstate(() {
      _selectedRuku = ruku.toString();
      widget.onSelect(ruku);
    });
  }
}