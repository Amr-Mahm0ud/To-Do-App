import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/logic/models/task.dart';
import 'package:todo_app/logic/services/notification_services.dart';
import '/constants/size_config.dart';
import '/logic/controllers/task_controller.dart';
import 'add_task.dart';
import '../widgets/button.dart';
import '/logic/services/theme_services.dart';

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
          child: Column(
        children: [
          buildTaskBar(context),
          buildDateTimeLine(context),
          showTasks(context),
        ],
      )),
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
