import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/reader_bloc.dart';
import '../../common/constants.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
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

  var settings = AppSettings();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.readerBloc.add(ReadRukuBlocEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(Constants.appTitle),
      ),
      body: BlocConsumer<ReaderBloc, ReaderBlocState>(
        listener: (context, state) {

          log("reader listener: $state");
          if (state is RukuIndexExhaustedState) {
            //_buildCompletionAlert(context).show();
          }
        },
        builder: (context, state) {

          log("reader builder: $state");
          if (state is RukuAvailableState) {

            return Column(
              children: [
                _buildHeader(context, state.ruku, settings),
                Expanded(
                  child: RukuReader(
                    key: ObjectKey(state.ruku.index),
                    ruku: state.ruku,
                    settings: settings.readerSettings,
                    scrollFooter: _buildScrollFooter(context, state.ruku, settings),
                  ),
                ),
              ],
            );
          }

          return const Center(child: LoadingIndicator(message: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ"));
        }
      ),
    );
  }

  Widget _buildCompletionAlert(BuildContext context) {
    return SizedBox();
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

  Widget _buildHeader(BuildContext context, Ruku ruku, AppSettings config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                ruku.sura.name,
                style: TextStyle(
                  color: ruku.sura.isMakki ? Color.fromARGB(255, 236, 209, 38) : const Color.fromARGB(255, 147, 223, 60),
                  fontSize: 48,
                  fontFamily: config.readerSettings.font,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              Positioned(
                  left: 10,
                  child: Text(
                    "#${config.readerSettings.showArabicNumerals
                        ? ConversionUtils.toArabicNumeral(ruku.index)
                        : ruku.index.toString()}", // ركوع
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 32,
                        fontFamily: config.readerSettings.font),
                  )),
              Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, KnownRouteNames.settings);
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScrollFooter(BuildContext context, Ruku ruku, AppSettings config) {
    return ButtonDialogAction(
      isDefault: true,
      onAction: (close) {
        context.readerBloc.add(ReadRukuBlocEvent(index: ruku.index + 1));
      },
      builder: (_,__) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.navigate_before),
            SizedBox(width: 5),
            Text("Read Next"),
          ],
        ),
      ),
    );
  }
}
