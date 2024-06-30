part of 'create_product_bloc.dart';

@immutable
sealed class CreateProductEvent {}

class SaveProduct extends CreateProductEvent {
  final String tags;
  final String name;
  final String description;
  final num price;
  final List<XFile> images;

  SaveProduct({
    required this.tags,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
  });
}

class CreateProduct extends CreateProductEvent {}
