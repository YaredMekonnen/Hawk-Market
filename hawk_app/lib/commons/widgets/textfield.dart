import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomeTextField extends StatefulWidget {
  CustomeTextField({
    required this.hintText,
    required this.controller,
    this.value = '',
    this.lines = 1,
    this.labelText = '',
    this.inputType = TextInputType.text,
    this.password = false,
    required this.validator,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController controller;
  final String value;
  final int lines;
  final String labelText;
  final TextInputType inputType;
  final String? Function(String?) validator;
  bool password;
  bool enabled;

  @override
  State<StatefulWidget> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  bool visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.text = widget.value;
    if (widget.password) {
      visible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerRight, children: [
      TextFormField(
        // onTapOutside: (event) => FocusScope.of(context).unfocus(),
        maxLines: widget.password ? 1 : null,
        obscureText: visible,
        obscuringCharacter: '*',
        validator: widget.validator,
        enabled: widget.enabled,
        minLines: widget.lines,
        keyboardType: widget.inputType,
        controller: widget.controller,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: 90.w),
            label: Text(widget.hintText),
            hintText: widget.labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.3.w),
                borderRadius: BorderRadius.circular(3.w)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.3.w),
                borderRadius: BorderRadius.circular(3.w)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.3.w),
                borderRadius: BorderRadius.circular(3.w)),
            alignLabelWithHint: true),
      ),
      if (widget.password)
        IconButton(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          iconSize: 6.w,
          icon: Icon(
            Icons.remove_red_eye_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
        )
    ]);
  }
}
