import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payLoad}) : super(key: key);

  final String payLoad;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final bodyTextStyle =
        context.theme.textTheme.bodyText1!.copyWith(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: context.theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
        title: Text(widget.payLoad.split('|')[0]),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hello, Amr Mahmoud',
              style: context.theme.textTheme.headline5!
                  .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'You have a new reminder',
              style: context.theme.textTheme.subtitle1!.copyWith(
                  color: context.theme.textTheme.subtitle1!.color!
                      .withOpacity(0.7)),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.text_format_rounded),
                        const SizedBox(width: 20),
                        Text('Title', style: context.theme.textTheme.headline6)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(widget.payLoad.split('|')[0], style: bodyTextStyle),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.description),
                        const SizedBox(width: 20),
                        Text('Description',
                            style: context.theme.textTheme.headline6)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(widget.payLoad.split('|')[1], style: bodyTextStyle),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded),
                        const SizedBox(width: 20),
                        Text('Time', style: context.theme.textTheme.headline6)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(widget.payLoad.split('|')[2], style: bodyTextStyle),
                  ],
                )),
              ),
            )
          ],
        ),
      )),
    );
  }
}
