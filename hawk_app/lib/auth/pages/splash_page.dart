import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashPage extends StatefulWidget {
  
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hawk Market',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 7.w
            ),
          ),
          Image(image: AssetImage('assets/splash.png')),
        ]
      ),
    );
  }
}