
// dart pub run build_runner build

import '../common/app_color_scheme.dart';
import 'reader_settings.dart';

class AppSettings {
  final String theme;
  final String locale;
  final ReaderSettings readerSettings;
  final bool allowMultipleReminders;

  AppSettings({
    this.theme = "default",
    this.locale = "en",
    this.allowMultipleReminders = false,
    ReaderSettings? readerSettings,
  }) : readerSettings = readerSettings ?? const ReaderSettings();

  AppSettings copyWith({
    String? theme,
    String? locale,
    bool? allowMultipleReminders,
    ReaderSettings? readerSettings,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
      allowMultipleReminders: allowMultipleReminders ?? this.allowMultipleReminders,
      readerSettings: readerSettings ?? this.readerSettings,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: json['theme'] as String,
      locale: json['locale'] as String,
      allowMultipleReminders: (json['allowMultipleReminders'] ?? false) as bool,
      readerSettings: ReaderSettings.fromJson(json['readerSettings'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'locale': locale,
      'allowMultipleReminders': allowMultipleReminders,
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

