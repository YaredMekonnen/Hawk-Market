import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  
  HomePage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;
  var _selectedIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      widget._selectedIndex = index;
    });
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,

          Container(
            width: 70.w,
            height: 15.w,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(7.5.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => _onItemTapped(context, 0),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => _onItemTapped(context, 1),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle_outlined),
                  onPressed: () => _onItemTapped(context, 2),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}