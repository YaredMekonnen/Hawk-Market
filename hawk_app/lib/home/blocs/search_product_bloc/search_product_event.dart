part of 'search_product_bloc.dart';

@immutable
sealed class SearchProductEvent {}

final class SearchProductLoad extends SearchProductEvent {
  final int skip;
  final int limit;
  final String search;

  SearchProductLoad(this.skip, this.limit, this.search);
}

final class SearchMoreProducts extends SearchProductEvent {
  final int skip;
  final int limit;
  final String search;

  SearchMoreProducts(this.skip, this.limit, this.search);
}
