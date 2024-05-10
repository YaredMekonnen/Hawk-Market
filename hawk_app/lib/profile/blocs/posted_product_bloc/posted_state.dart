part of 'posted_bloc.dart';

@immutable
sealed class PostedState {}

final class PostedInitial extends PostedState {}

final class PostedLoading extends PostedState {}

final class PostedLoaded extends PostedState {
  final List<Product> products;

  PostedLoaded(this.products);
}

final class PostedError extends PostedState {
}