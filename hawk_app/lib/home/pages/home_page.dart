import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hawk_app/commons/sidebar.dart';

class HomePage extends StatefulWidget {
  
  HomePage({
    super.key,
    required this.scaffoldKey,
    required this.child,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final StatefulNavigationShell child;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _selectedIndex = 0;
  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: Sidebar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //this is the shells branches
          widget.child,

          Container(
            width: 70.w,
            height: 15.w,
            margin: EdgeInsets.only(bottom: 3.w),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
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
                  color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  icon: Icon(
                    Icons.home,
                  ),
                  onPressed: () => _onItemTapped(context, 0),
                ),
                IconButton(
                  color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => _onItemTapped(context, 1),
                ),
                IconButton(
                  color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
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