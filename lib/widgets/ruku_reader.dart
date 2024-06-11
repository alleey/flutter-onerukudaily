
import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/ruku.dart';
import '../utils/conversion.dart';

class RukuReader extends StatelessWidget {

  const RukuReader({
    super.key,
    required this.ruku,
    required this.settings,
    this.scrollHeader,
    this.scrollFooter
  });

  final Ruku ruku;
  final AppSettings settings;
  final Widget? scrollHeader;
  final Widget? scrollFooter;

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context, ruku, settings);
  }

  Widget _buildLayout(BuildContext context, Ruku ruku, AppSettings config) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            if (scrollHeader != null)
              scrollHeader!,

            _buildAyat(context, ruku, config),

            if (scrollFooter != null)
              scrollFooter!,
          ],
        ),
      ),
    );
  }

  Widget _buildAyat(BuildContext context, Ruku ruku, AppSettings config) {

    var ayaNumber = ruku.firstAya;
    List<InlineSpan> ayatList = [];

    var colorText = Colors.black;
    var colorBg = Colors.white;

    for (var aya in ruku.ayat) {

      if (ayaNumber == ruku.sajdaAya) {
        colorBg = Colors.green.shade700;
        colorText = Colors.yellow;
      } else {
        colorText = ayaNumber % 2 == 0 ? Colors.black : Colors.black;
        colorBg = ayaNumber % 2 == 0 ? Colors.white : const Color.fromARGB(255, 229, 235, 238);
      }

      ayatList.add(TextSpan(
          text: aya,
          style: TextStyle(
            fontSize: config.fontSize,
            fontFamily: config.font,
            color: colorText,
            backgroundColor: colorBg,
          ),
        )
      );

      ayatList.add(TextSpan(
          text: " \uFD3F",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: config.fontSize,
            fontFamily: config.font,
            fontWeight: FontWeight.bold,
          )
        ),
      );
      ayatList.add(TextSpan(
          text: config.showArabicNumerals ? ConversionUtils.toArabicNumeral(ayaNumber) : ayaNumber.toString(),
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: config.fontSize - 12,
            fontFamily: config.font,
            fontWeight: FontWeight.bold,
          )
        ),
      );
      ayatList.add(TextSpan(
          text: "\uFD3E \n",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: config.fontSize,
            fontFamily: config.font,
            fontWeight: FontWeight.bold,
          )
        ),
      );

      ayaNumber++;
    }

    return SelectionArea(
      child: Text.rich(
        TextSpan(children: ayatList),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        selectionColor: const Color(0xAF6694e8),
      ),
    );
  }
}

