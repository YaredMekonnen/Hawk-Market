part of 'search_product_bloc.dart';

@immutable
sealed class SearchProductState {}

final class SearchProductInitial extends SearchProductState {}

class SearchProductLoading extends SearchProductState {}

class SearchProductLoaded extends SearchProductState {
  final List<Product> products;

  SearchProductLoaded(this.products);
}

class SearchMoreProductLoaded extends SearchProductState {
  final List<Product> products;

  SearchMoreProductLoaded(this.products);
}

class SearchProductError extends SearchProductState {}

class SearchMoreProductLoading extends SearchProductState {}

class SearchMoreProductError extends SearchProductState {}
