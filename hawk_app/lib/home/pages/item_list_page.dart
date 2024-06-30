import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/chat/service/socket_service.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/home/blocs/load_story_bloc/load_story_bloc.dart';
import 'package:hawk_app/home/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:hawk_app/home/models/story.dart';
import 'package:hawk_app/home/widgets/item_card.dart';
import 'package:hawk_app/home/widgets/story_card.dart';
import 'package:hawk_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemListPage extends StatefulWidget {
  ItemListPage({required this.scaffoldKey, required this.from});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String from;

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Product> products = [];

  late ScrollController _scrollController;
  late ScrollController _storyScrollController;
  late FToast fToast;

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context
          .read<ProductListBloc>()
          .add(LoadMoreProducts(products.length, 10));
    }
  }

  void _onStoryListScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<LoadStoryBloc>().add(LoadMoreStories());
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    context.read<SocketService>().connect();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _storyScrollController = ScrollController();
    _storyScrollController.addListener(_onStoryListScroll);
    context.read<ProductListBloc>().add(ProductListLoad(0, 10));
    context.read<LoadStoryBloc>().add(LoadStories(0, 10));
    if (widget.from == '/payment') {
      Future.delayed(Duration(seconds: 3), () {
        _showToast();
      });
    }
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
          Text("Post Successful"),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.secondary,
          ),
          iconSize: 8.w,
          onPressed: () {
            widget.scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary,
            ),
            iconSize: 8.w,
            onPressed: () {
              GoRouter.of(context).go('/search');
            },
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/chat');
            },
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: themeProvider.themeMode == ThemeMode.dark
                      ? const AssetImage('assets/vectors/message.png')
                      : const AssetImage('assets/vectors/message-dark.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductListBloc>().add(ProductListLoad(0, 10));
          context.read<LoadStoryBloc>().add(LoadStories(0, 10));
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    constraints: BoxConstraints(maxHeight: 30.w),
                    padding: EdgeInsets.only(right: 0.w, bottom: 1.6.w),
                    child: BlocBuilder<LoadStoryBloc, LoadStoryState>(
                      builder: (context, state) {
                        if (state is StoryLoadingError) {
                          return Center(
                            child: Text(
                              'Couldn\'t load stories',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }
                        if (state is StoriesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Story> stories =
                            context.read<LoadStoryBloc>().stories;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: stories.length + 1,
                          controller: _storyScrollController,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return SizedBox(width: 1.w);
                            }
                            return StoryCard(story: stories[index - 1]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 2.w);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 0.2.w,
                    width: 100.w,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ProductListLoaded) {
                    products = state.products;
                  }
                  if (state is MoreProductListLoaded) {
                    products.addAll(state.products);
                  }
                  if (state is ProductListError) {
                    return Center(
                      child: Text('Error'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (products.length == index) {
                        return SizedBox(
                          height: 10.h,
                        );
                      }
                      return ItemCard(product: products[index]);
                    },
                    itemCount: products.length + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
