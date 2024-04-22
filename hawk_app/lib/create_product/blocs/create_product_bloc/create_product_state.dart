part of 'create_product_bloc.dart';

@immutable
sealed class CreateProductState {}

final class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {
  final Product product;

  CreateProductSuccess(this.product);
}

class CreateProductFailure extends CreateProductState {}