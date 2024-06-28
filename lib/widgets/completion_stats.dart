import 'package:flutter/material.dart';

import '../common/layout_constants.dart';
import '../localizations/app_localizations.dart';
import '../models/app_settings.dart';
import '../models/statistics.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/settings_aware_builder.dart';

class CompletionStats extends StatelessWidget {

  const CompletionStats({
    super.key,
    required Statistics statistics,
  }) : _statistics = statistics;

  final Statistics _statistics;

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

    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final scheme = settings.currentScheme;

    return Semantics(
      container: true,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: bodyFontSize,
          color: scheme.dialog.background,
          fontWeight: FontWeight.bold,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.dialog.text,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
               child: Column(
                 children: [
                   FittedBox(
                     fit: BoxFit.scaleDown,
                     child: Text(
                       context.localizations.translate("dlg_completion_completions"),
                       textAlign: TextAlign.center,
                     ),
                   ),
                   Text(
                     "${_statistics.completions}",
                     textAlign: TextAlign.center,
                   ),
                 ],
               ),
              ),
              Container(color: Colors.black, width: 1, height: 60),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.localizations.translate("dlg_completion_reads"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      "${_statistics.reads}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
