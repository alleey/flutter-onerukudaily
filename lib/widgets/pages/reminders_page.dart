import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notification_bloc.dart';
import '../../blocs/settings_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../common/time_of_day_extensions.dart';
import '../../localizations/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../services/alerts_service.dart';
import '../../services/prompt_serivce.dart';
import '../../utils/utils.dart';
import '../common/focus_highlight.dart';
import '../common/responsive_layout.dart';
import '../dialogs/app_dialog.dart';
import '../loading_indicator.dart';
import '../settings_aware_builder.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {

  final _alertService = AlertsService();
  List<TimeOfDay>? _reminders;

  @override
  void initState() {
    super.initState();
    context.notificationBloc.add(LoadRemindersEvent());
  }

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
          title: Text(
            context.localizations.translate("page_reminders_title"),
            style: TextStyle(
              fontSize: titleFontSize,
            ),
          ),
          backgroundColor: scheme.page.defaultButton.background,
          foregroundColor: scheme.page.defaultButton.text,
          leading: FocusHighlight(
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
                child: _buildBody(context, settings),
              )
            ),
          ),
        )
      )
    );
  }

  Widget _buildBody(BuildContext context, AppSettings settings) {

    final scheme = settings.currentScheme;
    final layout = context.layout;
    final bodyFontSize = layout.get<double>(AppLayoutConstants.bodyFontSizeKey);

    return BlocListener<NotificationBloc, NotificationBlocState>(

        listener: (context, state) {

          if (state is RemindersLoadedState) {

            setState(() {
              _reminders = state.reminders;
            });

            // reminders changed, lets reschedule
            if (state.dirty) {
              context.notificationBloc.add(ScheduleNotifications(
                PromptSerivce(localizations: context.localizations)
              ));
            }
          }
        },
        child: Builder(builder: (context) {

          if (_reminders == null) {
            return const Center(child: LoadingIndicator());
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: scheme.page.background,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: scheme.page.text,
                fontSize: bodyFontSize,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _reminders!.isNotEmpty ?
                  _buildRemindersList(context, settings):
                  _buildNoReminders(context, settings),
              )
            )
          );

        }
      ),
    );
  }

  Widget _buildNoReminders(BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme.page.button;
    return Column(
      children: [
        Text(
          context.localizations.translate("page_reminders_noreminders", placeholders: {"maxReminders": Constants.maxReminders}),
          style: TextStyle(
            color: scheme.text
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildAddReminderButton(context, settings),
        ),
      ],
    );
  }

  Widget _buildRemindersList(BuildContext context, AppSettings settings) {

    final layout = context.layout;
    final iconSize = layout.get<double>(AppLayoutConstants.reminderIconSizeKey);
    final scheme = settings.currentScheme.page;

    return Column(
      children: [
        Text(
          context.localizations.translate("page_reminders_remindersintro"),
          style: TextStyle(
            color: scheme.text
          ),
        ),
        Expanded(
          child: ListView.builder(

            itemCount: _reminders!.length,
            itemBuilder: (context, index) {
              final schedule = _reminders![index];

              return ListTile(
                title: Text(schedule.toAmPmFormat()),
                subtitle: Text(schedule.to24HourFormat()),
                leading: Icon(
                  Icons.alarm,
                  size: iconSize,
                  color: scheme.defaultButton.background,
                ),
                trailing: FocusHighlight(
                  focusColor: scheme.defaultButton.text.withOpacity(0.5),
                  child: IconButton(
                    color: scheme.defaultButton.text,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.notificationBloc.add(RemoveReminderEvent(schedule));
                    },
                  ),
                ),
                textColor: scheme.text,
                tileColor: scheme.defaultButton.background,
                iconColor: scheme.defaultButton.icon,
              );
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                alignment: AlignmentDirectional.centerStart,
                fit: BoxFit.scaleDown,
                child: Text(
                  context.localizations.translate("page_reminders_multipleperday"),
                ),
              ),
            ),
            FocusHighlight(
              focusColor: scheme.text.withOpacity(0.5),
              child: Switch(
                activeColor: scheme.defaultButton.background,
                value: settings.allowMultipleReminders,
                onChanged: (value) {
                  context.settingsBloc.save(settings: settings.copyWith(allowMultipleReminders: value));
                }
              ),
            )
          ]
        ),

        if (_reminders!.length < Constants.maxReminders)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildAddReminderButton(context, settings),
          ),
        if (_reminders!.length >= Constants.maxReminders)
          Text(
            context.localizations.translate("page_reminders_limitreached"),
            style: TextStyle(
              color: scheme.defaultButton.text
            ),
          ),
      ],
    );
  }

  Widget _buildAddReminderButton(BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme.page;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FocusHighlight(
          focusColor: scheme.text.withOpacity(0.5),
          child: ButtonDialogAction(
            isDefault: true,
            autofocus: true,
            onAction: (close) async {
              final picked = await _alertService.timePicker(context,
                initialTime: TimeOfDay.now(),
                selectedTimes: _reminders!
              );
              if (picked != null) {
                _handleTimeSelection(settings, picked);
              }
            },
            builder: (_,__) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_alarm),
                  const SizedBox(width: 5),
                  Text(context.localizations.translate("page_reminders_add")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleTimeSelection(AppSettings settings, TimeOfDay selectedTime) {

    final selectedTimes = _reminders!;
    if (selectedTimes.contains(selectedTime)) {

      final scheme = settings.currentScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: scheme.page.text,
          content: Text(
            "A reminder for ${formatTime(selectedTime)}/${formatTime24Hour(selectedTime)} is already set!",
            style: TextStyle(
              color: scheme.page.background
            ),
          )
        ),
      );
      return;
    }

    context.notificationBloc.add(AddReminderEvent(selectedTime));
  }
}
