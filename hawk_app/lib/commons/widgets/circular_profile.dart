import 'package:flutter/material.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CircularProfile extends StatelessWidget {
  final String profileUrl;
  CircularProfile(this.profileUrl);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 5.5.w,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Container(
        width: 10.w,
        height: 10.w,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.w)),
        child: profileUrl != ""
            ? CustomeNetworkImage(imageUrl: profileUrl)
            : Container(
                width: 5.w,
                height: 5.w,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.w),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/avatar/profile.jpg'),
                  ),
                ),
              ),
      ),
    );
  }
}

class RoudndedSquareProfile extends StatelessWidget {
  final double length;
  final String profileUrl;
  RoudndedSquareProfile({required this.length, required this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: length.w,
      height: length.w,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2 / 13 * length.w),
      ),
      child: profileUrl != ""
          ? CustomeNetworkImage(imageUrl: profileUrl)
          : Container(
              width: length.w,
              height: length.w,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/avatar/profile.jpg'),
                ),
              ),
            ),
    );
  }
}
