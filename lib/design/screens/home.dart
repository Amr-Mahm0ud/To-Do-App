import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'ToDo App', centerTitle: false),
      body: SafeArea(
          child: Column(
        children: [
          buildTaskBar(context),
          buildDateTimeLine(context),
        ],
      )),
    );
  }

  Container buildTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
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
                'Today',
                style: context.textTheme.headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CustomButton('Add Task  +', () {
            Get.to(() => const AddTask());
          })
        ],
      ),
    );
  }

  AppBar customAppBar({required String title, required bool centerTitle}) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => ThemeServices().switchTheme(),
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

  buildDateTimeLine(BuildContext context) {
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
