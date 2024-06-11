
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
