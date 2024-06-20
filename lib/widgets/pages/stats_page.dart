import 'package:flutter/material.dart';

import '../../../widgets/common/responsive_layout.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../models/ruku.dart';
import '../common/focus_highlight.dart';
import '../common/percentage_bar.dart';
import '../completion_stats.dart';
import '../daily_stats_bar_chart.dart';
import '../reader_aware_builder.dart';
import '../settings_aware_builder.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({
    super.key,
  });


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
          centerTitle: true,
          backgroundColor: scheme.page.defaultButton.background,
          foregroundColor: scheme.page.defaultButton.text,
          title: Text(
            context.localizations.translate("page_statistics_title"),
            style: TextStyle(
              fontSize: titleFontSize,
            ),
          ),
          leading: Semantics(
            label: context.localizations.translate("app_cmd_goback"),
            button: true,
            excludeSemantics: true,
            child: FocusHighlight(
              focusColor: scheme.page.text.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: scheme.page.text,
              ),
            ),
          ),
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
                padding: const EdgeInsets.all(5.0),
                child: _buildPage(context, settings),
              )
            ),
          ),
        )
      )
    );
  }

  SingleChildScrollView _buildPage(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme.page;
    final layout = context.layout;

    return SingleChildScrollView(
      child: ReaderListenerBuilder(

        builder: (context, stateProvider) {

          final stats = stateProvider.value.statistics;
          var totaldays = stats.intervalEnd.difference(stats.intervalStart).inDays;
          if (totaldays < 1) {
            totaldays = 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 10),

              MergeSemantics(
                child: Column(
                  children: [

                    FocusHighlight(
                      canRequestFocus: true,
                      focusColor: Colors.transparent,
                      alignment: AlignmentDirectional.center,
                      child: Semantics(
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: context.localizations.translate("page_statistics_current"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ReaderListenerBuilder(
                      builder: (context, readerStateNotifier) {

                        final readerState = readerStateNotifier.value;
                        final percentageComplete = readerState.rukuNumber.toDouble()/Ruku.lastRukuIndex.toDouble();

                        return Semantics(
                          label: context.localizations.translate(
                            "page_statistics_semantic_progress",
                            placeholders: {
                              "rukuNumber": readerState.rukuNumber,
                              "lastRukuIndex": Ruku.lastRukuIndex,
                              "percent": "${(percentageComplete * 100).toStringAsFixed(1)}%",
                            }
                          ),
                          excludeSemantics: true,
                          child: PercentageBar(
                            direction: TextDirection.rtl,
                            height: 25,
                            value: percentageComplete,
                            foregroundColor: scheme.defaultButton.text,
                            backgroundColor: scheme.defaultButton.background,
                          ),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              FocusHighlight(
                canRequestFocus: true,
                focusColor: Colors.transparent,
                child: Semantics(
                  container: true,
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.localizations.translate("page_statistics_intro"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CompletionStats(statistics: stats),

              if (stats.dailyStats.isNotEmpty)
              ...[
                const SizedBox(height: 10),
                Semantics(
                  container: true,
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.localizations.translate(
                            "page_statistics_intro2",
                            placeholders: {"maxDailyStatsDays": Constants.maxDailyStatsDays}
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ExcludeSemantics(
                  child: FocusHighlight(
                    canRequestFocus: true,
                    focusColor: settings.currentScheme.page.text.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DailyStatsBarChart(dailyStats: stats.dailyStats, colorScheme: settings.currentScheme),
                    ),
                  ),
                )
              ],

              const SizedBox(height: 10),
          ]);
        },
      ),
    );
  }
}
