import "package:flutter/material.dart";
import "package:hawk_app/commons/sidebar-rows.dart";
import "package:responsive_sizer/responsive_sizer.dart";

class Sidebar extends StatefulWidget {

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return (
      Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            DrawerHeader(
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/story/story.jpg")
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "brainn",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 4.w,),
                      Text(
                        "This is my basic info",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )
                ],
              ),
            ),
            SidebarRow(),
            SidebarRow(),
            SidebarRow(),
            SidebarRow(),
            SidebarRow(),
            SidebarRow(),
            Expanded(
              child: Container(), 
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 0.1.w,
            ),
            ElevatedButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 2.w,),
                  Text("Logout")
                ]
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
                maximumSize: Size(40.w, 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0.5.w,
                )
              ),
            ),
            SizedBox(height: 4.w,),
          ],
        ),
      )
    );
  }
}