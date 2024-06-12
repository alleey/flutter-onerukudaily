import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../models/app_settings.dart';
import '../../models/reader_color_scheme.dart';
import '../../models/ruku.dart';
import '../../services/alerts_service.dart';
import '../../services/asset_service.dart';
import '../../utils/conversion.dart';
import '../color_scheme_picker.dart';
import '../common/responsive_layout.dart';
import '../dialogs/app_dialog.dart';
import '../ruku_reader.dart';
import '../settings_aware_builder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Ruku? _sampleRuku;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      final ruku = await AssetService().loadRuku(550);
      setState(() {
        _sampleRuku = ruku;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  _buildContents(context, settings)
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
          backgroundColor: scheme.page.defaultButton.background,
          foregroundColor: scheme.page.defaultButton.text,
        ),
        body: Container(
          color: scheme.page.background,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: scheme.page.text,
              fontSize: bodyFontSize,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    color: scheme.page.button.background,
                    child: TabBar(
                      labelColor: scheme.page.text,
                      dividerColor: scheme.page.background,
                      indicatorColor: scheme.page.text,
                      unselectedLabelColor: scheme.page.text.withOpacity(.5),
                      tabs: const [
                        Tab(icon: Icon(Icons.settings), text: 'General'),
                        Tab(icon: Icon(Icons.book_online), text: 'Reader'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      children: [
                        _buildGeneralSettings(context, settings),
                        _buildReaderSettings(context, settings),
                      ]
                    ),
                  ),
                  ButtonDialogAction(
                    isDefault: true,
                    onAction: (close) => context.settingsBloc.save(settings: AppSettings()),
                    builder: (_,__) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 5),
                        Text("Restore Defaults"),
                      ],
                    ),
                  ),
                  if (_sampleRuku != null)
                    Expanded(
                      flex: 1,
                      child: RukuReader(ruku: _sampleRuku!, settings: settings.readerSettings)
                    ),
                ],
              ),
            )
          )
        )
      ),
    );
  }


  Widget _buildGeneralSettings(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Text(
            "Application Theme",
            style: TextStyle(
              color: scheme.page.text,
              fontSize: titleFontSize,
            ),
          ),
          const SizedBox(height: 10,),
          ColorSchemePicker(selectedTheme: settings.theme, onSelect: (newTheme) {
            context.settingsBloc.save(settings: settings.copyWith(theme: newTheme));
          }),

      ]),
    );
  }

  Widget _buildReaderSettings(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final buttonScheme = scheme.page.button;
    final readerSettings = settings.readerSettings;

    final fonts = Constants.fonts.toList();
    fonts.sort();

    return SingleChildScrollView(
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Text Size",
              ),
              Slider(
                activeColor: scheme.page.text,
                value: clampDouble(readerSettings.fontSize, Constants.minReaderFontSize, Constants.maxReaderFontSize),
                min: Constants.minReaderFontSize,
                max: Constants.maxReaderFontSize,
                onChanged: (value) {
                  context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(fontSize: value)));
                }
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Numbers Arabic",
              ),
              Switch(
                activeColor: scheme.page.text,
                value: readerSettings.showArabicNumerals,
                onChanged: (value) {
                  context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(showArabicNumerals: value)));
                }
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Numbers before Ayat",
              ),
              Switch(
                activeColor: scheme.page.text,
                value: readerSettings.numberBeforeAya,
                onChanged: (value) {
                  context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(numberBeforeAya: value)));
                }
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              const Text(
                "Aya/Line",
              ),
              Switch(
                  activeColor: scheme.page.text,
                  value: readerSettings.ayaPerLine,
                  onChanged: (value) {
                    context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(ayaPerLine: value)));
                })
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Font",
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButton<String>(
                    value: readerSettings.font,
                    style: TextStyle(
                      color: buttonScheme.text
                    ),
                    dropdownColor: scheme.page.background,
                    items: fonts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.centerRight,
                        value: value,
                        child: Text(
                          "قُلْ هُوَ اللَّهُ أَحَدٌ",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontFamily: value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(font: value)));
                    }),
              )
            ]
          ),

          Divider(color: scheme.page.text, indent: 50, endIndent: 50),

          Row(
            children:
            [
              const Text("Background"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.background,
                  (scheme, newColor) => scheme.copyWith(background: newColor)
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              const Text("Aya (even)"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.aya.text,
                  (scheme, newColor) => scheme.copyWith(aya: scheme.aya.copyWith(text: newColor))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.aya.background,
                  (scheme, newColor) => scheme.copyWith(aya: scheme.aya.copyWith(background: newColor))
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              const Text("Aya (odd)"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.ayaOdd.text,
                  (scheme, newColor) => scheme.copyWith(ayaOdd: scheme.ayaOdd.copyWith(text: newColor))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.ayaOdd.background,
                  (scheme, newColor) => scheme.copyWith(ayaOdd: scheme.ayaOdd.copyWith(background: newColor))
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              const Text("Aya (sajda)"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.ayaSajda.text,
                  (scheme, newColor) => scheme.copyWith(ayaSajda: scheme.ayaSajda.copyWith(text: newColor))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.ayaSajda.background,
                  (scheme, newColor) => scheme.copyWith(ayaSajda: scheme.ayaSajda.copyWith(background: newColor))
                ),
              ),
            ]
          ),

          Row(
            children:
            [
              const Text("Markers"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3),
                child: _buildColorPicker(context, settings,
                  readerSettings.colorScheme.markers,
                  (scheme, newColor) => scheme.copyWith(markers: newColor)
                ),
              ),
            ]
          ),

        ],
      ),
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    AppSettings settings,
    Color initialColor,
    ReaderColorScheme Function(ReaderColorScheme scheme, Color newColor) updateFunction)
  {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: initialColor,
        side: BorderSide(
          color: initialColor.inverse(),
          width: 1
        ),
      ),
      onPressed: () async {
        final newColor = await AlertsService().colorPicker(context, pickerColor: initialColor);
        if (newColor != null) {
          if (context.mounted) {
            context.settingsBloc.save(
              settings: settings.copyWith(
                readerSettings: settings.readerSettings.copyWith(
                  colorScheme: updateFunction(settings.readerSettings.colorScheme, newColor)
                )
              )
            );
          }
        }
      },
      child: const Text(" ")
    );
  }
}

