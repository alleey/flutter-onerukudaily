
// dart pub run build_runner build

import '../common/app_color_scheme.dart';

class AppSettings {
  final bool showArabicNumerals;
  final double fontSize;
  final String font;
  final String theme;
  final String locale;

  AppSettings({
    this.fontSize = 36,
    this.showArabicNumerals = false,
    this.font = "Lateef",
    this.theme = "default",
    this.locale = "en",
  });

  AppSettings copyWith({
      double? fontSize,
      bool? showArabicNumerals,
      String? font,
      String? theme,
      String? locale,
    })
  {
     return AppSettings(
      fontSize: fontSize ?? this.fontSize,
      showArabicNumerals: showArabicNumerals ?? this.showArabicNumerals,
      font: font ?? this.font,
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
     );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      locale: json['locale'] as String,
      theme: json['theme'] as String,
      font: json['font'] as String,
      fontSize: json['fontSize'] as double,
      showArabicNumerals: json['showArabicNumerals'] as bool,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'locale': locale,
      'theme': theme,
      'font': font,
      'fontSize': fontSize,
      'showArabicNumerals': showArabicNumerals,
    };
  }

  @override
  String toString() {
    return 'Config(fontSize: $fontSize, showArabicNumerals: $showArabicNumerals, font: $font, theme: $theme)';
  }
}

extension AppSettingsExtensions on AppSettings {
  AppColorScheme get currentScheme => AppColorSchemes.fromName(theme);
}

