import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/reader_bloc.dart';
import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../../services/alerts_service.dart';
import '../../utils/conversion.dart';
import '../common/responsive_layout.dart';
import '../dialogs/app_dialog.dart';
import '../loading_indicator.dart';
import '../ruku_reader.dart';
import '../settings_aware_builder.dart';

class RukuReaderPage extends StatefulWidget {
  const RukuReaderPage({super.key});

  @override
  State<RukuReaderPage> createState() => _RukuReaderPageState();
}

class _RukuReaderPageState extends State<RukuReaderPage> {

  Ruku? _ruku;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: Constants.readerOpenDelay), () {
      context.readerBloc.add(ReadRukuBlocEvent());
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

    return Scaffold(
      appBar: _ruku == null ? null :
        PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            centerTitle: true,
            backgroundColor: scheme.page.background,
            foregroundColor: scheme.page.text,
            title: _buildSuraName(context, _ruku!, settings),
            actions: [

              ToggleButtons(
                isSelected: [settings.readerSettings.ayaPerLine, !settings.readerSettings.ayaPerLine],
                onPressed: (int index) {
                  final readerSettings = settings.readerSettings.copyWith(ayaPerLine: index == 0);
                  context.settingsBloc.save(settings: settings.copyWith(readerSettings: readerSettings));
                },
                children: const [
                  Icon(Icons.align_horizontal_right),
                  Icon(Icons.wrap_text),
                ],
              ),

              IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, KnownRouteNames.settings);
                },
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
    );
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {
    return BlocConsumer<ReaderBloc, ReaderBlocState>(
        listener: (context, state) async {

          log("reader listener: $state");

          if (state is RukuIndexExhaustedState) {
            await AlertsService().completionDialog(context, onClose:() => context.readerBloc.add(ResetBlocEvent()));
          }

          if (state is RukuAvailableState) {
            setState(() {
              _ruku = state.ruku;
            });
          }

        },
        builder: (context, state) {

          if (_ruku != null) {
            return Column(
              children: [
                Expanded(
                  child: RukuReader(
                    key: ObjectKey(_ruku!.index),
                    ruku: _ruku!,
                    settings: settings.readerSettings,
                    scrollFooter: _buildScrollFooter(context, _ruku!, settings),
                  ),
                ),
              ],
            );
          }

          return const Center(child: LoadingIndicator(message: Constants.loaderText, direction: TextDirection.rtl));
        }
      );
  }

  Widget _buildCompletionAlert(BuildContext context) {
    return const SizedBox();
    // return Alert(
    //   context: context,
    //   type: AlertType.success,
    //   title: "ٱلْحَمْدُ لِلَّٰهِ",
    //   desc: "You've completed recitation of all the Rukus. The reader will now reset and start from the first Ruku.",
    //   buttons: [
    //     DialogButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //         Future.delayed(const Duration(milliseconds: 3000), () {
    //           configBloc.add(
    //             WriteConfigBlocEvent(config: _config.copyWith(index: 1), reload: true)
    //           );
    //         });
    //       },
    //       width: 120,
    //       child: const Text(
    //         "Continue",
    //         style: TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //     )
    //   ],
    // );
  }

  Widget _buildSuraName(BuildContext context, Ruku ruku, AppSettings config) {
    final titleFontSize = context.layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    return Text(
      "${ruku.sura.name} - #${config.readerSettings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ruku.index) : ruku.index.toString()}" ,
      style: TextStyle(
        //color: ruku.sura.isMakki ? Color.fromARGB(255, 236, 209, 38) : const Color.fromARGB(255, 147, 223, 60),
        fontSize: titleFontSize,
        fontFamily: config.readerSettings.font,
      ),
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildScrollFooter(BuildContext context, Ruku ruku, AppSettings config) {
    return ButtonDialogAction(
      isDefault: true,
      onAction: (close) {
        context.readerBloc.add(ReadRukuBlocEvent(index: ruku.index + 1));
      },
      builder: (_,__) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.navigate_before),
            const SizedBox(width: 5),
            Text(context.localizations.translate("page_reader_readnext")),
          ],
        ),
      ),
    );
  }
}
