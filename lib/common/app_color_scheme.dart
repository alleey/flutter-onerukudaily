import 'package:flutter/material.dart';

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
      _fromHex("114232"),
      _fromHex("87a922"),
      _fromHex("fcdc2a"),
      _fromHex("f7f6bb")
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme1() {
    final palette = ColorPalette(
      _fromHex("151515"),
      _fromHex("a91d3a"),
      _fromHex("c73659"),
      _fromHex("eeeeee"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme2() {
    final palette = ColorPalette(
      _fromHex("f5dad2"),
      _fromHex("fcffe0"),
      _fromHex("bacd92"),
      _fromHex("75a47f"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme3() {
    final palette = ColorPalette(
      _fromHex("c40c0c"),
      _fromHex("ff6500"),
      _fromHex("ff8a08"),
      _fromHex("ffc100"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme4() {
    final palette = ColorPalette(
      _fromHex("12372a"),
      _fromHex("436850"),
      _fromHex("adbc9f"),
      _fromHex("fbfada"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme5() {
    final palette = ColorPalette(
      _fromHex("f8f4ec"),
      _fromHex("ff9bd2"),
      _fromHex("d63484"),
      _fromHex("402b3a"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme6() {
    final palette = ColorPalette(
      _fromHex("dcf2f1"),
      _fromHex("7fc7d9"),
      _fromHex("365486"),
      _fromHex("0f1035"),
    );
    return AppColorScheme.fromPalette(palette);
  }

  static AppColorScheme theme7() {
    final palette = ColorPalette(
      _fromHex("32012F"),
      _fromHex("524C42"),
      _fromHex("E2DFD0"),
      _fromHex("F97300"),
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
  final Color foreground;
  final Color background;
  final Color overlay;
  final Color icon;

  AppButtonColorScheme({
    required this.foreground,
    required this.background,
    this.overlay = Colors.transparent,
    Color? icon,
  }) : icon = icon ?? foreground;

  AppButtonColorScheme copyWith({
    Color? foreground,
    Color? background,
    Color? overlay,
    Color? icon,
  }) {
    return AppButtonColorScheme(
      foreground: foreground ?? this.foreground,
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
    required this.textHighlight,
    required this.button,
    AppButtonColorScheme? defaultButton,
    this.surfaceTintColor = Colors.transparent,
  }) : defaultButton = defaultButton ?? button;

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
  final Color text;
  final Color background;
  final AppButtonColorScheme button;
  final AppButtonColorScheme defaultButton;

  AppPageColorScheme({
    required this.text,
    required this.background,
    required this.button,
    AppButtonColorScheme? defaultButton,
    Color? icon,
  }) : defaultButton = defaultButton ?? button;

  AppPageColorScheme copyWith({
    Color? text,
    Color? background,
    AppButtonColorScheme? button,
    AppButtonColorScheme? defaultButton,
  }) {
    return AppPageColorScheme(
      text: text ?? this.text,
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
        background: palette.color1,
        text: palette.color4,
        textHighlight: palette.color3,
        button: AppButtonColorScheme(foreground: palette.color1, background: palette.color4),
        defaultButton: AppButtonColorScheme(foreground: palette.color1, background: palette.color3),
        surfaceTintColor: palette.color4,
      ),
      page: AppPageColorScheme(
        background: palette.color1,
        text: palette.color4,
        button: AppButtonColorScheme(foreground: palette.color3, background: palette.color2),
        defaultButton: AppButtonColorScheme(foreground: palette.color1, background: palette.color3),
      )
    );
  }

}

Color _fromHex(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff$hex' : hex;
  return Color(int.parse(hex, radix: 16));
}
