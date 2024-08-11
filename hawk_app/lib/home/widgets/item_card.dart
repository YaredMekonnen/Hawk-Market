import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/chat/blocs/chat/chat_bloc.dart';
import 'package:hawk_app/chat/models/chat.dart';
import 'package:hawk_app/commons/utils/some_time_ago.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/home/blocs/load_story_bloc/load_story_bloc.dart';
import 'package:hawk_app/home/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:hawk_app/profile/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:hawk_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import "package:dots_indicator/dots_indicator.dart";

class ItemCard extends StatefulWidget {
  const ItemCard({required this.product, this.detail = false});
  final Product product;
  final bool detail;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late bool isBookmarked;
  late bool isStory;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    isBookmarked = widget.product.isBookmarked;
    isStory = widget.product.isStory;
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

  _showToast() {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: Color.fromARGB(255, 18, 129, 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            size: 8.w,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text("Story Created"),
        ],
      ),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child,
              SizedBox(
                width: 100.w,
                height: 10.h,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
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
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                          .go('/profile/${widget.product.owner.id}');
                    },
                    child: CircularProfile(widget.product.owner.profileUrl)),
                SizedBox(
                  width: 2.w,
                ),
                Text(widget.product.owner.username)
              ],
            ),
            widget.product.isOwn
                ? IconButton(
                    onPressed: () {
                      context
                          .read<ProductListBloc>()
                          .add(DeleteProduct(id: widget.product.id));
                    },
                    icon: Icon(
                      Icons.delete_outlined,
                      size: 8.w,
                      color: Theme.of(context).colorScheme.secondary,
                    ))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                      context
                          .read<BookmarkBloc>()
                          .add(BookmarkProduct(widget.product.id));
                    },
                    icon: Icon(
                      Icons.bookmark,
                      size: 10.w,
                      color: isBookmarked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ))
          ],
        ),
        Expanded(
          child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.photos.length,
              itemBuilder: (context, index) {
                return CustomeNetworkImage(
                    imageUrl: widget.product.photos[index]);
              }),
        ),
        DotsIndicator(
          dotsCount: widget.product.photos.length,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
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
                        getTimeAgo(widget.product.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: !widget.product.isOwn
                    ? [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 0.w)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.5.w)),
                            ),
                          ),
                          child: Text(
                            "Buy",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: 7.w),
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            String userId = context.read<AuthCubit>().user!.id;
                            if (userId != widget.product.owner.id)
                              GoRouter.of(context).go(
                                  '/chat/-1?userId=$userId&otherUserId=${widget.product.owner.id}');
                          },
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: themeProvider.themeMode == ThemeMode.dark
                                    ? const AssetImage(
                                        'assets/vectors/message.png')
                                    : const AssetImage(
                                        'assets/vectors/message-dark.png'),
                              ),
                            ),
                          ),
                        )
                      ]
                    : [
                        isStory
                            ? Column(
                                children: [
                                  Container(
                                    width: 7.w,
                                    height: 7.w,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            'assets/vectors/story-active.png'),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Share as a story',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 3.w),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<LoadStoryBloc>()
                                          .add(MakeStory(widget.product.id));
                                      setState(() {
                                        isStory = true;
                                      });
                                      _showToast();
                                    },
                                    child: Container(
                                      width: 7.w,
                                      height: 7.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? const AssetImage(
                                                  'assets/vectors/story.png')
                                              : const AssetImage(
                                                  'assets/vectors/story-dark.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Share as a story',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 3.w),
                                  )
                                ],
                              )
                      ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3.w),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/product/${widget.product.id}');
            },
            child: Text(
              widget.product.description,
              maxLines: widget.detail ? null : 3,
              overflow: widget.detail ? null : TextOverflow.ellipsis,
            ),
          ),
        )
      ]),
    );
  }
}
