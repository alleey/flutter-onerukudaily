import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../localizations/app_localizations.dart';
import '../common/layout_constants.dart';
import '../models/app_settings.dart';
import '../models/statistics.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/custom_time_picker.dart';
import '../widgets/dialogs/app_dialog.dart';
import '../widgets/dialogs/common.dart';
import '../widgets/dialogs/completion_dialog.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/ruku_picker.dart';

class AlertsService {

  Future<T?> actionDialog<T>(
    BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    required ActionBuilder actions,
    double? width,
    double? height,
  }) {
    final screenCoverPct = ResponsiveLayoutProvider.layout(context).get<Size>(DialogLayoutConstants.screenCoverPctKey);
    return showGeneralDialog<T>(
      context: context,
        barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppDialog(
          title: title,
          actions: actions,
          contents: contents,
          width: width ?? MediaQuery.of(context).size.width * screenCoverPct.width,
          height: height ?? MediaQuery.of(context).size.height * screenCoverPct.height,
        );
      }
    );
  }

  Future<bool?> yesNoDialog(BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    String yesLabelId = "dlg_cmd_yes",
    String noLabelId = "dlg_cmd_no",
    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    return actionDialog(
      context,
      title: title,
      contents: contents,
      actions: (_,__) => [
        Expanded(
          child: ButtonDialogAction(
            onAction: (close) {
              close(null);
              onAccept?.call();
            },
            builder: (_,__) {
              return Text(
                context.localizations.translate(yesLabelId),
                textAlign: TextAlign.center
              );
            }
          ),
        ),
        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            onAction: (close) {
              close(null);
              onReject?.call();
            },
            builder: (_,__) {
              return Text(
                context.localizations.translate(noLabelId),
                textAlign: TextAlign.center
              );
            }
          ),
        )
      ],
    );
  }

  Future<dynamic> okDialog(BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    String okLabelId = "dlg_cmd_ok",
    VoidCallback? callback
  }) {
    return actionDialog(
      context,
      title: title,
      contents: contents,
      actions: (_,__) => [
        Expanded(
          child: ButtonDialogAction(
          isDefault: true,
            onAction: (close) {
              close(null);
              callback?.call();
            },
            builder: (_,__) {
              return Text(
                context.localizations.translate(okLabelId),
                textAlign: TextAlign.center
              );
            }
        ),
        )
      ],
    );
  }

  VoidCallback popupDialog(BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
  }) {
    actionDialog(
      context,
      title: title,
      contents: contents,
      actions: (_,__) => []
    );
    return () => Navigator.of(context, rootNavigator: true).pop();
  }

  // Returns a function that can be used to dismiss the popup.
  //
  VoidCallback popup(BuildContext context, { required String title, required String message }) {
    return popupDialog(
      context,
      title: (context, settingsProvider) {
        return DefaultDialogTitle(
          builder: (context, settingsProvider) {
            final scheme = settingsProvider.value.currentScheme;
            return Text(
              title,
              style: TextStyle(
                color: scheme.dialog.textHighlight,
                fontWeight: FontWeight.bold,
                fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey),
              ),
            );
          },
        );
      },
      contents: (context, settingsProvider) {
        return Semantics(
          container: true,
          child: Center(
            child: LoadingIndicator(
              message: message,
            ),
          ),
        );
      },
    );
  }


  Future<bool?> confirmSetRuku(BuildContext context, {
    required int rukuId
  }) {

    return actionDialog<bool>(
      context,
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .5,
      title: (_,__) => DefaultDialogTitle(
        builder: (context, settingsProvider) => Text(
          context.localizations.translate("dlg_setdaily_title"),
          style: TextStyle(
            fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey)
          ),
        )
      ),
      actions: (_,__) => [
        Expanded(
          child: ButtonDialogAction(
            onAction: (close) {
              close(true);
            },
            builder: (_,__) {
              return Text(
                context.localizations.translate("dlg_cmd_yes"),
                textAlign: TextAlign.center
              );
            }
          ),
        ),
        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            onAction: (close) {
              close(false);
            },
            builder: (_,__) {
              return Text(
                context.localizations.translate("dlg_cmd_no"),
                textAlign: TextAlign.center
              );
            }
          ),
        )
      ],
      contents: (_,__) =>  Semantics(
        container: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              context.localizations.translate("dlg_setdaily_intro", placeholders: { "rukuId": rukuId }),
            ),
          ),
        ),
      )
    );
  }

  Future<dynamic> completionDialog(BuildContext context, {
    required Statistics statistics,
    required VoidCallback onClose
  }) {

    return actionDialog(
      context,
      title: (_,__) => DefaultDialogTitle(
        builder: (context, settingsProvider) => Text(
          context.localizations.translate("dlg_completion_title"),
          style: TextStyle(
            fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey)
          ),
        )
      ),
      actions: (_,__) => [

        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            builder: (_,__) => Text(context.localizations.translate("dlg_completion_ok"), textAlign: TextAlign.center),
            onAction: (close) {
              close(null);
              onClose();
            },
          ),
        ),

      ],
      contents: (_,__) =>  CompletionDialog(statistics: statistics)
    );
  }

  Future<int?> rukuPicker(BuildContext context, {
    int? sura,
    int? ruku,
  }) {

    var selectedSura = sura;
    var selectedRuku = ruku;

    return actionDialog<int>(
      context,
      width: MediaQuery.of(context).size.width * .7,
      height: MediaQuery.of(context).size.height * .7,
      title: (_, settingsProvider) => DefaultDialogTitle(
        builder: (context, settingsProvider) => Text(
          context.localizations.translate("dlg_pickruku_title"),
          style: TextStyle(
            fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey)
          ),
        )
      ),
      contents: (_,__) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RukuPickerDialog(
          selectedSura: selectedSura,
          selectedRuku: selectedRuku,
          onSelect: (value) {
            selectedRuku = value;

          }
        ),
      ),
      actions: (_,__) => [

        Expanded(
          child: ButtonDialogAction(
            isDefault: false,
            builder: (_,__) => Text(context.localizations.translate("dlg_pickruku_ok"), textAlign: TextAlign.center),
            onAction: (close) {
              close(selectedRuku!);
            },
          ),
        ),

        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            builder: (_,__) => Text(context.localizations.translate("dlg_pickruku_cancel"), textAlign: TextAlign.center),
            onAction: (close) => close(null),
          ),
        ),

      ],
    );
  }

  Future<TimeOfDay?> timePicker(BuildContext context, {
    required TimeOfDay initialTime,
    required List<TimeOfDay> selectedTimes,
  }) {

    TimeOfDay? selectedTime;
    return actionDialog<TimeOfDay>(
      context,
      title: (_, settingsProvider) => DefaultDialogTitle(
        builder: (context, settingsProvider) => Text(
          context.localizations.translate("dlg_picktime_title"),
          style: TextStyle(
            fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey)
          ),
        )
      ),
      contents: (_,__) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTimePickerDialog(
          initialTime: initialTime,
          selectedTimes: selectedTimes,
          onSelect: (time) {
            selectedTime = time;
          }
        ),
      ),
      actions: (_,__) => [

        Expanded(
          child: ButtonDialogAction(
            isDefault: false,
            builder: (_,__) => Text(context.localizations.translate("dlg_picktime_ok"), textAlign: TextAlign.center),
            onAction: (close) {
              close(selectedTime);
            },
          ),
        ),

        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            builder: (_,__) => Text(context.localizations.translate("dlg_picktime_cancel"), textAlign: TextAlign.center),
            onAction: (close) => close(null),
          ),
        ),

      ],
    );
  }

  Future<Color?> colorPicker(BuildContext context, {
    required Color pickerColor,
  }) {

    Color? selected;
    return actionDialog<Color>(
      context,
      title: (_, settingsProvider) => DefaultDialogTitle(
        builder: (context, settingsProvider) => Text(
          context.localizations.translate("dlg_pickcolor_title"),
          style: TextStyle(
            fontSize: context.layout.get<double>(AppLayoutConstants.titleFontSizeKey)
          ),
        )
      ),
      contents: (_,settingsProvider) {

        final scheme = settingsProvider.value.currentScheme;
        return Theme(
          data: ThemeData(
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: scheme.dialog.text),
              bodyLarge: TextStyle(color: scheme.dialog.text),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialPicker(
              pickerColor: pickerColor,
              onColorChanged: (value) {
                selected = value;
              }
            ),
          ),
        );
      },
      actions: (_,__) => [

        Expanded(
          child: ButtonDialogAction(
            isDefault: false,
            builder: (_,__) => Text(context.localizations.translate("dlg_pickcolor_ok"), textAlign: TextAlign.center),
            onAction: (close) {
              close(selected);
            },
          ),
        ),

        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            builder: (_,__) => Text(context.localizations.translate("dlg_pickcolor_cancel"), textAlign: TextAlign.center),
            onAction: (close) => close(null),
          ),
        ),

      ],
    );
  }
}
