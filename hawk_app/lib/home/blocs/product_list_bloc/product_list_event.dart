part of 'product_list_bloc.dart';

@immutable
sealed class ProductListEvent {}

final class ProductListLoad extends ProductListEvent {
  final int skip;
  final int limit;

  ProductListLoad(this.skip, this.limit);
}

final class LoadMoreProducts extends ProductListEvent {
  final int skip;
  final int limit;

  LoadMoreProducts(this.skip, this.limit);
}

class DeleteProduct extends ProductListEvent {
  final String id;

  DeleteProduct({required this.id});
}

final class ProductListRefresh extends ProductListEvent {}
