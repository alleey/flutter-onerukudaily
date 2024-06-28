import 'package:flutter/material.dart';

import '../common/layout_constants.dart';
import '../models/app_settings.dart';
import 'common/responsive_layout.dart';
import 'settings_aware_builder.dart';

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({
    super.key,
    String message = "loading . . .",
    TextDirection direction = TextDirection.ltr,
  }) : _direction = direction, _message = message;

  final String _message;
  final TextDirection _direction;

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
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
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    final scheme = settings.currentScheme;

    return Directionality(
      textDirection: _direction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            _message,
            style: TextStyle(
              color: scheme.page.text,
              fontSize: titleFontSize,
            ),
          ),
          const SizedBox(height: 16), // Spacer
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: LinearProgressIndicator(
              color: scheme.page.text,
              backgroundColor: scheme.page.background,
            ),
          )
        ],
      ),
    );
  }
}
