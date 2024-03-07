import 'package:flutter/material.dart';

class SelfProfilePage extends StatefulWidget {
  
  @override
  State<SelfProfilePage> createState() => _SelfProfilePageState();
}

class _SelfProfilePageState extends State<SelfProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
    );
  }
}