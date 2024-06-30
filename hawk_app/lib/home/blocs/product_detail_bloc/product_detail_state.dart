part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailState {}

final class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {}
