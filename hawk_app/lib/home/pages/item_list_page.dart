import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemListPage extends StatefulWidget {
  
  @override
  State<ItemListPage> createState() => _ItemListPageState();

}

class _ItemListPageState extends State<ItemListPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item list',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Item list',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  GoRouter.of(context).go('/search');
                }, 
                child: Text('Go to item description')
              )
            ],
          ),
        ),
      )
    );
  }
}