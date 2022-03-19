import 'package:get/state_manager.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  List<Task> tasksList = [
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 0,
        startTime: '10:30',
        endTime: '11:00',
        color: 2),
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 1,
        startTime: '10:30',
        endTime: '11:00',
        color: 0),
    Task(
        title: 'Title',
        note:
            'note note note note note note note note note note note note note note note note note note note note note note note note note',
        isCompleted: 0,
        startTime: '10:30',
        endTime: '11:00',
        color: 1),
  ];
  getTasks() {}
}
