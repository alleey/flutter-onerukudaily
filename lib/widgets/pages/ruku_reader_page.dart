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
  Ruku? _rukuRead;

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
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  _buildContents(context, settings)
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;

    return Scaffold(
      appBar: _rukuRead == null ? null :
        AppBar(
          centerTitle: true,
          title: _buildSuraName(_rukuRead!, settings),
          backgroundColor: scheme.page.background,
          foregroundColor: scheme.page.text,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.lightGreen,
              ),
              onPressed: () {
                Navigator.pushNamed(context, KnownRouteNames.settings);
              },
            )
          ],
        ),
      body: Container(
        color: scheme.page.background,
        child: BlocConsumer<ReaderBloc, ReaderBlocState>(
          listener: (context, state) {

            log("reader listener: $state");
            if (state is RukuIndexExhaustedState) {
              //_buildCompletionAlert(context).show();
            }
            if (state is RukuAvailableState) {
              setState(() {
                _rukuRead = state.ruku;
              });
            }


          },
          builder: (context, state) {

            log("reader builder: $state");
            if (_rukuRead != null) {

              return Column(
                children: [
                  Expanded(
                    child: RukuReader(
                      key: ObjectKey(_rukuRead!.index),
                      ruku: _rukuRead!,
                      settings: settings.readerSettings,
                      scrollFooter: _buildScrollFooter(context, _rukuRead!, settings),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: LoadingIndicator(message: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ"));
          }
        ),
      ),
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

  // Widget _buildHeader(BuildContext context, Ruku ruku, AppSettings config) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Container(
  //         color: Colors.black,
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             _buildSuraName(ruku, config),
  //             Positioned(
  //                 left: 10,
  //                 child: _buildRukuNumber(config, ruku)),
  //             Positioned(
  //                 right: 0,
  //                 child: IconButton(
  //                   icon: const Icon(
  //                     Icons.settings,
  //                     color: Colors.lightGreen,
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pushNamed(context, KnownRouteNames.settings);
  //                   },
  //                 )
  //               ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildRukuNumber(AppSettings config, Ruku ruku) {
  //   return Text(
  //     "#${config.readerSettings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ruku.index) : ruku.index.toString()}", // ركوع
  //     style: TextStyle(
  //         color: Colors.lightGreen,
  //         fontSize: 32,
  //         fontFamily: config.readerSettings.font),
  //   );
  // }

  Widget _buildSuraName(Ruku ruku, AppSettings config) {
    return Text(
      "${ruku.sura.name} - #${config.readerSettings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ruku.index) : ruku.index.toString()}" ,
      style: TextStyle(
        color: ruku.sura.isMakki ? Color.fromARGB(255, 236, 209, 38) : const Color.fromARGB(255, 147, 223, 60),
        fontSize: 48,
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
