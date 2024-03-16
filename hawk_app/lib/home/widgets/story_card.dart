import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StoryCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          margin: EdgeInsets.all(0.8.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/story/story.jpg'), 
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.w)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5.w,
                blurRadius: 1.w,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.6.w,),
        Text("Your story")
      ],
    );
  }
  
}