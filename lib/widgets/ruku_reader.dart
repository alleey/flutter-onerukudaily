
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/custom_traversal_policy.dart';
import '../models/reader_settings.dart';
import '../models/ruku.dart';
import '../utils/conversion.dart';
import 'common/focus_highlight.dart';

enum ReaderTextSpanType {
  bismillah,
  aya,
  ayaMarker
}

class RukuReader extends StatelessWidget {

  RukuReader({
    super.key,
    required this.ruku,
    required this.settings,
    this.scrollHeader,
    this.scrollFooter,
    this.padding,
  });

  final Ruku ruku;
  final ReaderSettings settings;
  final Widget? scrollHeader;
  final Widget? scrollFooter;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context, ruku, settings);
  }

  Widget _buildLayout(BuildContext context, Ruku ruku, ReaderSettings settings) {

    return Container(
      color: settings.colorScheme.background,
      padding: padding ?? const EdgeInsets.all(5.0),
      child: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            if (scrollHeader != null)
              scrollHeader!,

            if (ruku.hasBismillah)
              _buildBismillah(context, settings),

            _buildAyat(context, ruku, settings),

            if (scrollFooter != null)
              scrollFooter!,
          ],
        ),
      ),
    );
  }

  Widget _buildBismillah(BuildContext context, ReaderSettings settings) {

    final fontSize = settings.fontSize;
    return Container(
      color: settings.colorScheme.aya.text,
      child: Semantics(
        container: true,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: settings.font,
                  color: settings.colorScheme.aya.background,
                ),
              )
            ]
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl
        ),
      ),
    );
  }

  @protected
  Widget _buildAyat(BuildContext context, Ruku ruku, ReaderSettings settings) {

    var ayaNumber = ruku.firstAya;
    final fontSize = settings.fontSize;
    List<InlineSpan> ayatList = [];

    ruku.ayat.forEachIndexed((index, aya) {

      final ayaColorScheme = switch(ayaNumber) {
        _ when(ayaNumber == ruku.sajdaAya) => settings.colorScheme.ayaSajda,
        _ when(ayaNumber % 2 == 1) => settings.colorScheme.ayaOdd,
        _ => settings.colorScheme.aya,
      };

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
        text: " $aya ",
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: settings.font,
          color: ayaColorScheme.text,
          backgroundColor: ayaColorScheme.background,
        ),
      ));

      if (!settings.numberBeforeAya) {
        ayatList.addAll(
          _buildAyaNumber(context, settings, ayaNumber)
        );
      }

      ayaNumber++;
    });

    return Text.rich(
      TextSpan(children: ayatList),
      textAlign: settings.ayaPerLine ? TextAlign.start : TextAlign.justify,
      textDirection: TextDirection.rtl,
      selectionColor: const Color(0xAF6694e8),
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
        ),
      ),

      TextSpan(
        text: settings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ayaNumber) : ayaNumber.toString(),
        style: TextStyle(
          color: settings.colorScheme.markers,
          fontSize: settings.fontSize - 2,
          fontFamily: settings.font,
          fontWeight: FontWeight.bold,
        ),
      ),

      TextSpan(
        text: "\uFD3E",
        style: TextStyle(
          color: settings.colorScheme.markers,
          fontSize: settings.fontSize,
          fontFamily: settings.font,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }
}

class RukuReaderAndroidTV extends RukuReader {

  RukuReaderAndroidTV({
    super.key,
    required super.ruku,
    required super.settings,
    super.scrollHeader,
    super.scrollFooter,
    super.padding,
  });

  @override
  Widget _buildAyat(BuildContext context, Ruku ruku, ReaderSettings settings) {

    var ayaNumber = ruku.firstAya;
    final fontSize = settings.fontSize;
    List<Widget> ayatList = [];

    ruku.ayat.forEachIndexed((index, aya) {

      final ayaColorScheme = switch(ayaNumber) {
        _ when(ayaNumber == ruku.sajdaAya) => settings.colorScheme.ayaSajda,
        _ when(ayaNumber % 2 == 1) => settings.colorScheme.ayaOdd,
        _ => settings.colorScheme.aya,
      };

      if (settings.numberBeforeAya) {
        ayatList.add(
          _buildAyaNumberTV(context, settings, ayaNumber)
        );
      }

      ayatList.add(
        _createTextSpan(
          text: " $aya ",
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: settings.font,
            color: ayaColorScheme.text,
            backgroundColor: ayaColorScheme.background,
          ),
          focusable: true,
          focusColor: ayaColorScheme.text.withOpacity(.1)
        ));

      if (!settings.numberBeforeAya) {
        ayatList.add(
          _buildAyaNumberTV(context, settings, ayaNumber)
        );
      }

      ayaNumber++;
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ayatList
      ),
    );
  }

  Widget _buildAyaNumberTV(BuildContext context, ReaderSettings settings, int ayaNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        _createTextSpan(
          text: "\uFD3F",
          style: TextStyle(
            color: settings.colorScheme.markers,
            fontSize: settings.fontSize,
            fontFamily: settings.font,
            fontWeight: FontWeight.bold,
          ),
          focusable: false
        ),

        _createTextSpan(
          text: settings.showArabicNumerals ? ConversionUtils.toArabicNumeral(ayaNumber) : ayaNumber.toString(),
          style: TextStyle(
            color: settings.colorScheme.markers,
            fontSize: settings.fontSize - 2,
            fontFamily: settings.font,
            fontWeight: FontWeight.bold,
          ),
          focusable: false
        ),

        _createTextSpan(
          text: "\uFD3E",
          style: TextStyle(
            color: settings.colorScheme.markers,
            fontSize: settings.fontSize,
            fontFamily: settings.font,
            fontWeight: FontWeight.bold,
          ),
          focusable: false
        ),
      ]
    );
  }

  Widget _createTextSpan({
    required String text,
    TextStyle? style,
    bool focusable = true,
    Color focusColor = Colors.transparent,
  }) {

    final child = Text(
      text,
      semanticsLabel: text,
      style: style,
      textAlign: TextAlign.justify,
    );

    final canRequestFocus = focusable;

    return canRequestFocus ? FocusHighlight(
      focusColor: focusColor,
      canRequestFocus: true,
      overlayMode: true,
      child: child,
    ):
    child;
  }
}
