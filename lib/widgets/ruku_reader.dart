
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/custom_traversal_policy.dart';
import '../models/reader_settings.dart';
import '../models/ruku.dart';
import '../utils/conversion.dart';
import 'common/focus_highlight.dart';

class RukuReader extends StatelessWidget {

  const RukuReader({
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
      child: FocusTraversalOrder(
        order: const GroupFocusOrder(GroupFocusOrder.groupReaderCommands, 5),
        child: CustomHorizontalScrollView(

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
      ),
    );
  }


  Widget _buildBismillah(BuildContext context, ReaderSettings settings) {

    final fontSize = settings.fontSize;
    return Container(
      color: settings.colorScheme.aya.text,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: settings.font,
                color: settings.colorScheme.aya.background,
              )
            )
          ]
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl
      ),
    );
  }

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
        )
      );

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


class CustomHorizontalScrollView extends StatefulWidget {
  final Widget child;
  final double scrollAmount;

  const CustomHorizontalScrollView({super.key,
    required this.child,
    this.scrollAmount = 50.0, // default scroll amount
  });

  @override
  _CustomHorizontalScrollViewState createState() => _CustomHorizontalScrollViewState();
}

class _CustomHorizontalScrollViewState extends State<CustomHorizontalScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return FocusHighlight(
      focusColor: Colors.red,
      canRequestFocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (_scrollController.offset <= 0) {
              return KeyEventResult.ignored;
            } else {
              _scrollDown();
              return KeyEventResult.handled;
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
              return KeyEventResult.ignored;
            } else {
              _scrollUp();
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: widget.child,
      ),
    );
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - widget.scrollAmount,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + widget.scrollAmount,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}