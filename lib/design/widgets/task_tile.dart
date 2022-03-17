import 'package:flutter/material.dart';

import '../../constants/size_config.dart';
import '../../logic/models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, {Key? key}) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(
          SizeConfig.orientation == Orientation.landscape ? 25 : 15)),
      width: SizeConfig.screenWidth * 0.9,
      decoration: BoxDecoration(
        color: task.color == 0
            ? Theme.of(context).colorScheme.primary
            : task.color == 1
                ? Theme.of(context).colorScheme.secondary
                : Colors.teal,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_alarm_rounded,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(width: 10),
                    Text('${task.startTime!} - ${task.endTime}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey[200],
                            )),
                  ],
                ),
                const SizedBox(height: 10),
                Text(task.note!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: task.isCompleted == 0 ? 50 : 80,
          width: 0.75,
          color: Colors.grey[200]!.withOpacity(0.7),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Text(task.isCompleted == 0 ? 'TODO' : 'Completed',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white)),
        )
      ]),
    );
  }
}
