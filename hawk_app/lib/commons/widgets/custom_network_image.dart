import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomeNetworkImage extends StatelessWidget {
  final String imageUrl;
  CustomeNetworkImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        heightFactor: 1,
        widthFactor: 1,
        child: Container(
          width: 10.w,
          height: 10.w,
          constraints: BoxConstraints(maxHeight: 10.w, maxWidth: 10.w),
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            strokeWidth: 1.w,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: Theme.of(context).colorScheme.secondary,
      ),
      fit: BoxFit.cover,
    );
  }
}
