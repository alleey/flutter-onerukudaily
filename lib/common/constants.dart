

class Constants {

  static const int appDataVersion = 1;
  static const String appTitle = "1 Ruku Everyday";

  static const int maxReminders = 5;
  static const double minReaderFontSize = 16;
  static const double maxReaderFontSize = 48;

  static const List<String> locales = ['en'];

  static const List<String> fonts = [
    "Amiri",
    "Baloo_Bhaijaan",
    "Cairo",
    "Changa",
    "El_Messiri",
    "Harmattan",
    "Jomhuria",
    "Katibeh",
    "Lalezar",
    "Lateef",
    "Lemonada",
    "Mada",
    "Markazi_Text",
    "Mirza",
    "Rakkas",
    "Reem_Kufi",
    "Scheherazade",
    "Tajawal",
  ];
}

class KnownRouteNames {

  static const String main = '/main';
  static const String readruku = '/read-ruku';
  static const String reminders = '/reminders';
  static const String settings = '/settings';
}

class KnownSettingsNames {
  static const String rukuIndex = "rukuIndex";

}