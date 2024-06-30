
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/reader_settings.dart';
import '../models/ruku.dart';
import '../utils/conversion.dart';

class RukuReader extends StatefulWidget {

  const RukuReader({
    super.key,
    required Ruku ruku,
    required ReaderSettings settings,
    this.fixedHeader,
    this.scrollHeader,
    this.scrollFooter,
    this.scrollController,
    this.padding,
  }) : _ruku = ruku, _settings = settings;

  final Ruku _ruku;
  final ReaderSettings _settings;
  final Widget? fixedHeader;
  final Widget? scrollHeader;
  final Widget? scrollFooter;
  final EdgeInsets? padding;
  final ScrollController? scrollController;

  @override
  State<RukuReader> createState() => _RukuReaderState();
}

class _RukuReaderState extends State<RukuReader> {

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context, widget._ruku, widget._settings);
  }

  Widget _buildLayout(BuildContext context, Ruku ruku, ReaderSettings settings) {

    return Container(
      color: settings.colorScheme.background,
      padding: widget.padding ?? const EdgeInsets.all(5.0),
      child: Column(
        children: [

          if (widget.fixedHeader != null)
            widget.fixedHeader!,

          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  if (widget.scrollHeader != null)
                    widget.scrollHeader!,

                  // TV has bismillah in scroll buttons
                  if (ruku.hasBismillah)
                    _buildBismillah(context, settings),

                  _buildAyat(context, ruku, settings),

                  if (widget.scrollFooter != null)
                    widget.scrollFooter!,
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBismillah(BuildContext context, ReaderSettings settings) {

    final fontSize = settings.fontSize;
    return Container(
      color: settings.colorScheme.aya.text,
      margin: const EdgeInsets.only(bottom: 5),
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
