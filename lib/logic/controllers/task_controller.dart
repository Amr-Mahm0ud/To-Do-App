import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  List<Task> tasksList = [
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 0,
        startTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 5)))
            .toString(),
        endTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 30)))
            .toString(),
        color: 2),
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 1,
        startTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 10)))
            .toString(),
        endTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 35)))
            .toString(),
        color: 0),
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 0,
        startTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 15)))
            .toString(),
        endTime: DateFormat('hh:mm a')
            .format(DateTime.now().add(const Duration(minutes: 40)))
            .toString(),
        color: 1),
  ];
  getTasks() {}
}
