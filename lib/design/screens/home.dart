import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../logic/models/task.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import '/constants/size_config.dart';
import '/logic/controllers/task_controller.dart';
import '/logic/services/notification_services.dart';
import '/logic/services/theme_services.dart';
import 'add_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    // notifyHelper.scheduleNotification(hours: 0, minutes: 0, seconds: 3);
    notifyHelper.iosRequestPermission();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar(title: 'ToDo App', centerTitle: false),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            buildTaskBar(context),
            buildDateTimeLine(context),
            // showTasks(context),
            GestureDetector(
              onTap: () {
                showBottomSheet(
                  context,
                  Task(
                      title: 'Title',
                      note:
                          'note note note note note note note note note note note note note note note note note note note note note note note note note',
                      isCompleted: 0,
                      startTime: '10:30',
                      endTime: '11:00',
                      color: 2),
                );
              },
              child: TaskTile(
                Task(
                    title: 'Title',
                    note:
                        'note note note note note note note note note note note note note note note note note note note note note note note note note',
                    isCompleted: 0,
                    startTime: '10:30',
                    endTime: '11:00',
                    color: 2),
              ),
            ),
          ],
        ),
      )),
    );
  }

  showBottomSheet(context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        height: task.isCompleted == 0
            ? SizeConfig.screenHeight * 0.35
            : SizeConfig.screenHeight * 0.25,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (task.isCompleted == 0)
              buildBottomSheetButton(
                label: 'Completed',
                color: task.color == 0
                    ? Theme.of(context).colorScheme.primary
                    : task.color == 1
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.teal,
                onTap: () {
                  Get.back();
                },
              ),
            buildBottomSheetButton(
              label: 'Delete',
              color: task.color == 0
                  ? Theme.of(context).colorScheme.primary
                  : task.color == 1
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.teal,
              onTap: () {
                Get.back();
              },
            ),
            Divider(color: Theme.of(context).primaryColor, height: 3),
            buildBottomSheetButton(
              label: 'Cancel',
              color: task.color == 0
                  ? Theme.of(context).colorScheme.primary
                  : task.color == 1
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.teal,
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  buildBottomSheetButton({
    required String label,
    required Function() onTap,
    required Color color,
    bool isCompleted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth * 0.7,
        height: SizeConfig.screenHeight * 0.065,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: color),
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white)),
      ),
    );
  }

  showTasks(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 1500),
          child: SingleChildScrollView(
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 0)
                    : const SizedBox(height: 140),
                SvgPicture.asset(
                  'assets/images/task.svg',
                  height: 90,
                  color: context.theme.primaryColor.withOpacity(0.7),
                  semanticsLabel: 'Task',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'You do not have any tasks yet! \n Add new tasks to make your days productive.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyText1!.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container buildTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(selectedDate),
                style: context.textTheme.headline6,
              ),
              Text(
                DateFormat.yMMMMd().format(selectedDate) ==
                        DateFormat.yMMMMd().format(DateTime.now())
                    ? 'Today'
                    : DateFormat.EEEE().format(selectedDate),
                style: context.textTheme.headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CustomButton('Add Task  +', () async {
            await Get.to(() => const AddTask());
            _taskController.getTasks();
          })
        ],
      ),
    );
  }

  AppBar customAppBar({required String title, required bool centerTitle}) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            NotifyHelper()
                .displayNotification(title: 'ToDo App', body: 'theme switched');
          },
          icon: Icon(
            Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            color: context.theme.iconTheme.color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.jpeg'),
            ),
          ),
        ),
      ],
      title: Text(
        title,
        style: TextStyle(color: context.theme.textTheme.headline6!.color),
      ),
      centerTitle: centerTitle,
    );
  }

  Container buildDateTimeLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: DatePicker(
        DateTime.now(),
        width: 75,
        height: 100,
        dateTextStyle:
            context.textTheme.headline5!.copyWith(color: Colors.grey),
        dayTextStyle: context.textTheme.bodyText1!.copyWith(color: Colors.grey),
        initialSelectedDate: selectedDate,
        onDateChange: (newDate) {
          setState(() {
            selectedDate = newDate;
          });
        },
        monthTextStyle:
            context.textTheme.bodyText1!.copyWith(color: Colors.grey),
        selectionColor: context.theme.primaryColor,
      ),
    );
  }
}
