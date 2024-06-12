
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/reader_settings.dart';
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
  final ReaderSettings settings;
  final Widget? scrollHeader;
  final Widget? scrollFooter;

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context, ruku, settings);
  }

  Widget _buildLayout(BuildContext context, Ruku ruku, ReaderSettings config) {
    return Container(
      color: config.colorScheme.background,
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

  Widget _buildAyat(BuildContext context, Ruku ruku, ReaderSettings settings) {

    var ayaNumber = ruku.firstAya;
    List<InlineSpan> ayatList = [];

    final fontSize = settings.fontSize;

    ruku.ayat.forEachIndexed((index, aya) {

      var ayaColorScheme = settings.colorScheme.aya;
      if (ayaNumber == ruku.sajdaAya) {
        ayaColorScheme = settings.colorScheme.ayaSajda;
      } else if (ayaNumber % 2 == 1) {
        ayaColorScheme = settings.colorScheme.ayaOdd;
      }

      if (settings.ayaPerLine && index > 0) {
        ayatList.add(TextSpan(
            text: "\n",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: settings.font,
            ),
          )
        );
      }

      if (settings.numberBeforeAya) {
        ayatList.addAll(
          _buildAyaNumber(context, settings, ayaNumber)
        );
      }

      ayatList.add(TextSpan(
          text: aya,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: settings.font,
            color: ayaColorScheme.text,
            backgroundColor: ayaColorScheme.background,
          ),
        )
      );

      if (!settings.numberBeforeAya) {
        ayatList.addAll(
          _buildAyaNumber(context, settings, ayaNumber)
        );
      }

      ayaNumber++;
    });

    return SelectionArea(
      child: Text.rich(
        TextSpan(children: ayatList),
        textAlign: settings.ayaPerLine ? TextAlign.start : TextAlign.justify,
        textDirection: TextDirection.rtl,
        selectionColor: const Color(0xAF6694e8),
      ),
    );
  }

    Iterable<InlineSpan> _buildAyaNumber(BuildContext context, ReaderSettings settings, int ayaNumber) {
      return [
        TextSpan(
            text: "\uFD3F",
            style: TextStyle(
              color: settings.colorScheme.markers,
              fontSize: settings.fontSize,
              fontFamily: settings.font,
              fontWeight: FontWeight.bold,
            )
          ),

        TextSpan(
            text: settings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ayaNumber) : ayaNumber.toString(),
            style: TextStyle(
              color: settings.colorScheme.markers,
              fontSize: settings.fontSize - 2,
              fontFamily: settings.font,
              fontWeight: FontWeight.bold,
            )
          ),

        TextSpan(
            text: "\uFD3E",
            style: TextStyle(
              color: settings.colorScheme.markers,
              fontSize: settings.fontSize,
              fontFamily: settings.font,
              fontWeight: FontWeight.bold,
            )
          ),
      ];
    }
}

