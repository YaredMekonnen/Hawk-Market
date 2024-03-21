import 'package:flutter/material.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelfProfilePage extends StatefulWidget {
  
  @override
  State<SelfProfilePage> createState() => _SelfProfilePageState();
}

class _SelfProfilePageState extends State<SelfProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      CustomScrollView(
        slivers: [
          SliverAppBar(
        floating: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            size: 8.w,
            Icons.menu,
          ),
          onPressed: () {
          },
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Settings"),
              ),
              PopupMenuItem(
                child: Text("Log Out"),
              )
            ];
          })
        ],
      ),
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/story/story.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "brainn",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "This is my basic info",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 5.w),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 4.w),
              width: 100.w,
              constraints: BoxConstraints(maxHeight: 35.w),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return StoryCard();
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 2.w);
                },
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            pinned: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    size: 8.w,
                    Icons.save,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    size: 8.w,
                    Icons.bookmark,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 0.1.w,
              width: 100.w,
              color: Colors.white,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/story/story.jpg"),
                    ),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      )

    );
  }
}