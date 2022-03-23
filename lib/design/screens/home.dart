import 'package:animations/animations.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/design/screens/profile.dart';
import 'package:todo_app/design/widgets/task_tile.dart';
import 'package:todo_app/logic/models/user.dart';
import 'package:todo_app/logic/services/user_data.dart';

import '../../logic/models/task.dart';
import '/constants/size_config.dart';
import '/logic/controllers/task_controller.dart';
import '/logic/services/notification_services.dart';
import 'add_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    NotifyHelper().requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = UserData().loadUser();
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: OpenContainer(
            closedBuilder: (context, action) => CircleAvatar(
              backgroundColor: context.theme.primaryColor,
              backgroundImage:
                  AssetImage(User.profilePictures[currentUser.profilePic]),
            ),
            openBuilder: (context, action) => const ProfileScreen(),
            closedElevation: 0,
            openElevation: 0,
            closedColor: Colors.transparent,
            onClosed: (_) {
              _taskController.getTasks();
              setState(() {
                currentUser = UserData().loadUser();
              });
            },
          ),
        ),
        title: Text(
          'Hello, ${currentUser.userName}',
          style: TextStyle(color: context.theme.textTheme.headline6!.color),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          buildTaskBar(context),
          buildDateTimeLine(context),
          showTasks(context),
        ],
      )),
    );
  }

  showBottomSheet(context, Task task) {
    final Color color = task.color == 0
        ? Theme.of(context).colorScheme.primary
        : task.color == 1
            ? Theme.of(context).colorScheme.secondary
            : Colors.teal;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenWidth * 0.9,
          height: task.isCompleted == 0
              ? SizeConfig.screenHeight * 0.4
              : SizeConfig.screenHeight * 0.3,
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
              Text(task.title!, style: Theme.of(context).textTheme.titleLarge),
              Divider(color: color, height: 3),
              if (task.isCompleted == 0)
                Container(
                  width: SizeConfig.screenWidth * 0.7,
                  height: SizeConfig.screenHeight * 0.065,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: color, width: 2),
                      color:
                          task.isCompleted == 0 ? Colors.transparent : color),
                  child: AnimatedButton(
                    onPress: () {
                      _taskController.completeTask(task.id!);
                      NotifyHelper().cancelNotification(task);
                      Future.delayed(const Duration(milliseconds: 300)).then(
                        (_) => Get.back(),
                      );
                    },
                    text: 'Completed',
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: color),
                    animationDuration: const Duration(milliseconds: 300),
                    transitionType: TransitionType.CENTER_ROUNDER,
                    backgroundColor: Colors.transparent,
                    borderRadius: 10,
                    selectedBackgroundColor: color,
                    selectedTextColor: Colors.white,
                  ),
                ),
              buildBottomSheetButton(
                label: 'Delete',
                color: Theme.of(context).colorScheme.error,
                onTap: () async {
                  _taskController.deleteTask(task);
                  NotifyHelper().cancelNotification(task);
                  Get.back();
                },
              ),
              Divider(color: color, height: 3),
              buildBottomSheetButton(
                label: 'Cancel',
                color: color,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      elevation: 10,
      barrierColor: Get.isDarkMode ? Colors.white12 : Colors.black26,
    );
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
    return Expanded(
      child: Obx(
        () {
          Iterable<Task> tasks = _taskController.tasksList.where((task) {
            return (task.date == DateFormat.yMd().format(selectedDate) ||
                    task.repeat == 'Daily') ||
                (task.repeat == 'Weekly' &&
                    selectedDate
                                .difference(DateFormat.yMd().parse(task.date!))
                                .inDays %
                            7 ==
                        0) ||
                (task.repeat == 'Monthly' &&
                    DateFormat.yMd().parse(task.date!).day ==
                        selectedDate.day) ||
                (task.repeat == 'Yearly' &&
                    DateFormat.yMd().parse(task.date!).month ==
                        selectedDate.month &&
                    DateFormat.yMd().parse(task.date!).day == selectedDate.day);
          });
          return RefreshIndicator(
            onRefresh: () => _taskController.getTasks(),
            child: ListView(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: tasks.isEmpty
                  ? buildSVG(context)
                  : tasks.map(
                      (task) {
                        var date = DateFormat.jm().parse(task.startTime!);
                        var time = DateFormat('HH:mm').format(date);
                        NotifyHelper().scheduledNotification(
                            int.parse(time.toString().split(':')[0]),
                            int.parse(time.toString().split(':')[1]),
                            task);
                        return AnimationConfiguration.staggeredList(
                          position: _taskController.tasksList
                              .indexWhere((e) => e == task),
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            horizontalOffset: 300,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () => showBottomSheet(context, task),
                                child: TaskTile(task),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildSVG(BuildContext context) {
    return [
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
          'You do not have any tasks for ${DateFormat.yMMMMd().format(selectedDate) == DateFormat.yMMMMd().format(DateTime.now()) ? 'Today' : DateFormat.EEEE().format(selectedDate)}! \n Add new tasks to make your days productive.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyText1!.copyWith(fontSize: 16),
        ),
      ),
    ];
  }

  Container buildTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          OpenContainer(
            closedBuilder: (ctx, act) => Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Add Task +',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
            openBuilder: (ctx, act) => const AddTask(),
            closedElevation: 0,
            openElevation: 0,
            closedColor: Colors.transparent,
            onClosed: (_) => _taskController.getTasks(),
          ),
        ],
      ),
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
