import 'package:flutter/material.dart';

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
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Image(image: AssetImage('assets/splash.png')),
        ]
      ),
    );
  }
}