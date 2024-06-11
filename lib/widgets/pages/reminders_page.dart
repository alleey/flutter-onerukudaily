import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notification_bloc.dart';
import '../../common/constants.dart';
import '../../common/layout_constants.dart';
import '../../common/time_of_day_extensions.dart';
import '../../models/app_settings.dart';
import '../../services/alerts_service.dart';
import '../../utils/utils.dart';
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

  final alertService = AlertsService();

  @override
  void initState() {
    super.initState();
    context.notificationBloc.add(LoadRemindersEvent());
  }

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
        title: const Text('Reminders'),
        backgroundColor: scheme.page.background,
        foregroundColor: scheme.page.text,
      ),
      body: BlocBuilder<NotificationBloc, NotificationBlocState>(

          builder: (context, state) {

            if (state is RemindersLoadedState) {

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
                    child: state.isNotEmpty ?
                      _buildRemindersList(state, context, settings):
                      _buildNoReminders(state, context, settings),
                  )
                )
              );
            }

            return const Center(child: LoadingIndicator());
          },
      )
    );
  }

  Widget _buildNoReminders(RemindersLoadedState state, BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme.page.button;
    return Column(
      children: [
        Text(
          "Use the Add reminder button to set up to ${Constants.maxReminders} daily reminders.",
          style: TextStyle(
            color: scheme.foreground
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildAddReminderButton(context, settings, state),
        ),
      ],
    );
  }

  Widget _buildRemindersList(RemindersLoadedState state, BuildContext context, AppSettings settings) {

    final layout = context.layout;
    final iconSize = layout.get<double>(AppLayoutConstants.reminderIconSizeKey);
    final scheme = settings.currentScheme.page.button;

    return Column(
      children: [
        Text(
          "You'll receive a daily reminder to read a Ruku at the following times.",
          style: TextStyle(
            color: scheme.foreground
          ),
        ),
        Expanded(
          child: ListView.builder(

            itemCount: state.reminders.length,
            itemBuilder: (context, index) {
              final schedule = state.reminders[index];

              return ListTile(
                title: Text(schedule.toAmPmFormat()),
                subtitle: Text(schedule.to24HourFormat()),
                leading: Icon(Icons.alarm, size: iconSize),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.notificationBloc.add(RemoveReminderEvent(schedule));
                  },
                ),
                textColor: scheme.foreground,
                tileColor: scheme.background,
                iconColor: scheme.icon,
              );
            },
          ),
        ),
        if (state.reminders.length < Constants.maxReminders)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildAddReminderButton(context, settings, state),
          ),
        if (state.reminders.length >= Constants.maxReminders)
          Text(
            "Reminder limit reached",
            style: TextStyle(
              color: scheme.foreground
            ),
          ),
      ],
    );
  }

  Widget _buildAddReminderButton(BuildContext context, AppSettings settings, RemindersLoadedState state) {
    return ButtonDialogAction(
      isDefault: true,
      onAction: (close) async {
        final picked = await alertService.timePicker(context,
          initialTime: TimeOfDay.now(),
          selectedTimes: state.reminders
        );
        if (picked != null) {
          _handleTimeSelection(settings, picked, state.reminders);
        }
      },
      builder: (_,__) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_alarm),
            SizedBox(width: 5),
            Text("Add Reminder"),
          ],
        ),
      ),
    );
  }

  void _handleTimeSelection(AppSettings settings, TimeOfDay selectedTime, List<TimeOfDay> selectedTimes) {

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
