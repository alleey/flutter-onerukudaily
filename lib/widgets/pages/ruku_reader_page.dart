import 'dart:developer';

import 'package:flutter/material.dart';

import '../../blocs/reader_bloc.dart';
import '../../common/constants.dart';
import '../../common/custom_traversal_policy.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../../services/alerts_service.dart';
import '../../utils/conversion.dart';
import '../common/alternating_color_squares.dart';
import '../common/focus_highlight.dart';
import '../common/responsive_layout.dart';
import '../dialogs/app_dialog.dart';
import '../loading_indicator.dart';
import '../reader_aware_builder.dart';
import '../ruku_reader.dart';
import '../settings_aware_builder.dart';

class RukuReaderPage extends StatefulWidget {
  const RukuReaderPage({super.key});

  @override
  State<RukuReaderPage> createState() => _RukuReaderPageState();
}

class _RukuReaderPageState extends State<RukuReaderPage> {

  Ruku? _ruku;
  bool _isDailyRuku = false;
  bool _isReady = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: Constants.readerOpenDelay), () {
      context.readerBloc.add(GetNextDailyRukuBlocEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  _buildContents(context, settings)
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final screenCoverPct = context.layout.get<Size>(AppLayoutConstants.screenCoverPctKey);
    final appBarHeight = layout.get<double>(AppLayoutConstants.appbarHeightKey);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return FocusTraversalGroup(
      policy: const CustomOrderedTraversalPolicy(),
      child: Scaffold(
        appBar: _ruku == null ? null :
          PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AppBar(
              centerTitle: true,
              backgroundColor: scheme.page.background,
              foregroundColor: scheme.page.text,
              title: _buildSuraName(context, _ruku!, settings),
              leading: FocusTraversalOrder(
                order: const GroupFocusOrder(GroupFocusOrder.groupAppCommands, 0),
                child: FocusHighlight(
                  focusColor: scheme.page.text.withOpacity(0.5),
                  child: IconButton(
                    autofocus: true,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).popUntil(
                        (route) => route.settings.name == KnownRouteNames.main
                      );
                    },
                    color: scheme.page.text,
                  ),
                ),
              ),
              actions: [

                // ToggleButtons(
                //   isSelected: [settings.readerSettings.ayaPerLine, !settings.readerSettings.ayaPerLine],
                //   onPressed: (int index) {
                //     final readerSettings = settings.readerSettings.copyWith(ayaPerLine: index == 0);
                //     context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings));
                //   },
                //   children: const [
                //     Icon(Icons.align_horizontal_right),
                //     Icon(Icons.wrap_text),
                //   ],
                // ),

                FocusTraversalOrder(
                  order: const GroupFocusOrder(GroupFocusOrder.groupAppCommands, 1),
                  child: FocusHighlight(
                    focusColor: scheme.page.text.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, KnownRouteNames.settings);
                      },
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme.page;

    return ReaderListenerBuilder(
      onStateAvailable: (state) => setState(() {
        log("onStateAvailable ruku ${state.ruku?.index}, isDailyRuku: ${state.isDailyRuku}");
        _ruku = state.ruku;
        _isDailyRuku = state.isDailyRuku;
      }),
      onStateChange: (state) => setState(() {
        log("onStateChange ruku ${state.ruku?.index}, isDailyRuku: ${state.isDailyRuku}");
        _ruku = state.ruku;
        _isDailyRuku = state.isDailyRuku;
        _isReady = true;
      }),
      onQuranCompleted: (state) async {
        await AlertsService().completionDialog(
          context,
          statistics: state.statistics,
          onClose:() => context.readerBloc.add(StartNewReadingBlocEvent())
        );
      },
      builder: (context, stateProvider) {

        if (_ruku == null) {
          return Center(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontFamily: settings.readerSettings.font
              ),
              child: const LoadingIndicator(
                message: Constants.loaderText,
                direction: TextDirection.rtl
              )
            )
          );
        }

        double squareSize = 4;
        return Stack(
          children: [
            Positioned.fill(
              child: RukuReader(
                key: ObjectKey(_ruku!.index),
                ruku: _ruku!,
                settings: settings.readerSettings,
                scrollFooter: _buildScrollFooter(context, _ruku!, settings),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: AlternatingColorSquares(
                  color1: scheme.background,
                  color2: settings.readerSettings.colorScheme.background,
                  squareSize: squareSize,
                ),
              )
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AlternatingColorSquares(
                  color1: settings.readerSettings.colorScheme.background,
                  color2: scheme.background,
                  squareSize: squareSize,
                ),
              )
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuraName(BuildContext context, Ruku ruku, AppSettings settings) {
    final titleFontSize = context.layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    return Text(
      "${ruku.sura.name} - #${settings.readerSettings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ruku.index) : ruku.index.toString()}" ,
      style: TextStyle(
        //color: ruku.sura.isMakki ? Color.fromARGB(255, 236, 209, 38) : const Color.fromARGB(255, 147, 223, 60),
        fontSize: titleFontSize,
        fontFamily: settings.readerSettings.font,
      ),
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildScrollFooter(BuildContext context, Ruku ruku, AppSettings settings) {

    final scheme = settings.currentScheme.page.defaultButton;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 50),

          Expanded(
            child: FocusTraversalOrder(
              order: const GroupFocusOrder(GroupFocusOrder.groupReaderCommands, 10),
              child: ButtonDialogAction(
                isDefault: false,
                onAction: (close) {

                  if (_isReady) {
                    _isReady = false;
                    context.readerBloc.add(ViewRukuBlocEvent(index: ruku.index - 1));
                  }

                },
                builder: (_,__) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.navigate_before),
                      Text(
                        context.localizations.translate("page_reader_readprev"),
                        textScaler: const TextScaler.linear(.9),
                      ),
                    ],
                  ),
              ),
            ),
          ),

          const SizedBox(width: 2),
          Expanded(
            child: FocusTraversalOrder(
              order: const GroupFocusOrder(GroupFocusOrder.groupReaderCommands, 11),
              child: ButtonDialogAction(
                isDefault: false,
                onAction: (close) {

                  if (_isReady) {
                    _isReady = false;
                    context.readerBloc.add(SetDailyRukuBlocEvent(index: ruku.index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: scheme.text,
                        content: Text(
                          "Ruku#${ruku.index} is now your current ruku.",
                          style: TextStyle(
                            color: scheme.background,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                    );
                  }

                },
                onLongPressAction: (close) async {

                  final selection = await AlertsService().rukuPicker(context, sura: ruku.sura.index, ruku: ruku.relativeIndex);
                  if ((selection ?? ruku.index) != ruku.index) {
                    log("$selection");
                    context!.readerBloc.add(ViewRukuBlocEvent(index: selection!));
                  }
                },
                builder: (_,__) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " ",
                        textScaler: TextScaler.linear(.9),
                      ),
                      Icon(Icons.bookmark),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 2),

          Expanded(
            child: FocusTraversalOrder(
              order: const GroupFocusOrder(GroupFocusOrder.groupReaderCommands, 12),
              child: ButtonDialogAction(
                isDefault: true,
                onAction: (close) {

                  if (_isReady) {
                    _isReady = false;
                    final event = _isDailyRuku ? GetNextDailyRukuBlocEvent():ViewRukuBlocEvent(index: ruku.index + 1);
                    context.readerBloc.add(event);
                  }

                },
                builder: (_,__) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.localizations.translate("page_reader_readnext"),
                        textScaler: const TextScaler.linear(.9),
                      ),
                      const Icon(Icons.navigate_next),
                    ],
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
