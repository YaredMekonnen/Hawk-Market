import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_product_event.dart';
part 'create_product_state.dart';

class CreateProductBloc extends Bloc<CreateProductEvent, CreateProductState> {

  ProductRepository productRepository;

  CreateProductBloc(this.productRepository) : super(CreateProductInitial()) {
    on<CreateProductEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CreateProduct> ((event, emit) async {
      emit(CreateProductLoading());

      final Result result = await this.productRepository.createProduct(
        tags: event.tags,
        name: event.name,
        description: event.description,
        price: event.price,
        images: event.images
      );

      if (result is Success) {
        emit(CreateProductSuccess(Product.fromJson(result.value as Map<String, dynamic>)));
      } else {
        emit(CreateProductFailure());
      }

    });
  }
}
