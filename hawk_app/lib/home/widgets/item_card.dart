import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import "package:dots_indicator/dots_indicator.dart";

class ItemCard extends StatefulWidget {

  const ItemCard({required this.product});
  final Product product;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: 140.w,
      width: 94.w,
      padding: EdgeInsets.all(2.w),
      margin: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5.w,
            blurRadius: 1.w,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircularProfile(),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    "brainn"
                  )
                ],
              ),
              IconButton(
                onPressed: ()=>null , 
                icon: Icon(
                  Icons.bookmark,
                  size: 10.w,
                )
              )
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.images.length,
              itemBuilder: (context, index){
                return CachedNetworkImage(
                  imageUrl: widget.product.images[index],
                  progressIndicatorBuilder: (context, url, downloadProgress) => 
                          Center(
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                );
              }
            ),
          ),

          DotsIndicator(
            dotsCount: widget.product.images.length,
            position: _currentPage,
            decorator: DotsDecorator(
              color: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.secondary,
              size: Size.square(1.5.w),
              activeSize: Size(2.5.w, 2.5.w),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.25.w),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "\$${widget.product.price}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "54 min ago",
                         style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.w)
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                          fontSize: 20.sp
                        )
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.5.w)
                        ),
                      ),
                    ),
                    child: Text(
                      "Buy",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background
                      ),
                    )
                  ),
                  IconButton(
                    onPressed: (){}, 
                    icon: Icon(
                      Icons.messenger
                    )
                  )
                ],
              ),

            ],
          ),
          Text(
            "Lorem ipsum dolor sit amet consectetur. Id mattis felis orci neque mattis tincidunt consectetur. Praesent quis dictumst eu in ullamcorper ante. See More..", 
            maxLines: 3,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          )
        ]
      ),
    );
  }
}