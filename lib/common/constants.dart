

class Constants {

  static const int appDataVersion = 1;
  static const String appTitle = "1 Ruku Everyday";
  static const String loaderText = "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ";

  static const int maxReminders = 5;
  static const double minReaderFontSize = 14;
  static const double maxReaderFontSize = 96;

  static const int maxDailyStatsDays = 90;

  static const int readerOpenDelay = 1000;

  static const List<String> locales = ['en'];

  static const List<String> fonts = [
    "Amiri",
    //"Baloo_Bhaijaan",
    //"Cairo",
    //"Changa",
    "El_Messiri",
    "Harmattan",
    "Jomhuria",
    "Katibeh",
    //"Lalezar",
    "Lateef",
    //"Lemonada",
    //"Mada",
    //"Markazi_Text",
    "Mirza",
    //"Rakkas",
    //"Reem_Kufi",
    "p117",
    "Scheherazade",
    //"Tajawal",
  ];
}

class KnownRouteNames {

  static const String about = '/about';
  static const String main = '/main';
  static const String readruku = '/read-ruku';
  static const String reminders = '/reminders';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
}

class KnownSettingsNames {
  static const String rukuIndex = "rukuIndex";

}