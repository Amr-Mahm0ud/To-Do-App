import 'package:flutter/material.dart';
import 'package:todo_app/logic/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () => ThemeServices().switchTheme(),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: const [],
      )),
    );
  }
}