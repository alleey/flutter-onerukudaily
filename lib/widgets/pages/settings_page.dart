import 'package:flutter/foundation.dart';
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
      final ruku = await AssetService().loadRuku(550);
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
                  TabBar(
                    labelColor: scheme.page.text,
                    dividerColor: scheme.page.defaultButton.background,
                    indicatorColor: scheme.page.defaultButton.foreground,
                    unselectedLabelColor: scheme.page.text.withOpacity(.5),
                    tabs: const [
                      Tab(icon: Icon(Icons.settings), text: 'General'),
                      Tab(icon: Icon(Icons.book_online), text: 'Reader'),
                    ],
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


    return _buildReaderSettingsPage1(context, settings);
  }

  Widget _buildReaderSettingsPage1(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
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

            // TEXT SIZE
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
                        color: scheme.page.text
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


          ],
        ),
    );
  }
}


class PagedContainer extends StatefulWidget {
  final List<Widget> widgets;

  const PagedContainer({super.key, required this.widgets});

  @override
  _PagedContainerState createState() => _PagedContainerState();
}

class _PagedContainerState extends State<PagedContainer> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: widget.widgets.map((widget) {
            return IntrinsicHeight(
              child: widget,
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.widgets.length, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}