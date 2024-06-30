import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:hawk_app/home/models/story.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StoryCard extends StatelessWidget {
  StoryCard({required this.story, this.profile = true});

  final Story story;
  final bool profile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context)
            .go('/story/${story.id}${profile ? '?from=/' : '?from=/account'}');
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            margin: EdgeInsets.all(0.8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.w)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5.w,
                  blurRadius: 1.w,
                ),
              ],
            ),
            child: RoudndedSquareProfile(
                length: 20,
                profileUrl: profile ? story.owner.profileUrl : story.photos[0]),
          ),
          SizedBox(
            height: 1.6.w,
          ),
          Text(profile ? story.owner.username : story.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall)
        ],
      ),
    );
  }
}
