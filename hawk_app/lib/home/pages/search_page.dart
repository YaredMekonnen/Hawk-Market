import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/home/blocs/search_product_bloc/search_product_bloc.dart';
import 'package:hawk_app/home/widgets/item_card.dart';
import 'package:hawk_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  List<Product> result = [];

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        _searchController.text.isNotEmpty) {
      context
          .read<SearchProductBloc>()
          .add(SearchMoreProducts(result.length, 10, _searchController.text));
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (text) {
                context
                    .read<SearchProductBloc>()
                    .add(SearchProductLoad(0, 10, text));
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.background),
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.background),
                fillColor: Theme.of(context).colorScheme.secondary,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  GoRouter.of(context).go('/');
                },
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).colorScheme.background,
                ))
          ],
        ),
      ),
      body: BlocBuilder<SearchProductBloc, SearchProductState>(
        builder: (context, state) {
          if (state is SearchProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchProductError) {
            return Center(
              child: Column(
                children: [
                  Text('Error while loading chats',
                      style: Theme.of(context).textTheme.bodyMedium),
                  ElevatedButton(
                      onPressed: () {
                        context.read<SearchProductBloc>().add(
                            SearchProductLoad(0, 10, _searchController.text));
                      },
                      child: const ButtonText(text: "Reload"))
                ],
              ),
            );
          }
          if (state is SearchProductLoaded && state.products.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: themeProvider.themeMode == ThemeMode.dark
                            ? const AssetImage('assets/vectors/search-dark.png')
                            : const AssetImage(
                                'assets/vectors/search-light.png'),
                      ),
                    ),
                  ),
                  const Text('No products found'),
                ],
              ),
            );
          }
          if (state is SearchProductLoaded) {
            result = state.products;
          }
          if (state is SearchMoreProductLoaded) {
            result.addAll(state.products);
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: result.length,
            itemBuilder: (context, index) {
              return ItemCard(product: result[index]);
            },
          );
        },
      ),
    );
  }
}
