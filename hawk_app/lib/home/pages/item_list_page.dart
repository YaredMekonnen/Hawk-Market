import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/sidebar.dart';
import 'package:hawk_app/home/widgets/item_card.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            floating: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                widget.scaffoldKey.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  GoRouter.of(context).go('/search');
                },
              ),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: 100.w,
                    constraints: BoxConstraints(maxHeight: 30.w),
                    padding: EdgeInsets.only(right: 4.w, left: 4.w, bottom: 1.6.w),
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
                  Container(
                    height: 0.2.w,
                    width: 100.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ItemCard();
              },
              childCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
