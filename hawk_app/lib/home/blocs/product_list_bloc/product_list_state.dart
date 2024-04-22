part of 'product_list_bloc.dart';

@immutable
sealed class ProductListState {}

final class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;

  ProductListLoaded(this.products);
}

class ProductListError extends ProductListState {}
