import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SidebarRow extends StatelessWidget {
  final IconData icon;
  final String title;
  SidebarRow(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, top: 3.5.w, bottom: 3.5.w),
      child: (Row(children: [
        Icon(
          icon,
          size: 6.w,
          color: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ])),
    );
  }
}
