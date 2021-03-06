import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/design/widgets/button.dart';
import 'package:todo_app/logic/controllers/task_controller.dart';
import 'package:todo_app/logic/models/task.dart';
import '../widgets/input_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController taskController = Get.put(TaskController());
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  List<int> remindList = [5, 10, 15, 20, 25, 30];
  int selectedRemind = 5;
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  String selectedRepeat = 'None';
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: context.theme.iconTheme.color),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Add Task',
          style: TextStyle(color: context.theme.textTheme.headline6!.color),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // title
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: titleController,
              ),
              const SizedBox(height: 10),
              // note
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: noteController,
              ),
              const SizedBox(height: 10),
              // date
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_rounded),
                  onPressed: () => getDateFormUser(),
                ),
              ),
              const SizedBox(height: 10),
              // time
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: startTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_alarm),
                        onPressed: () => getTimeFromUser(isStart: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: endTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_alarm),
                        onPressed: () => getTimeFromUser(isStart: false),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // remind & repeat
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Remind',
                      hint: '$selectedRemind min',
                      widget: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DropdownButton<int>(
                          dropdownColor:
                              Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                          items: [
                            ...remindList.map(
                              (val) => DropdownMenuItem(
                                child: Text('$val mins'),
                                value: val,
                              ),
                            )
                          ],
                          onChanged: (newVal) {
                            setState(() {
                              selectedRemind = newVal!;
                            });
                          },
                          elevation: 3,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 30,
                          underline: Container(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'Repeat',
                      hint: selectedRepeat,
                      widget: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DropdownButton<String>(
                          dropdownColor:
                              Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                          items: [
                            ...repeatList.map(
                              (val) => DropdownMenuItem(
                                child: Text(val),
                                value: val,
                              ),
                            )
                          ],
                          onChanged: (newVal) {
                            setState(() {
                              selectedRepeat = newVal!;
                            });
                          },
                          elevation: 3,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 30,
                          underline: Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // color
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    buildColorsCircles(context, Theme.of(context).primaryColor,
                        0, selectedColor == 0),
                    const SizedBox(width: 5),
                    buildColorsCircles(
                        context,
                        Theme.of(context).colorScheme.secondary,
                        1,
                        selectedColor == 1),
                    const SizedBox(width: 5),
                    buildColorsCircles(
                        context, Colors.teal, 2, selectedColor == 2)
                  ]),
                ],
              ),
              CustomButton('Create Task', () {
                validation();
              })
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildColorsCircles(
      BuildContext context, Color color, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = index;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        child: isSelected ? const Icon(Icons.done, color: Colors.white) : null,
      ),
    );
  }

  validation() {
    if (titleController.text.trim().isNotEmpty &&
        noteController.text.trim().isNotEmpty) {
      addTasksToDB();
      Get.back();
    } else if (titleController.text.trim().isEmpty ||
        noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'please fill the empty fields',
        icon: const Icon(Icons.error_outline_rounded),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).errorColor,
        animationDuration: const Duration(milliseconds: 300),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'an error ocurred',
        icon: const Icon(Icons.error_rounded),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).errorColor,
        animationDuration: const Duration(milliseconds: 300),
        colorText: Colors.white,
      );
    }
  }

  addTasksToDB() async {
    int taskId = await taskController.addTask(Task(
      title: titleController.text.trim(),
      note: noteController.text.trim(),
      isCompleted: 0,
      color: selectedColor,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      repeat: selectedRepeat,
      remind: selectedRemind,
    ));
    print(taskId);
  }

  getDateFormUser() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: selectedDate,
      lastDate: DateTime(selectedDate.year + 5),
      currentDate: selectedDate,
    );
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  getTimeFromUser({required bool isStart}) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStart
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15)),
            ),
    );
    if (newTime != null) {
      if (isStart) {
        setState(() {
          startTime = newTime.format(context);
          endTime =
              newTime.replacing(minute: newTime.minute + 15).format(context);
        });
      } else {
        setState(() {
          endTime = newTime.format(context);
        });
      }
    }
  }
}
