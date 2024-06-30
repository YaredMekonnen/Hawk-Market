import 'package:bloc/bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:meta/meta.dart';

import 'package:hawk_app/create_product/models/product.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  final ProductRepository _productRepository;
  SearchProductBloc(this._productRepository) : super(SearchProductInitial()) {
    on<SearchProductLoad>((event, emit) async {
      emit(SearchProductLoading());

      final Result result = await _productRepository.getProducts(
          skip: event.skip, limit: event.limit, search: event.search);

      if (result is Success) {
        var products = result.value['data']
            .map((product) {
              return Product.fromJson(product);
            })
            .toList()
            .cast<Product>();
        emit(SearchProductLoaded(products));
      } else {
        emit(SearchProductError());
      }
    });

    on<SearchMoreProducts>((event, emit) async {
      if (state is SearchProductLoading || state is SearchMoreProductLoading)
        return;

      emit(SearchMoreProductLoading());
      final Result result = await _productRepository.getProducts(
          skip: event.skip, limit: event.limit);

      if (result is Success) {
        var products = result.value['data']
            .map((product) {
              return Product.fromJson(product);
            })
            .toList()
            .cast<Product>();
        emit(SearchMoreProductLoaded(products));
      } else {
        emit(SearchMoreProductError());
      }
    });
  }
}
