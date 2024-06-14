import 'package:flutter/material.dart';
import 'package:one_ruku_daily/utils/conversion.dart';

////////////////////////////////////////////

sealed class AppColorSchemes {

  static const String defaultSchemeName = "default";

  static final Map<String, AppColorScheme> _schemes = {
    defaultSchemeName: defaultScheme(),
    "1": theme1(),
    "2": theme2(),
    "3": theme3(),
    "4": theme4(),
    "5": theme5(),
    "6": theme6(),
    "7": theme7(),
  };

  static Iterable<MapEntry<String, AppColorScheme>> get all => _schemes.entries;
  static AppColorScheme fromName(String? name) => _schemes[name ?? defaultSchemeName] ?? defaultScheme();

  static AppColorScheme defaultScheme() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("322C2B"),
      ColorExtensions.fromHex("803D3B"),
      ColorExtensions.fromHex("AF8260"),
      ColorExtensions.fromHex("E4C59E"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme1() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("151515"),
      ColorExtensions.fromHex("a91d3a"),
      ColorExtensions.fromHex("c73659"),
      ColorExtensions.fromHex("eeeeee"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme2() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("f5dad2"),
      ColorExtensions.fromHex("fcffe0"),
      ColorExtensions.fromHex("bacd92"),
      ColorExtensions.fromHex("75a47f"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme3() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("543310"),
      ColorExtensions.fromHex("74512D"),
      ColorExtensions.fromHex("AF8F6F"),
      ColorExtensions.fromHex("F8F4E1"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme4() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("12372a"),
      ColorExtensions.fromHex("436850"),
      ColorExtensions.fromHex("adbc9f"),
      ColorExtensions.fromHex("fbfada"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme5() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("402b3a"),
      ColorExtensions.fromHex("d63484"),
      ColorExtensions.fromHex("ff9bd2"),
      ColorExtensions.fromHex("f8f4ec"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme6() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("0f1035"),
      ColorExtensions.fromHex("365486"),
      ColorExtensions.fromHex("7fc7d9"),
      ColorExtensions.fromHex("dcf2f1"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme7() {
    final palette = ColorPalette(
      ColorExtensions.fromHex("FEFAF6"),
      ColorExtensions.fromHex("EADBC8"),
      ColorExtensions.fromHex("DAC0A3"),
      ColorExtensions.fromHex("102C57"),
    );
    return AppColorScheme.fromPalette(palette);
  }
}

////////////////////////////////////////////

class ColorPalette {
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  ColorPalette(this.color1, this.color2, this.color3, this.color4);

  ColorPalette copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
  }) {
    return ColorPalette(
      color1 ?? this.color1,
      color2 ?? this.color2,
      color3 ?? this.color3,
      color4 ?? this.color4,
    );
  }
}

class AppButtonColorScheme {
  final Color background;
  final Color text;
  final Color overlay;
  final Color icon;

  AppButtonColorScheme({
    required this.background,
    required this.text,
    this.overlay = Colors.transparent,
    Color? icon,
  }) : icon = icon ?? text;

  AppButtonColorScheme copyWith({
    Color? text,
    Color? background,
    Color? overlay,
    Color? icon,
  }) {
    return AppButtonColorScheme(
      text: text ?? this.text,
      background: background ?? this.background,
      overlay: overlay ?? this.overlay,
      icon: icon ?? this.icon,
    );
  }
}

class AppDialogColorScheme {
  final Color surfaceTintColor;
  final Color background;
  final Color text;
  final Color textHighlight;

  final AppButtonColorScheme button;
  final AppButtonColorScheme defaultButton;

  AppDialogColorScheme({
    required this.background,
    required this.text,
    Color? textHighlight,
    required this.button,
    AppButtonColorScheme? defaultButton,
    this.surfaceTintColor = Colors.transparent,
  }) : defaultButton = defaultButton ?? button,
       textHighlight = textHighlight ?? text;

  AppDialogColorScheme copyWith({
    Color? surfaceTintColor,
    Color? background,
    Color? text,
    Color? textHighlight,
    AppButtonColorScheme? button,
    AppButtonColorScheme? defaultButton,
  }) {
    return AppDialogColorScheme(
      background: background ?? this.background,
      text: text ?? this.text,
      textHighlight: textHighlight ?? this.textHighlight,
      button: button ?? this.button,
      defaultButton: defaultButton ?? this.defaultButton,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    );
  }
}

class AppPageColorScheme {
  final Color background;
  final Color text;
  final Color textHighlight;
  final AppButtonColorScheme button;
  final AppButtonColorScheme defaultButton;

  AppPageColorScheme({
    required this.background,
    required this.text,
    Color? textHighlight,
    required this.button,
    AppButtonColorScheme? defaultButton,
    Color? icon,
  }) : defaultButton = defaultButton ?? button,
       textHighlight = textHighlight ?? text;

  AppPageColorScheme copyWith({
    Color? text,
    Color? textHighlight,
    Color? background,
    AppButtonColorScheme? button,
    AppButtonColorScheme? defaultButton,
  }) {
    return AppPageColorScheme(
      text: text ?? this.text,
      textHighlight: textHighlight ?? this.textHighlight,
      background: background ?? this.background,
      button: button ?? this.button,
      defaultButton: defaultButton ?? this.defaultButton,
    );
  }
}

// There is a name conflict with a built-in ColorScheme class
//
class AppColorScheme {

  final ColorPalette palette;
  final AppDialogColorScheme dialog;
  final AppPageColorScheme page;

  AppColorScheme({
    required this.palette,
    required this.dialog,
    required this.page,
  });

  factory AppColorScheme.fromPalette(ColorPalette palette) {
    return AppColorScheme(
      palette: palette,
      dialog: AppDialogColorScheme(
        background: palette.color3,
        text: palette.color4,
        textHighlight: palette.color1,
        button: AppButtonColorScheme(text: palette.color4, background: palette.color1),
        defaultButton: AppButtonColorScheme(text: palette.color4, background: palette.color2),
        surfaceTintColor: palette.color4,
      ),
      page: AppPageColorScheme(
        background: palette.color3,
        text: palette.color4,
        textHighlight: palette.color1,
        button: AppButtonColorScheme(text: palette.color4, background: palette.color1),
        defaultButton: AppButtonColorScheme(text: palette.color4, background: palette.color2),
      )
    );
  }
}
