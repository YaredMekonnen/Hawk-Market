import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:hawk_app/profile/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:hawk_app/profile/blocs/load_profile/load_profile_bloc.dart';
import 'package:hawk_app/profile/blocs/load_user_story_bloc/load_user_story_bloc.dart';
import 'package:hawk_app/profile/blocs/posted_product_bloc/posted_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({required this.userId});
  final String userId;

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  int _currentPage = 0;
  changePage(page) {
    setState(() {
      if (_currentPage != page) {
        _currentPage = page;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<LoadProfileBloc>().add(LoadProfile(widget.userId));
    context
        .read<LoadUserStoryBloc>()
        .add(LoadUserStories(widget.userId, 0, 10));
    context.read<BookmarkBloc>().add(LoadBookmark(widget.userId, 0, 10));
    context.read<PostedBloc>().add(LoadPosted(widget.userId, 0, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            icon: Icon(
              size: 8.w,
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(4.w),
          sliver: SliverToBoxAdapter(
            child: BlocBuilder<LoadProfileBloc, LoadProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProfileLoaded) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: state.user.profileUrl != ""
                            ? CustomeNetworkImage(
                                imageUrl: state.user.profileUrl)
                            : Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/avatar/profile.jpg'),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            state.user.username,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            state.user.bio,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text("Error loading profile"),
                );
              },
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
            child: BlocBuilder<LoadUserStoryBloc, LoadUserStoryState>(
              builder: (context, state) {
                if (state is UserStoriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserStoriesLoaded) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.stories.length,
                    itemBuilder: (context, index) {
                      return StoryCard(
                        story: state.stories[index],
                        profile: false,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 2.w);
                    },
                  );
                }
                return const Center(
                  child: Text("Error loading stories"),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  changePage(0);
                },
                icon: Icon(
                  size: 8.w,
                  Icons.save,
                ),
                color: _currentPage == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              IconButton(
                onPressed: () {
                  changePage(1);
                },
                icon: Icon(
                  size: 8.w,
                  Icons.bookmark,
                ),
                color: _currentPage == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 0.3.w,
            width: 100.w,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        _currentPage == 0
            ? buildPostedPage(context)
            : buildBookmarkPage(context),
      ],
    ));
  }

  Widget buildBookmarkPage(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        if (state is BookmarkLoading) {
          return const SliverFillRemaining(
            child: CircularProgressIndicator(),
          );
        } else if (state is BookmarkLoaded) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).go(
                        '/account/product/${state.bookmarks[index].id}?from=/account');
                  },
                  child: Container(
                    margin: index % 3 == 0
                        ? EdgeInsets.only(left: 3.w, right: 3.w, top: 3.w)
                        : EdgeInsets.only(top: 3.w, right: 3.w),
                    width: 26.w,
                    height: 26.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5.w,
                          blurRadius: 1.w,
                        ),
                      ],
                    ),
                    child: CustomeNetworkImage(
                        imageUrl: state.bookmarks[index].photos[0]),
                  ),
                );
              },
              childCount: state.bookmarks.length,
            ),
          );
        }
        return const SliverFillRemaining(
          child: Text("Error loading bookmarks"),
        );
      },
    );
  }

  buildPostedPage(BuildContext context) {
    return BlocBuilder<PostedBloc, PostedState>(
      builder: (context, state) {
        if (state is PostedLoading) {
          return const SliverFillRemaining(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostedLoaded) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).go(
                        '/account/product/${state.products[index].id}?from=/account');
                  },
                  child: Container(
                    margin: index % 3 == 0
                        ? EdgeInsets.only(left: 3.w, right: 3.w, top: 3.w)
                        : EdgeInsets.only(top: 3.w, right: 3.w),
                    width: 26.w,
                    height: 26.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5.w,
                          blurRadius: 1.w,
                        ),
                      ],
                    ),
                    child: CustomeNetworkImage(
                        imageUrl: state.products[index].photos[0]),
                  ),
                );
              },
              childCount: state.products.length,
            ),
          );
        }
        return const SliverFillRemaining(
          child: Text("Error loading bookmarks"),
        );
      },
    );
  }
}
