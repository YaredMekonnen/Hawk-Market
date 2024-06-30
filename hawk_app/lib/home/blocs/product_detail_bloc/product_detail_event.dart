part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailEvent {}

final class ProductDetailLoad extends ProductDetailEvent {
  final String productId;
  ProductDetailLoad(this.productId);
}
