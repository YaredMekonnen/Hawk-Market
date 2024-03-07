import 'package:flutter/material.dart';

class ItemDescriptionPage extends StatefulWidget {
  
  @override
  State<ItemDescriptionPage> createState() => _ItemDescriptionPageState();
}

class _ItemDescriptionPageState extends State<ItemDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
    );
  }
}