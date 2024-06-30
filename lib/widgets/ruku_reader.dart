
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../localizations/app_localizations.dart';
import '../models/reader_settings.dart';
import '../models/ruku.dart';
import '../utils/conversion.dart';
import 'common/focus_highlight.dart';

class RukuReader extends StatefulWidget {

  const RukuReader({
    super.key,
    required Ruku ruku,
    required ReaderSettings settings,
    this.scrollHeader,
    this.scrollFooter,
    this.padding,
    this.scrollController,
    this.enableScrollControls = false,
    this.scrollDistance = 25,
  }) : _ruku = ruku, _settings = settings;

  final Ruku _ruku;
  final ReaderSettings _settings;
  final ScrollController? scrollController;
  final Widget? scrollHeader;
  final Widget? scrollFooter;
  final EdgeInsets? padding;
  final bool enableScrollControls;
  final double scrollDistance;

  @override
  State<RukuReader> createState() => _RukuReaderState();
}

class _RukuReaderState extends State<RukuReader> {

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
  }

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

          if (widget.enableScrollControls)
            _buildScrollControls(context, settings),

          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
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

  Widget _buildScrollControls(BuildContext context, ReaderSettings settings) {
    return Row(
      children: [
        Semantics(
          label: context.localizations.translate("page_reader_scroll_down"),
          button: true,
          excludeSemantics: true,
          child: FocusHighlight(
            focusColor: settings.colorScheme.aya.background.withOpacity(.5),
            child: IconButton(
              icon: Icon(Icons.arrow_downward, color: settings.colorScheme.aya.text),
              padding: EdgeInsets.zero,
              onPressed: () {
                _controller.animateTo(
                  _controller.offset + widget.scrollDistance,
                  curve: Curves.easeIn,
                  duration: const Duration (milliseconds: 250)
                );
              },
              color: settings.colorScheme.aya.background,
            ),
          ),
        ),
        const Spacer(),
        Semantics(
          label: context.localizations.translate("page_reader_scroll_up"),
          button: true,
          excludeSemantics: true,
          child: FocusHighlight(
            focusColor: settings.colorScheme.aya.background.withOpacity(.5),
            child: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero
              ),
              icon: Icon(Icons.arrow_upward, color: settings.colorScheme.aya.text),
              padding: EdgeInsets.zero,
              onPressed: () {
                _controller.animateTo(
                  _controller.offset - widget.scrollDistance,
                  curve: Curves.easeIn,
                  duration: const Duration (milliseconds: 250)
                );
              },
              color: settings.colorScheme.aya.background,
            ),
          ),
        )
      ],
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

  const RukuReaderAndroidTV({
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

    return focusable ? FocusHighlight(
      focusColor: focusColor,
      canRequestFocus: true,
      overlayMode: true,
      child: child,
    ):
    child;
  }
}
