import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/home/blocs/product_detail_bloc/product_detail_bloc.dart';
import 'package:hawk_app/home/widgets/item_card.dart';

class ItemDescriptionPage extends StatefulWidget {
  ItemDescriptionPage(this.productId, this.from);
  final String productId;
  final String from;

  @override
  State<ItemDescriptionPage> createState() => _ItemDescriptionPageState();
}

class _ItemDescriptionPageState extends State<ItemDescriptionPage> {
  @override
  initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(ProductDetailLoad(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            GoRouter.of(context).go(widget.from);
          },
        ),
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductDetailError) {
            return Center(
              child: Column(
                children: [
                  const Text('Error while loading chats'),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductDetailBloc>()
                            .add(ProductDetailLoad(widget.productId));
                      },
                      child: const ButtonText(text: "Reload"))
                ],
              ),
            );
          }
          if (state is ProductDetailLoaded) {
            return ItemCard(
              product: state.product,
              detail: true,
            );
          }
          return const Column();
        },
      ),
    );
  }
}
