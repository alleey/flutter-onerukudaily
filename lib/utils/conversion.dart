
import 'dart:ui';

class ConversionUtils
{
  static String toArabicNumeral(int number) {
    final List<String> arabicNumerals = [
      '٠',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩'
    ];

    String result = '';
    while (number > 0) {
      int digit = number % 10;
      result = arabicNumerals[digit] + result;
      number ~/= 10;
    }

    return result;
  }


}

extension ColorExtensions on Color {

  static Color fromHex(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff$hex' : hex;
    return Color(int.parse(hex, radix: 16));
  }

  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Color inverse() {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }
}
