import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../design/screens/notification.dart';
import '../models/task.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {}
        selectNotificationSubject.add(payload!);
      },
    );
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTenAM(hour, minutes, task),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, Task task) {
    var date = DateFormat.yMd().parse(task.date!);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduleNow = tz.TZDateTime.from(date, tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, scheduleNow.year,
        scheduleNow.month, scheduleNow.day, hour, minutes);
    scheduledDate = subtractRemind(task, scheduledDate);
    if (scheduledDate.isBefore(now)) {
      if (task.repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(
            tz.local, date.year, date.month, date.day + 1, hour, minutes);
      } else if (task.repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(
            tz.local, date.year, date.month, date.day + 7, hour, minutes);
      } else if (task.repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(
            tz.local, date.year, date.month + 1, date.day, hour, minutes);
      } else if (task.repeat == 'Yearly') {
        scheduledDate = tz.TZDateTime(
            tz.local, date.year + 1, date.month, date.day, hour, minutes);
      }
      scheduledDate = subtractRemind(task, scheduledDate);
    }
    print(scheduledDate);
    return scheduledDate;
  }

  tz.TZDateTime subtractRemind(Task task, tz.TZDateTime scheduledDate) {
    if (task.remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    } else if (task.remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    } else if (task.remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    } else if (task.remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    } else if (task.remind == 25) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 25));
    } else if (task.remind == 30) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 30));
    }
    return scheduledDate;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => NotificationScreen(
            payLoad: payload,
          ));
    });
  }
}
