import 'package:flutter/material.dart';

import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../../services/asset_service.dart';
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
      final ruku = await AssetService().loadRuku(1);
      setState(() {
        _sampleRuku = ruku;
      });
    });
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

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: scheme.page.background,
          foregroundColor: scheme.page.text,
          title: const Text(Constants.appTitle),
          bottom: TabBar(
            labelColor: scheme.page.text,
            unselectedLabelColor: scheme.page.text.withOpacity(.5),
            tabs: const [
              Tab(icon: Icon(Icons.settings), text: 'General'),
              Tab(icon: Icon(Icons.book_online), text: 'Reader'),
            ],
          )
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
              child: TabBarView(
                children: [
                  _buildGeneralSettings(context, settings),
                  _buildReaderSettings(context, settings),
                ]
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
            "Change Theme",
            style: TextStyle(
              color: scheme.page.text,
              fontSize: titleFontSize,
            ),
          ),
          const SizedBox(height: 10,),
          ColorSchemePicker(selectedTheme: settings.theme, onSelect: (newTheme) {
            context.settingsBloc.add(WriteSettingsBlocEvent(
              settings: settings.copyWith(theme: newTheme),
              reload: true
            ));
          }),

        const SizedBox(height: 10,),

        // TEXT SIZE
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonDialogAction(
              isDefault: true,
              onAction: (close) => context.settingsBloc.add(WriteSettingsBlocEvent(settings: AppSettings(), reload: true)),
              builder: (_,__) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 5),
                    Text("Restore Defaults"),
                  ],
                ),
              ),
            )
          ]
        ),
      ]),
    );
  }

  Widget _buildReaderSettings(BuildContext context, AppSettings settings) {
    var fonts = Constants.fonts.toList();
    fonts.sort();

    return SingleChildScrollView(
      child: Column(
        children: [
        // TEXT SIZE
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Text Size",
          ),
          Slider(
            value: settings.fontSize,
            min: 24,
            max: 56,
            onChanged: (d) {
                context.settingsBloc.add(WriteSettingsBlocEvent(
                  settings: settings.copyWith(fontSize: d),
                  reload: true
                ));
            })
        ]),

        // TEXT SIZE
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Arabic Numbers",
          ),
          Switch(
              value: settings.showArabicNumerals,
              onChanged: (d) {
                context.settingsBloc.add(WriteSettingsBlocEvent(
                  settings: settings.copyWith(showArabicNumerals: d),
                  reload: true
                ));
            })
        ]),

        // TEXT SIZE
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Font",
          ),
          DropdownMenu<String>(
              initialSelection: settings.font,
              dropdownMenuEntries:
                  fonts.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
              onSelected: (String? value) {
                context.settingsBloc.add(WriteSettingsBlocEvent(
                  settings: settings.copyWith(font: value),
                  reload: true
                ));
              })
        ]),

        const SizedBox(height: 10,),
        // TEXT SIZE
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonDialogAction(
            isDefault: true,
            onAction: (close) => context.settingsBloc.add(WriteSettingsBlocEvent(settings: AppSettings(), reload: true)),
            builder: (_,__) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 5),
                  Text("Restore Defaults"),
                ],
              ),
            ),
          )
        ]),

        if (_sampleRuku != null)
          ...[
            const SizedBox(height: 10,),
            const Text("Preview"),
            const SizedBox(height: 10,),
            RukuReader(ruku: _sampleRuku!, settings: settings),
          ],
      ]),
    );
  }
}
