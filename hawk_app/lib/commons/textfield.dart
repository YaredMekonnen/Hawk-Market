import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomeTextField extends StatefulWidget {

  const CustomeTextField({
    required this.hintText,
  });

  final String hintText;

  @override
  State<StatefulWidget> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              constraints: BoxConstraints(
                maxHeight: 13.w,
                maxWidth: 90.w
              ),
              label: Text(widget.hintText),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.w)
              ),
            ),
          );
  }
}