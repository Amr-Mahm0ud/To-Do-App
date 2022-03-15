import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.label, this.onTab, {Key? key}) : super(key: key);
  final String label;
  final Function() onTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          overlayColor: MaterialStateProperty.all(Colors.white10),
        ),
        onPressed: onTab,
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
