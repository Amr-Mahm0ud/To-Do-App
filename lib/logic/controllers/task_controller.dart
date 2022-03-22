import 'package:get/state_manager.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  RxList<Task> tasksList = <Task>[].obs;

  Future<int> addTask(Task task) {
    return DBHelper.insert(task);
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void completeTask(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  Future<void> getTasks() async {
    final List tasks = await DBHelper.query();
    tasksList.assignAll(
      tasks
          .map(
            (json) => Task.fromJson(json),
          )
          .toList(),
    );
  }
}
