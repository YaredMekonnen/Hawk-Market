import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemPhoto extends StatelessWidget {
  ItemPhoto({Key? key, required this.image, required this.removeImage}) : super(key: key);

  final XFile image;
  final Function removeImage;

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          margin: EdgeInsets.all(0.8.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(image.path)), 
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
          child:Text('')
        ),
        GestureDetector(
          onTap: () => removeImage(),
          child: Container(
            width: 5.w,
            height: 5.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(2.5.w)),
            ),
            child: Text(
              '--',
              style: TextStyle(
                color: Colors.black,
                fontSize: 3.w,
                fontWeight: FontWeight.bold
              ),
            )
          ),
        ),
      ],
    );
  }
  
}