import 'package:flutter/material.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:hawk_app/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:hawk_app/profile/widgets/profile_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelfProfilePage extends StatefulWidget {
  
  @override
  State<SelfProfilePage> createState() => _SelfProfilePageState();
}

class _SelfProfilePageState extends State<SelfProfilePage> {

  final PageController _controller = PageController();
  int _currentPage = 0;
  changePage(page) {
    setState(() {
      if (_currentPage != page){
        _currentPage = page;
      }
    });
  }

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
                    child: Text("Edit Profile"),
                    onTap: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ProfileDialog();
                          }
                      )
                    },
                  ),
                  PopupMenuItem(
                    child: Text("Logout"),
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
            expandedHeight: 0.w,
            backgroundColor: Theme.of(context).colorScheme.background,
            pinned: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: (){
                    changePage(0);
                  },
                  icon: Icon(
                    size: 8.w,
                    Icons.save,
                  ),
                  color: _currentPage == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                ),
                IconButton(
                  onPressed: (){
                    changePage(1);
                  },
                  icon: Icon(
                    size: 8.w,
                    Icons.bookmark,
                  ),
                  color: _currentPage == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
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
          _currentPage == 0 ?
          buildPostedPage(context):
          buildBookmarkPage(context),
        ],
      )
    );
  }

  Widget buildBookmarkPage(BuildContext context){
    return
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              margin: EdgeInsets.all(1.w),
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5.w),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/story/story.jpg"),
                ),
              ),
            );
          },
          childCount: 20,
        ),
      );
  }

  buildPostedPage(BuildContext context){
    return 
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              margin: EdgeInsets.all(1.w),
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5.w),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/story/story.jpg"),
                ),
              ),
            );
          },
          childCount: 20,
        ),
      );
  }
}