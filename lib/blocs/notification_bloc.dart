
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/reminder_list.dart';
import '../services/app_data_service.dart';
import '../services/notification_service.dart';
import '../services/prompt_serivce.dart';
import '../services/time_service.dart';

////////////////////////////////////////////

abstract class NotificationBlocEvent {}

class InitializeNotificationsEvent extends NotificationBlocEvent {}

class LoadRemindersEvent extends NotificationBlocEvent {}

class AddReminderEvent extends NotificationBlocEvent {
  final TimeOfDay reminder;
  AddReminderEvent(this.reminder);
}

class RemoveReminderEvent extends NotificationBlocEvent {
  final TimeOfDay schedule;
  RemoveReminderEvent(this.schedule);
}

class ScheduleNotifications extends NotificationBlocEvent {
  final bool reschduleForTomorrow;
  final PromptSerivce promptSerivce;

  ScheduleNotifications(this.promptSerivce, { this.reschduleForTomorrow = false });
}

////////////////////////////////////////////

class NotificationBlocState {}

class NotificationInitializedState extends NotificationBlocState {
  final AppLaunchInfo appLaunchInfo;
  final bool platformSupportsNotifications;
  NotificationInitializedState({required this.appLaunchInfo, required this.platformSupportsNotifications});
}

class RemindersLoadedState extends NotificationBlocState {
  final List<TimeOfDay> reminders;
  final bool dirty;
  RemindersLoadedState(this.reminders, { required this.dirty });
}

class NotificationsSchduledState extends NotificationBlocState {
}

////////////////////////////////////////////

class NotificationBloc extends Bloc<NotificationBlocEvent, NotificationBlocState>
{
  static const String settingSchedules = "schedules";

  final appDataService = AppDataService();
  final notificationService = NotificationService();
  final timeService = TimeService();
  final reminders = RemindersList();

  NotificationBloc() : super(NotificationBlocState())
  {
    on<InitializeNotificationsEvent>(_onInitialize);
    on<LoadRemindersEvent>(_onLoadSchedules);
    on<AddReminderEvent>(_onAddSchedule);
    on<RemoveReminderEvent>(_onRemoveSchedule);
    on<ScheduleNotifications>(_onScheduleNotifications);
  }

  void _onInitialize(InitializeNotificationsEvent event, Emitter<NotificationBlocState> emit) async {

    await notificationService.initialize();
    if (notificationService.platformHasSupport) {
      await timeService.initialize();
    }
    emit(NotificationInitializedState(
      appLaunchInfo: notificationService.appLaunchInfo,
      platformSupportsNotifications: notificationService.platformHasSupport,
    ));
  }

  void _onLoadSchedules(LoadRemindersEvent event, Emitter<NotificationBlocState> emit) {
    final loaded = appDataService.get(settingSchedules, "[]");
    reminders.clear();
    reminders.copyAll(RemindersList.fromJson(loaded));
    emit(RemindersLoadedState(reminders.list, dirty: false));
  }

  void _onAddSchedule(AddReminderEvent event, Emitter<NotificationBlocState> emit) {

    final copy = reminders.copyWith();
    reminders.add(event.reminder);
    appDataService.put(settingSchedules, reminders.toJson());

    emit(RemindersLoadedState(reminders.list, dirty: reminders.compareTo(copy) != 0));
  }

  void _onRemoveSchedule(RemoveReminderEvent event, Emitter<NotificationBlocState> emit) {

    final copy = reminders.copyWith();
    reminders.remove(event.schedule);
    appDataService.put(settingSchedules, reminders.toJson());

    emit(RemindersLoadedState(reminders.list, dirty: reminders.compareTo(copy) != 0));
  }

  void _onScheduleNotifications(ScheduleNotifications event, Emitter<NotificationBlocState> emit) async {

    notificationService.cancelAllNotifications();
    reminders.list.forEachIndexed((index, timeOfDay) {

      final when = timeService.nextInstanceOfTime(timeOfDay, tomorrow: event.reschduleForTomorrow);
      final prompt = event.promptSerivce.reminderPrompt(index: index, totatReminders: reminders.list.length);
      //final when = timeService.timeAfter(Duration(seconds: 5 * index));

      notificationService.scheduleNotification(id: index, prompt: prompt, scheduledDate: when);

      log("notification: scheduled to fire on $when");
    });

    for (var item in (await notificationService.pendingdNotifications())) {
      log("notification: pending ${item.id}, ${item.title}");
    }

    emit(NotificationsSchduledState());
  }
}

extension NotificationBlocContextExtensions on BuildContext {
  NotificationBloc get notificationBloc => BlocProvider.of<NotificationBloc>(this);
}
