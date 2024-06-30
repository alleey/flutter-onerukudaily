import 'package:flutter/material.dart';

import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/statistics.dart';
import '../common/pulse_bounce_effect.dart';
import '../common/responsive_layout.dart';
import '../completion_stats.dart';
import '../settings_aware_builder.dart';

class CompletionDialog extends StatelessWidget {

  const CompletionDialog({super.key, required this.statistics});

  final Statistics statistics;

  @override
  Widget build(BuildContext context) {
    return  SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  _buildContents(context, settings)
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme.dialog;
    final layout = context.layout;
    final titleFontSize = layout.get<double>(AppLayoutConstants.titleFontSizeKey);
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: PulseBounceEffect(
                    child: Icon(
                      Icons.workspace_premium,
                      size: constraints.maxHeight,
                      color: scheme.button.text,
                    ),
                  ),
                );
              },
            ),
          ),
          CompletionStats(statistics: statistics),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Semantics(
                container: true,
                child: Column(
                  children: [
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: context.localizations.translate('dlg_completion_intro'),
                            style: TextStyle(
                              color: scheme.text,
                              fontSize: bodyFontSize,
                            )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: context.localizations.translate('dlg_completion_intro2'),
                            style: TextStyle(
                              color: scheme.text,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: context.localizations.translate('dlg_completion_intro3'),
                            style: TextStyle(
                              color: scheme.text,
                              fontSize: bodyFontSize,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
