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
        leading: ElevatedButton(
          child: const Text('Discard'),
          onPressed: () {
          },
        ),
        actions: [
          ElevatedButton(
            child: const Text('Post'),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Tags',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Item Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Price',
            ),
          ),
        ],
      ),
    );
  }
}