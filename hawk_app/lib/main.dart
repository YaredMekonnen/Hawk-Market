import 'package:flutter/material.dart';
import 'package:hawk_app/home/pages/home_page.dart';
import 'package:hawk_app/route/route.dart';
import 'package:hawk_app/theme/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {    
        return AppRouter();
      }
    );
  }
}
