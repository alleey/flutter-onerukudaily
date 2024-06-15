import 'dart:math';

import '../localizations/app_localizations.dart';
import '../models/prompts.dart';

class PromptSerivce {

  PromptSerivce({required AppLocalizations localizations}) : _localizations = localizations;

  final AppLocalizations _localizations;
  final _random = Random();

  HtmlPrompt reminderPrompt({ required int index, required int totatReminders}) {

    final header = switch (index) {
      0 => _localizations.translate("app_prompt_header_first"),
      _ when index == totatReminders - 1 => _localizations.translate("app_prompt_header_last"),
      _ => _localizations.translate("app_prompt_header_default"),
    };

    final randomid = 1 + _random.nextInt(10);
    final prompt = _localizations.translate("app_prompt_$randomid");
    final title = _localizations.translate("app_title");

    return HtmlPrompt(
      title: "<b>$header</b>",
      body: prompt,
      fallback: SimplePrompt(header: header, body: prompt)
    );
  }
}
