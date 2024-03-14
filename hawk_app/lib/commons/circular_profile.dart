import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class CircularProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return  
    CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/story/story.jpg'),
        radius: 5.w,
      ),
      radius: 5.5.w,
    );
  }
}