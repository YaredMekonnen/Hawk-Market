import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonText extends StatelessWidget {
  final String text;

  const ButtonText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 6.w,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.background,
            ));
    ;
  }
}
