// dart pub run build_runner build

class ReaderSettings {
  final bool showArabicNumerals;
  final bool numberBeforeAya;
  final bool ayaPerLine;
  final double fontSize;
  final String font;

  ReaderSettings({
    this.showArabicNumerals = false,
    this.numberBeforeAya = false,
    this.ayaPerLine = false,
    this.fontSize = 24,
    this.font = "Lateef",
  });

  ReaderSettings copyWith({
    bool? showArabicNumerals,
    bool? numberBeforeAya,
    bool? ayaPerLine,
    double? fontSize,
    String? font,
  }) {
    return ReaderSettings(
      showArabicNumerals: showArabicNumerals ?? this.showArabicNumerals,
      numberBeforeAya: numberBeforeAya ?? this.numberBeforeAya,
      ayaPerLine: ayaPerLine ?? this.ayaPerLine,
      fontSize: fontSize ?? this.fontSize,
      font: font ?? this.font,
    );
  }

  factory ReaderSettings.fromJson(Map<String, dynamic> json) {
    return ReaderSettings(
      showArabicNumerals: (json['showArabicNumerals'] ?? false) as bool,
      numberBeforeAya: (json['numberBeforeAya'] ?? false) as bool,
      ayaPerLine: (json['ayaPerLine'] ?? false) as bool,
      fontSize: (json['fontSize'] ?? 24) as double,
      font: (json['font'] ?? "Lateef") as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showArabicNumerals': showArabicNumerals,
      'numberBeforeAya': numberBeforeAya,
      'ayaPerLine': ayaPerLine,
      'fontSize': fontSize,
      'font': font,
    };
  }

  @override
  String toString() {
    return 'ReaderSettings(showArabicNumerals: $showArabicNumerals, numberBeforeAya: $numberBeforeAya, ayaPerLine: $ayaPerLine, fontSize: $fontSize, font: $font)';
  }
}
