import 'package:bloc/bloc.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/create_product/models/product.dart';
import 'package:hawk_app/create_product/repository/product.repository.dart';
import 'package:meta/meta.dart';

part 'posted_event.dart';
part 'posted_state.dart';

class PostedBloc extends Bloc<PostedEvent, PostedState> {
  final ProductRepository repository;

  PostedBloc(this.repository) : super(PostedInitial()) {
    on<LoadPosted>(loadPosted);
  }

  loadPosted(LoadPosted event, emit) async {
    emit(PostedLoading());

    final Result result = await repository.getPostedProducts(
        userId: event.userId, skip: event.skip, limit: event.limit);

    if (result is Success) {
      emit(PostedLoaded((result.value['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList()));
    } else {
      emit(PostedError());
    }
  }
}
