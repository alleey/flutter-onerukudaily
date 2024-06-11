import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../../services/app_data_service.dart';
import '../common/percentage_bar.dart';
import '../common/responsive_layout.dart';
import '../settings_aware_builder.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: settingsNotifier,
          builder: (context, settings, child) =>  _buildContents(context, settings)
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(Constants.appTitle),
        backgroundColor: scheme.page.background,
        foregroundColor: scheme.page.text,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: scheme.page.background,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: scheme.page.text,
            fontSize: bodyFontSize,
          ),
          child: _buildGrid(context, settings)
        )
      )
    );
  }

  Widget _buildGrid(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme.page.defaultButton;
    final currentRuku = AppDataService().currentRukuIndex - 1;

    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        _buildCard(
          context,
          settings,
          title: 'Read Ruku',
          icon: Icons.book,
          onTap: () => Navigator.pushNamed(context, KnownRouteNames.readruku),
          isDefault: true,
          extra: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
            child: PercentageBar(
              height: 20,
              value: currentRuku.toDouble() / Ruku.lastRukuIndex.toDouble(),
              foregroundColor: scheme.background,
              backgroundColor: scheme.foreground,
              onGenerateLabel: (value) => "$currentRuku/${Ruku.lastRukuIndex}",
            ),
          )
        ),
        _buildCard(
          context,
          settings,
          title: 'Reminders',
          icon: Icons.schedule,
          onTap: () => Navigator.pushNamed(context, KnownRouteNames.reminders),
        ),
        _buildCard(
          context,
          settings,
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => Navigator.pushNamed(context, KnownRouteNames.settings),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, AppSettings settings,  {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDefault = false,
    Widget? extra,
  }) {

    final scheme = settings.currentScheme.page;
    final button = isDefault ? scheme.defaultButton:scheme.button;

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
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: button.icon,
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
                        style: TextStyle(
                          color: button.foreground,
                          fontSize: fontSize
                        ),
                      ),
                      if (extra != null)
                        extra,
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
