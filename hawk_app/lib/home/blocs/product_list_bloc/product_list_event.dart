part of 'product_list_bloc.dart';

@immutable
sealed class ProductListEvent {}

final class ProductListLoad extends ProductListEvent {
  final int page;
  final int limit;

  ProductListLoad(this.page, this.limit);
}

final class ProductListRefresh extends ProductListEvent {}