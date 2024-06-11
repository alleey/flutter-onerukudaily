import 'package:flutter/material.dart';

import '../common/layout_constants.dart';
import '../models/app_settings.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/custom_time_picker.dart';
import '../widgets/dialogs/app_dialog.dart';
import '../widgets/dialogs/common.dart';
import '../widgets/loading_indicator.dart';

class AlertsService {

  Future<T?> actionDialog<T>(
    BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    required ActionBuilder actions,
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
          width: MediaQuery.of(context).size.width * screenCoverPct.width,
          height: MediaQuery.of(context).size.height * screenCoverPct.height,
        );
      }
    );
  }

  Future<bool?> yesNoDialog(BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    String yesLabel = "Yes",
    String noLabel = "No",
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
              return Text(yesLabel, textAlign: TextAlign.center);
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
            builder: (_,__) => Text(noLabel, textAlign: TextAlign.center)
          ),
        )
      ],
    );
  }

  Future<dynamic> okDialog(BuildContext context, {
    required ContentBuilder title,
    required ContentBuilder contents,
    required ContentBuilder okLabel,
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
            builder: okLabel
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
  VoidCallback popup(BuildContext context, {
    required String title,
    required String message,
  }) {
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


  Future<TimeOfDay?> timePicker(BuildContext context, {
    required TimeOfDay initialTime,
    required List<TimeOfDay> selectedTimes,
  }) {


    TimeOfDay? selectedTime;
    return actionDialog<TimeOfDay>(
      context,
      title: (_, schemeNotifier) => DefaultDialogTitle(
        builder: (context, changeNotifier) => const Text("Set Reminder Time")
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
            builder: (_,__) => const Text("OK", textAlign: TextAlign.center),
            onAction: (close) {
              close(selectedTime);
            },
          ),
        ),

        Expanded(
          child: ButtonDialogAction(
            autofocus: true,
            isDefault: true,
            builder: (_,__) => const Text("Cancel", textAlign: TextAlign.center),
            onAction: (close) => close(null),
          ),
        ),

      ],
    );
  }
}
