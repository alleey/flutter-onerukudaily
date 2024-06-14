// dart pub run build_runner build
import 'reader_color_scheme.dart';

class ReaderSettings {
  final bool showArabicNumerals;
  final bool numberBeforeAya;
  final bool ayaPerLine;
  final double fontSize;
  final String font;
  final ReaderColorScheme colorScheme;

  const ReaderSettings({
    this.showArabicNumerals = false,
    this.numberBeforeAya = false,
    this.ayaPerLine = false,
    this.fontSize = 24,
    this.font = "Lateef",
    this.colorScheme = const ReaderColorScheme()
  });

  ReaderSettings copyWith({
    bool? showArabicNumerals,
    bool? numberBeforeAya,
    bool? ayaPerLine,
    double? fontSize,
    String? font,
    ReaderColorScheme? colorScheme,
  }) {
    return ReaderSettings(
      showArabicNumerals: showArabicNumerals ?? this.showArabicNumerals,
      numberBeforeAya: numberBeforeAya ?? this.numberBeforeAya,
      ayaPerLine: ayaPerLine ?? this.ayaPerLine,
      fontSize: fontSize ?? this.fontSize,
      font: font ?? this.font,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  factory ReaderSettings.fromJson(Map<String, dynamic> json) {
    return ReaderSettings(
      showArabicNumerals: (json['showArabicNumerals'] ?? false) as bool,
      numberBeforeAya: (json['numberBeforeAya'] ?? false) as bool,
      ayaPerLine: (json['ayaPerLine'] ?? false) as bool,
      fontSize: (json['fontSize'] ?? 24) as double,
      font: (json['font'] ?? "Scheherazade") as String,
      colorScheme: ReaderColorScheme.fromJson(json['colorScheme'] ?? {})
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showArabicNumerals': showArabicNumerals,
      'numberBeforeAya': numberBeforeAya,
      'ayaPerLine': ayaPerLine,
      'fontSize': fontSize,
      'font': font,
      'colorScheme': colorScheme.toJson(),
    };
  }

  @override
  String toString() {
    return 'ReaderSettings(showArabicNumerals: $showArabicNumerals, numberBeforeAya: $numberBeforeAya, ayaPerLine: $ayaPerLine, fontSize: $fontSize, font: $font)';
  }
}
