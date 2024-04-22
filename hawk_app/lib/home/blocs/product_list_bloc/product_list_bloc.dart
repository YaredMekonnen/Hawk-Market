import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:hawk_app/create_product/service/product.service.dart';
import 'package:meta/meta.dart';

import 'package:hawk_app/create_product/models/product.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository _productRepository;
  ProductListBloc(this._productRepository) : super(ProductListInitial()) {

    on<ProductListLoad>((event, emit) async {
      emit(ProductListLoading());

      final Result result = await _productRepository.getProducts(page: event.page, limit: event.limit);

      if (result is Success) {
        var products = result.value['data'].map((product){
          return Product.fromJson(product);
        }).toList().cast<Product>();
        emit(ProductListLoaded(products));
      } else {
        emit(ProductListError());
      }

    });
  }
}