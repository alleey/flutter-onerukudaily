import 'package:flutter/material.dart';

import '../widgets/common/responsive_layout.dart';

class DialogLayoutConstants
{
  // the %age of screen size covered by the dialog
  static const String screenCoverPctKey = "dlg.screenCoverPct";
  static final screenCoverPct = ResponsiveValue.from(
    small: const Size(1, 0.9),
    medium: const Size(0.8, 0.9),
    large: const Size(0.7, 0.9),
  );

  static const String paddingKey = "dlg.padding";
  static final padding = ResponsiveValue.from(
    small: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    medium: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    large: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  );

  static const String insetPaddingKey = "dlg.insetPadding";
  static final insetPadding = ResponsiveValue.from(
    small: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    medium: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    large: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
  );

  static final layout = <String, ResponsiveValue<dynamic>>{
    screenCoverPctKey: screenCoverPct,
    paddingKey: padding,
    insetPaddingKey: insetPadding,
  };
}

class AppLayoutConstants
{
  static const String screenCoverPctKey = "app.screenCoverPct";
  static final screenCoverPct = ResponsiveValue.from(
    small: const Size(1, 1),
    medium: const Size(0.8, 1),
    large: const Size(0.7, 1),
  );

  static const String appbarHeightKey = "app.appbarHeight";
  static final appbarHeight = ResponsiveValue<double>.from(
    small: 40,
    medium: 50,
    large: 60,
  );

  static const String titleFontSizeKey = "app.titleFontSize";
  static final titleFontSize = ResponsiveValue<double>.from(
    small: 20,
    medium: 30,
    large: 40,
  );

  static const String bodyFontSizeKey = "app.bodyFontSize";
  static final bodyFontSize = ResponsiveValue<double>.from(
    small: 16,
    medium: 24,
    large: 32,
  );

  static const String mainCardSizeKey = "app.mainCardSize";
  static final mainCardSize = ResponsiveValue.from(
    small: const Size(150, 150),
    medium: const Size(200, 200),
    large: const Size(300, 300),
  );

  static const String mainCardIconSizeKey = "app.mainCardIconSize";
  static final mainCardIconSize = ResponsiveValue.from(
    small: 32.0,
    medium: 42.0,
    large: 56.0,
  );

  static const String reminderIconSizeKey = "app.reminderIconSize";
  static final reminderIconSize = ResponsiveValue.from(
    small: 42.0,
    medium: 56.0,
    large: 64.0,
  );

  static const String colorSchemePickerItemSizeKey = "app.colorSchemePickerItemSize";
  static final colorSchemePickerItemSize = ResponsiveValue.from(
    small: const Size(60, 80),
    medium: const Size(80, 120),
    large: const Size(110, 140),
  );

  static final layout = <String, ResponsiveValue<dynamic>>{
    screenCoverPctKey: screenCoverPct,
    appbarHeightKey: appbarHeight,
    titleFontSizeKey: titleFontSize,
    bodyFontSizeKey: bodyFontSize,
    colorSchemePickerItemSizeKey: colorSchemePickerItemSize,
    mainCardSizeKey: mainCardSize,
    mainCardIconSizeKey: mainCardIconSize,
    reminderIconSizeKey: reminderIconSize,
  };
}
