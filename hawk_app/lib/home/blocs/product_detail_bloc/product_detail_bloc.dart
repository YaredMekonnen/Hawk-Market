import 'package:bloc/bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:meta/meta.dart';

import 'package:hawk_app/create_product/models/product.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository _productRepository;
  ProductDetailBloc(this._productRepository) : super(ProductDetailInitial()) {
    on<ProductDetailLoad>((event, emit) async {
      emit(ProductDetailLoading());

      final Result result =
          await _productRepository.getProduct(productId: event.productId);

      if (result is Success) {
        var product = Product.fromJson(result.value['data']);
        emit(ProductDetailLoaded(product));
      } else {
        emit(ProductDetailError());
      }
    });
  }
}
