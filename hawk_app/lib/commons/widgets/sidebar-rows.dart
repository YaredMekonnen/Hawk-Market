import 'package:flutter/material.dart';

class SidebarRow extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return (
      ListTile(
        leading: Icon(Icons.home),
        title: Text("Settings")
      )
    );
  }
}