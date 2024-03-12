import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}