import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/chat/service/socket_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hawk Market',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10.w,
                  fontWeight: FontWeight.bold),
            ),
            Image(image: AssetImage('assets/splash.png')),
          ]),
    );
  }
}
