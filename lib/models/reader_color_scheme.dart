// dart pub run build_runner build

import 'package:flutter/material.dart';

import '../utils/conversion.dart';

class ReaderAyaColorScheme {
  final Color background;
  final Color text;

  const ReaderAyaColorScheme({
    this.background = Colors.black,
    this.text = Colors.white,
  });

  ReaderAyaColorScheme copyWith({
    Color? background,
    Color? text,
  }) {
    return ReaderAyaColorScheme(
      background: background ?? this.background,
      text: text ?? this.text,
    );
  }

  factory ReaderAyaColorScheme.fromJson(Map<String, dynamic> hexColors, { ReaderAyaColorScheme? defaults }) {
    return ReaderAyaColorScheme(
      background: ColorExtensions.fromHex(hexColors['background'] ?? (defaults?.background ?? Colors.black).toHex()),
      text: ColorExtensions.fromHex(hexColors['text'] ?? (defaults?.text ?? Colors.white).toHex()),
    );
  }

  Map<String, String> toJson() {
    return {
      'background': background.toHex(),
      'text': text.toHex(),
    };
  }
}

class ReaderColorScheme {
  static const defaultAyaScheme = ReaderAyaColorScheme(text: Colors.black, background: Color.fromARGB(255, 229, 235, 238));
  static const defaultAyaOddScheme = ReaderAyaColorScheme(text: Colors.black, background: Colors.white);
  static const defaultAyaSajdaScheme = ReaderAyaColorScheme(text: Colors.yellow, background: Colors.green);

  final Color background;
  final ReaderAyaColorScheme aya;
  final ReaderAyaColorScheme ayaOdd;
  final ReaderAyaColorScheme ayaSajda;
  final Color markers;

  const ReaderColorScheme({
    this.background = Colors.white,
    this.aya = defaultAyaScheme,
    this.ayaOdd = defaultAyaOddScheme,
    this.ayaSajda = defaultAyaSajdaScheme,
    this.markers = Colors.deepOrange,
  });

  ReaderColorScheme copyWith({
    Color? background,
    ReaderAyaColorScheme? aya,
    ReaderAyaColorScheme? ayaOdd,
    ReaderAyaColorScheme? ayaSajda,
    Color? markers,
  }) {
    return ReaderColorScheme(
      background: background ?? this.background,
      aya: aya ?? this.aya,
      ayaOdd: ayaOdd ?? this.ayaOdd,
      ayaSajda: ayaSajda ?? this.ayaSajda,
      markers: markers ?? this.markers,
    );
  }

  factory ReaderColorScheme.fromJson(Map<String, dynamic> json) {
    return ReaderColorScheme(
      background: ColorExtensions.fromHex(json['background'] ?? Colors.white.toHex()),
      aya: ReaderAyaColorScheme.fromJson(json['aya'] ?? {}, defaults: defaultAyaScheme),
      ayaOdd: ReaderAyaColorScheme.fromJson(json['ayaOdd'] ?? {}, defaults: defaultAyaOddScheme),
      ayaSajda: ReaderAyaColorScheme.fromJson(json['ayaSajda'] ?? {}, defaults: defaultAyaSajdaScheme),
      markers: ColorExtensions.fromHex(json['markers'] ?? Colors.deepOrange.toHex()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background.toHex(),
      'aya': aya.toJson(),
      'ayaOdd': ayaOdd.toJson(),
      'ayaSajda': ayaSajda.toJson(),
      'markers': markers.toHex(),
    };
  }
}
