import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../../services/notification_service.dart';
import '../common/percentage_bar.dart';
import '../common/responsive_layout.dart';
import '../reader_aware_builder.dart';
import '../settings_aware_builder.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
          valueListenable: settingsNotifier,
          builder: (context, settings, child) =>
              _buildContents(context, settings)),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final screenCoverPct = context.layout.get<Size>(AppLayoutConstants.screenCoverPctKey);
    final appBarHeight = layout.get<double>(AppLayoutConstants.appbarHeightKey);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            context.localizations.translate("app_title"),
            style: TextStyle(
              fontSize: titleFontSize,
            ),
          ),
          backgroundColor: scheme.page.defaultButton.background,
          foregroundColor: scheme.page.defaultButton.text,
        ),
      ),
      body: Container(
        color: scheme.page.background,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * screenCoverPct.width,
            height: MediaQuery.of(context).size.height * screenCoverPct.height,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: scheme.page.text,
                fontSize: bodyFontSize,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: _buildBody(context, settings),
              )
            ),
          ),
        )
      )
    );
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {

    final pageScheme = settings.currentScheme.page;
    final notificationSupport = NotificationService().platformHasSupport;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[

                // Read Ruku Card
                ReaderListenerBuilder(
                  builder: (context, stateProvider) {
                    return _buildCard(context, settings,
                      title: context.localizations.translate("page_reader_title"),
                      icon: Icons.book,
                      onTap: () => Navigator.pushNamed(context, KnownRouteNames.readruku),
                      isDefault: true,
                      extra: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),

                        // Respond to Reader block changes
                        child: ValueListenableBuilder(
                          valueListenable: stateProvider,
                          builder: (context, readerState, child) => PercentageBar(
                            direction: TextDirection.rtl,
                            height: 20,
                            value: readerState.rukuNumber.toDouble()/Ruku.lastRukuIndex.toDouble(),
                            foregroundColor: pageScheme.text,
                            backgroundColor: pageScheme.background,
                            onGenerateLabel: (value) => "${readerState.rukuNumber}/${Ruku.lastRukuIndex}",
                          ),
                        ),
                      )
                    );
                  },
                ),

                // Reminders Card
                if (notificationSupport)
                  _buildCard(
                    context,
                    settings,
                    title: context.localizations.translate("page_reminders_title"),
                    icon: Icons.schedule,
                    onTap: () => Navigator.pushNamed(context, KnownRouteNames.reminders),
                  ),

                // Settings Card
                _buildCard(
                  context,
                  settings,
                  title: context.localizations.translate("page_settings_title"),
                  icon: Icons.settings,
                  onTap: () => Navigator.pushNamed(context, KnownRouteNames.settings),
                ),

                // Settings Card
                _buildCard(
                  context,
                  settings,
                  title: context.localizations.translate("page_statistics_title"),
                  icon: Icons.rate_review,
                  onTap: () => Navigator.pushNamed(context, KnownRouteNames.statistics),
                ),

                _buildCard(
                  context,
                  settings,
                  title: context.localizations.translate("page_about_title"),
                  icon: Icons.info,
                  onTap: () => Navigator.pushNamed(context, KnownRouteNames.about),
                ),
              ],
            ),
          ),
        ),
        Text.rich(
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(.9),
          TextSpan(
            children: [
              TextSpan(
                text: context.localizations.translate("page_main_intro"),
                style: TextStyle(
                  color: pageScheme.text,
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    AppSettings settings, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDefault = false,
    Widget? extra,
  }) {

    final scheme = settings.currentScheme.page;
    final button = isDefault ? scheme.defaultButton : scheme.button;

    final layout = context.layout;
    final cardSize = layout.get<Size>(AppLayoutConstants.mainCardSizeKey);
    final iconSize = layout.get<double>(AppLayoutConstants.mainCardIconSizeKey);
    final fontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return SizedBox(
      width: cardSize.width,
      height: cardSize.height,
      child: Card(
        color: button.background,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(icon, size: iconSize, color: button.icon,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: button.text, fontSize: fontSize),
                      ),
                      if (extra != null) extra,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
