import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/custom_traversal_policy.dart';
import '../../common/layout_constants.dart';
import '../../common/native.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/reader_color_scheme.dart';
import '../../models/ruku.dart';
import '../../services/alerts_service.dart';
import '../../services/asset_service.dart';
import '../../utils/conversion.dart';
import '../../utils/utils.dart';
import '../color_scheme_picker.dart';
import '../common/focus_highlight.dart';
import '../common/responsive_layout.dart';
import '../common/tv_compatible_slider.dart';
import '../dialogs/app_dialog.dart';
import '../ruku_reader.dart';
import '../scroll_control_bar.dart';
import '../settings_aware_builder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late ScrollController _scrollController;

  Ruku? _sampleRuku;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      final ruku = await AssetService().loadRuku(538); // 550
      setState(() {
        _sampleRuku = ruku;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  FocusTraversalGroup(
          policy: const DebugCustomOrderedTraversalPolicy(),
          child: _buildContents(context, settings)
        )
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
          leading: Semantics(
            label: context.localizations.translate("app_cmd_goback"),
            button: true,
            excludeSemantics: true,
            child: FocusHighlight(
              focusColor: scheme.page.text.withOpacity(0.5),
              child: FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupAppCommands, 1),
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

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController!.animateTo(index);
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {
    return Column(
      children: [

        _buildTabBar(context, settings),

        Expanded(
          flex: 2,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildReaderSettings(context, settings),
              _buildGeneralSettings(context, settings),
            ]
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FocusTraversalOrder(
              order: const GroupFocusOrder(GroupFocusOrder.groupDialog, 1),
              child: ButtonDialogAction(
                isDefault: true,
                onAction: (close) => context.settingsBloc.save(settings: AppSettings()),
                builder: (_,__) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
            ),
          ],
        ),

        if (_sampleRuku != null)
          Expanded(
            flex: 1,
            child: _buildPreview(context, settings)
          ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme;
    return Row(
      children: [
        Expanded(
          child: FocusTraversalOrder(
            order: const GroupFocusOrder(GroupFocusOrder.groupAppCommands, 2),
            child: FocusHighlight(
              overlayMode: true,
              focusColor: scheme.page.text.withOpacity(.3),
              child: InkWell(
                onTap: () => _onTabTapped(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: _selectedIndex == 0 ? scheme.page.defaultButton.background : scheme.page.button.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_online, color: scheme.page.text),
                      Text(context.localizations.translate("page_settings_tab_reader"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: FocusTraversalOrder(
            order: const GroupFocusOrder(GroupFocusOrder.groupAppCommands, 3),
            child: FocusHighlight(
              overlayMode: true,
              focusColor: scheme.page.text.withOpacity(.3),
              child: InkWell(
                onTap: () => _onTabTapped(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: _selectedIndex == 1 ? scheme.page.defaultButton.background : scheme.page.button.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings, color: scheme.page.text),
                      Text(context.localizations.translate("page_settings_tab_general"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(BuildContext context, AppSettings settings) {

    final scheme = settings.readerSettings.colorScheme.aya;
    ScrollControlBar? scrollControlBar;

    if (kIsAndroidTV) {
      // Add keyboard based scroll controls for android TV
      scrollControlBar = ScrollControlBar(
          controller: _scrollController,
          scrollDelta: calculateReaderLineHeight(settings.readerSettings.fontSize) / 2,
          focusColor: scheme.text.withOpacity(.5),
          textColor: scheme.text,
          backgroundColor: scheme.background,
          decorator: (direction, child) {
            return FocusTraversalOrder(
              order: GroupFocusOrder(GroupFocusOrder.groupDialog, 20 - direction.index),
              child: child,
            );
          },
        );
    }

    return ExcludeSemantics(
      child: RukuReader(
        ruku: _sampleRuku!,
        settings: settings.readerSettings,
        scrollController: _scrollController,
        fixedHeader: scrollControlBar,
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);

    log("_buildGeneralSettings");

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

          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.translate("page_settings_textsize"),
                ),
                FocusTraversalOrder(
                  order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 1),
                  child: FocusHighlight(
                    focusColor: scheme.page.button.text.withOpacity(0.5),
                    canRequestFocus: true,
                    child: TvCompatibleSlider(
                      activeColor: scheme.page.text,
                      divisions: (Constants.maxReaderFontSize - Constants.minReaderFontSize).truncate(),
                      value: clampDouble(readerSettings.fontSize, Constants.minReaderFontSize, Constants.maxReaderFontSize),
                      min: Constants.minReaderFontSize,
                      max: Constants.maxReaderFontSize,
                      onChanged: (value) {
                        context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(fontSize: value)));
                      }
                    ),
                  ),
                )
              ]
            ),
          ),

          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.translate("page_settings_numberstyle"),
                ),
                FocusTraversalOrder(
                  order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 2),
                  child: FocusHighlight(
                    focusColor: scheme.page.button.text.withOpacity(0.5),
                    child: Switch(
                      activeColor: scheme.page.text,
                      value: readerSettings.showArabicNumerals,
                      onChanged: (value) {
                        context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(showArabicNumerals: value)));
                      }
                    ),
                  ),
                )
              ]
            ),
          ),

          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.translate("page_settings_numberplacement"),
                ),
                FocusTraversalOrder(
                  order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 3),
                  child: FocusHighlight(
                    focusColor: scheme.page.button.text.withOpacity(0.5),
                    child: Switch(
                      activeColor: scheme.page.text,
                      value: readerSettings.numberBeforeAya,
                      onChanged: (value) {
                        context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(numberBeforeAya: value)));
                      }
                    ),
                  ),
                )
              ]
            ),
          ),

          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
              [
                Text(
                  context.localizations.translate("page_settings_ayaperline"),
                ),
                FocusTraversalOrder(
                  order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 4),
                  child: FocusHighlight(
                    focusColor: scheme.page.button.text.withOpacity(0.5),
                    child: Switch(
                        activeColor: scheme.page.text,
                        value: readerSettings.ayaPerLine,
                        onChanged: (value) {
                          context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings.copyWith(ayaPerLine: value)));
                      }),
                  ),
                )
              ]
            ),
          ),

          MergeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.translate("page_settings_font"),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: FocusTraversalOrder(
                    order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 5),
                    child: FocusHighlight(
                      focusColor: scheme.page.button.text.withOpacity(0.5),
                      child: DropdownButton<String>(
                          value: readerSettings.font,
                          style: TextStyle(
                            color: buttonScheme.text
                          ),
                          dropdownColor: scheme.page.background,
                          items: fonts.mapIndexed<DropdownMenuItem<String>>((index, String value) {
                            return DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.centerStart,
                              value: value,
                              child: Text(
                                "قُلْ هُوَ اللَّهُ أَحَدٌ",
                                semanticsLabel: "${context.localizations.translate("page_settings_font")}# ${index+1}",
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
                  ),
                )
              ]
            ),
          ),

          Divider(color: scheme.page.text, indent: 50, endIndent: 50),

          Row(
            children:
            [
              ExcludeSemantics(
                child: Text(context.localizations.translate("page_settings_clr_background"))
              ),
              const Spacer(),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 6),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.background,
                    context.localizations.translate(
                      "page_settings_semantic_pickbg",
                      placeholders: {
                        "item": ""
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(background: newColor)
                  ),
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              ExcludeSemantics(
                child: Text(context.localizations.translate("page_settings_clr_ayaeven"))
              ),
              const Spacer(),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 7),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.aya.text,
                    context.localizations.translate(
                      "page_settings_semantic_pickfg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayaeven")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(aya: scheme.aya.copyWith(text: newColor))
                  ),
                ),
              ),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 8),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.aya.background,
                    context.localizations.translate(
                      "page_settings_semantic_pickbg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayaeven")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(aya: scheme.aya.copyWith(background: newColor))
                  ),
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              ExcludeSemantics(
                child: Text(context.localizations.translate("page_settings_clr_ayaodd"))
              ),
              const Spacer(),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 9),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.ayaOdd.text,
                    context.localizations.translate(
                      "page_settings_semantic_pickfg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayaodd")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(ayaOdd: scheme.ayaOdd.copyWith(text: newColor))
                  ),
                ),
              ),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 10),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.ayaOdd.background,
                    context.localizations.translate(
                      "page_settings_semantic_pickbg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayaodd")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(ayaOdd: scheme.ayaOdd.copyWith(background: newColor))
                  ),
                ),
              ),
            ]
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              ExcludeSemantics(
                child: Text(context.localizations.translate("page_settings_clr_ayasajda"))
              ),
              const Spacer(),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 11),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.ayaSajda.text,
                    context.localizations.translate(
                      "page_settings_semantic_pickfg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayasajda")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(ayaSajda: scheme.ayaSajda.copyWith(text: newColor))
                  ),
                ),
              ),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 12),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.ayaSajda.background,
                    context.localizations.translate(
                      "page_settings_semantic_pickbg",
                      placeholders: {
                        "item": context.localizations.translate("page_settings_clr_ayasajda")
                      }
                    ),
                    (scheme, newColor) => scheme.copyWith(ayaSajda: scheme.ayaSajda.copyWith(background: newColor))
                  ),
                ),
              ),
            ]
          ),

          Row(
            children:
            [
              ExcludeSemantics(
                child: Text(context.localizations.translate("page_settings_clr_markers"))
              ),
              const Spacer(),
              FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupPageCommands, 13),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _buildColorPicker(context, settings,
                    readerSettings.colorScheme.markers,
                    context.localizations.translate("page_settings_semantic_pickfg"),
                    (scheme, newColor) => scheme.copyWith(markers: newColor)
                  ),
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
    String semanticLabel,
    ReaderColorScheme Function(ReaderColorScheme scheme, Color newColor) updateFunction)
  {
    return FocusHighlight(
      focusColor: settings.currentScheme.page.button.text.withOpacity(0.5),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
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
        child: Semantics(
          label: semanticLabel,
          excludeSemantics: true,
          child: const Text("")
        )
      ),
    );
  }
}
