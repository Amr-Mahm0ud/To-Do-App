import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.label, this.onTab, {Key? key}) : super(key: key);
  final String label;
  final Function() onTab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(25),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontSize: 18, color: Colors.white),
        ),
      ),
      onTap: onTab,
    );
  }
}
