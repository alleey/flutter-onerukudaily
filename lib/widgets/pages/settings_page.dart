import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/reader_color_scheme.dart';
import '../../models/ruku.dart';
import '../../services/alerts_service.dart';
import '../../services/asset_service.dart';
import '../../utils/conversion.dart';
import '../color_scheme_picker.dart';
import '../common/focus_highlight.dart';
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
      final ruku = await AssetService().loadRuku(538); // 550
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
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final screenCoverPct = context.layout.get<Size>(AppLayoutConstants.screenCoverPctKey);
    final appBarHeight = layout.get<double>(AppLayoutConstants.appbarHeightKey);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: scheme.page.defaultButton.background,
          foregroundColor: scheme.page.defaultButton.text,
          title: Text(
            context.localizations.translate("page_settings_title"),
            style: TextStyle(
              fontSize: titleFontSize,
            ),
          ),
          leading: FocusHighlight(
            focusColor: scheme.page.text.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              color: scheme.page.text,
            ),
          ),
        ),
      ),
      body: Container(
        color: scheme.page.background,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * screenCoverPct.width,
            height: MediaQuery.of(context).size.height * screenCoverPct.height,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: scheme.page.text,
                fontSize: bodyFontSize,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildBody(context, settings),
              )
            ),
          ),
        )
      )
    );
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: scheme.page.button.background,
            child: TabBar(
              labelColor: scheme.page.button.text,
              dividerColor: scheme.page.button.text,
              indicatorColor: scheme.page.button.text,
              unselectedLabelColor: scheme.page.button.text.withOpacity(.5),
              tabs: [
                FocusHighlight(
                  focusColor: scheme.page.button.text.withOpacity(0.5),
                  child: Tab(
                    icon: const Icon(Icons.book_online),
                    text: context.localizations.translate("page_settings_tab_reader")
                  ),
                ),
                FocusHighlight(
                  focusColor: scheme.page.button.text.withOpacity(0.5),
                  child: Tab(
                    icon: const Icon(Icons.settings),
                    text: context.localizations.translate("page_settings_tab_general")
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: TabBarView(
              children: [
                _buildReaderSettings(context, settings),
                _buildGeneralSettings(context, settings),
              ]
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonDialogAction(
                isDefault: true,
                onAction: (close) => context.settingsBloc.save(settings: AppSettings()),
                builder: (_,__) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh),
                      const SizedBox(width: 5),
                      Text(context.localizations.translate("page_settings_reset")),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_sampleRuku != null)
            Expanded(
              flex: 1,
              child: RukuReader(
                ruku: _sampleRuku!,
                settings: settings.readerSettings,
              )
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Text(
            context.localizations.translate("page_settings_theme"),
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
    final titleFontSize = context.layout.get<double>(AppLayoutConstants.titleFontSizeKey);

    final fonts = Constants.fonts.toList();
    fonts.sort();

    return SingleChildScrollView(
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.translate("page_settings_textsize"),
              ),
              FocusHighlight(
                focusColor: scheme.page.button.text.withOpacity(0.5),
                child: Slider(
                  activeColor: scheme.page.text,
                  divisions: (Constants.maxReaderFontSize - Constants.minReaderFontSize).truncate(),
                  value: clampDouble(readerSettings.fontSize, Constants.minReaderFontSize, Constants.maxReaderFontSize),
                  min: Constants.minReaderFontSize,
                  max: Constants.maxReaderFontSize,
                  onChanged: (value) {
                    context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(fontSize: value)));
                  }
                ),
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.translate("page_settings_numberstyle"),
              ),
              FocusHighlight(
                focusColor: scheme.page.button.text.withOpacity(0.5),
                child: Switch(
                  activeColor: scheme.page.text,
                  value: readerSettings.showArabicNumerals,
                  onChanged: (value) {
                    context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(showArabicNumerals: value)));
                  }
                ),
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.translate("page_settings_numberplacement"),
              ),
              FocusHighlight(
                focusColor: scheme.page.button.text.withOpacity(0.5),
                child: Switch(
                  activeColor: scheme.page.text,
                  value: readerSettings.numberBeforeAya,
                  onChanged: (value) {
                    context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(numberBeforeAya: value)));
                  }
                ),
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              Text(
                context.localizations.translate("page_settings_ayaperline"),
              ),
              FocusHighlight(
                focusColor: scheme.page.button.text.withOpacity(0.5),
                child: Switch(
                    activeColor: scheme.page.text,
                    value: readerSettings.ayaPerLine,
                    onChanged: (value) {
                      context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(ayaPerLine: value)));
                  }),
              )
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.translate("page_settings_font"),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: FocusHighlight(
                  focusColor: scheme.page.button.text.withOpacity(0.5),
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
                            style: TextStyle(
                              fontFamily: value,
                              fontSize: titleFontSize,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(font: value)));
                      }),
                ),
              )
            ]
          ),

          Divider(color: scheme.page.text, indent: 50, endIndent: 50),

          Row(
            children:
            [
              Text(context.localizations.translate("page_settings_clr_background")),
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
              Text(context.localizations.translate("page_settings_clr_ayaeven")),
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
              Text(context.localizations.translate("page_settings_clr_ayaodd")),
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
              Text(context.localizations.translate("page_settings_clr_ayasajda")),
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
              Text(context.localizations.translate("page_settings_clr_markers")),
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
    return FocusHighlight(
      focusColor: settings.currentScheme.page.button.text.withOpacity(0.5),
      child: TextButton(
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
      ),
    );
  }
}

