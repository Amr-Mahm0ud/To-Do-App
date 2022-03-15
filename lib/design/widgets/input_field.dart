import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 5),
        SizedBox(
          child: TextFormField(
            controller: controller,
            autofocus: false,
            readOnly: widget == null ? false : true,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: widget,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: Theme.of(context).iconTheme.color!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: widget != null
                        ? Theme.of(context).iconTheme.color!
                        : Theme.of(context).primaryColor,
                    width: widget == null ? 2 : 1),
              ),
            ),
          ),
        )
      ],
    );
  }
}
