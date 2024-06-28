import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/common/responsive_layout.dart';
import '../../common/layout_constants.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../services/data_service.dart';
import '../common/focus_highlight.dart';
import '../dialogs/app_dialog.dart';
import '../localized_text.dart';
import '../settings_aware_builder.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
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
            context.localizations.translate("page_about_title"),
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
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);
    final metadata = DataService().metaData;

    return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Align(
          alignment: AlignmentDirectional.center,
          child: Semantics(
            label: "Application version is ${metadata.version}",
            container: true,
            excludeSemantics: true,
            child: FocusHighlight(
              canRequestFocus: true,
              autofocus: true,
              focusColor: scheme.background.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  textScaler: const TextScaler.linear(0.95),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.localizations.translate("page_about_version", placeholders: {"version": metadata.version}),
                        style: TextStyle(
                          fontSize: bodyFontSize,
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 2),

        Semantics(
          container: true,
          child: Text.rich(
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(.95),
            TextSpan(
              children: [
                TextSpan(
                  text: context.localizations.translate("page_about_intro"),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        Semantics(
          container: true,
          child: Container(
            color: scheme.defaultButton.background.withOpacity(0.7),
            padding: const EdgeInsets.all(10),
            child: Text.rich(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.defaultButton.text
              ),
              TextSpan(
                children: [
                  TextSpan(
                    text: context.localizations.translate("page_about_hadith"),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),
        Semantics(
          container: true,
          child: Text.rich(
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(.95),
            TextSpan(
              children: [
                TextSpan(
                  text: context.localizations.translate("page_about_intro2"),
                ),
              ],
            ),
          ),
        ),


        const SizedBox(height: 2),
        Semantics(
          button: true,
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: FocusHighlight(
                  focusColor: scheme.text.withOpacity(0.5),
                  child: ButtonDialogAction(
                    isDefault: true,
                    onAction: (close) async {
                      final link = Uri.tryParse(metadata.linkFeedback);
                      if (link != null) {
                        await launchUrl(link, mode: LaunchMode.inAppBrowserView);
                      }
                    },
                    builder: (_,__) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rate_review),
                          LocalizedText(textId: "page_about_feedback"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),
        Semantics(
          container: true,
          child: Text.rich(
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(.95),
            TextSpan(
              children: [
                TextSpan(
                  text: context.localizations.translate("page_about_intro3"),
                ),
              ],
            ),
          ),
        ),

    ]),
  );
  }
}
