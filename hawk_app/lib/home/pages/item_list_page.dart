import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/home/widgets/item_card.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemListPage extends StatefulWidget {
  
  @override
  State<ItemListPage> createState() => _ItemListPageState();

}

class _ItemListPageState extends State<ItemListPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            size: 8.w,
            Icons.menu,
          ),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              size: 8.w,
              Icons.search
            ),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(
              size: 8.w,
              Icons.chat
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: 100.w,
            constraints: BoxConstraints(maxHeight: 30.w),
            padding: EdgeInsets.only(right: 4.w, left: 4.w, bottom: 1.6.w),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index){
                return StoryCard();
              },
              separatorBuilder: (context, index){
                return SizedBox(width: 2.w);
              },
            ),
          ),
          Container(
            height: 0.2.w,
            width: 100.w,
            color: Colors.white,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              itemBuilder: (context, index){
                return ItemCard();
              }, 
              separatorBuilder:(context, index) => SizedBox(height: 0.w,), 
            ),
          )
        ],
      )
    );
  }
}