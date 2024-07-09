
// dart pub run build_runner build

import '../common/app_color_scheme.dart';
import 'reader_settings.dart';

class AppSettings {
  final String theme;
  final String locale;
  final ReaderSettings readerSettings;

  AppSettings({
    this.theme = "default",
    this.locale = "en",
    ReaderSettings? readerSettings,
  }) : readerSettings = readerSettings ?? ReaderSettings();

  AppSettings copyWith({
    String? theme,
    String? locale,
    ReaderSettings? readerSettings,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
      readerSettings: readerSettings ?? this.readerSettings,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: json['theme'] as String,
      locale: json['locale'] as String,
      readerSettings: ReaderSettings.fromJson(json['readerSettings'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'locale': locale,
      'readerSettings': readerSettings.toJson(),
    };
  }

  @override
  String toString() {
    return 'AppSettings(theme: $theme, locale: $locale, readerSettings: $readerSettings)';
  }
}
extension AppSettingsExtensions on AppSettings {
  AppColorScheme get currentScheme => AppColorSchemes.fromName(theme);
}

