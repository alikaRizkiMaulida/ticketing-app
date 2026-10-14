import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticketingapp/data/datasource/like_remote_datasource.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';

part 'like_event.dart';
part 'like_state.dart';
part 'like_bloc.freezed.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRemoteDatasource _likeRemoteDatasource;

  LikeBloc(this._likeRemoteDatasource) : super(const _Initial()) {
    on<_ToggleLike>((event, emit) async {
      final response = await _likeRemoteDatasource.toggleLike(event.productId);
      response.fold(
        (error) => emit(LikeState.error(error)),
        (data) {
          emit(LikeState.success(data.message));

          add(const LikeEvent.getLikedProducts());
        },
      );
    });

    on<_GetLikedProducts>((event, emit) async {
      if (state is _Loading) return;

      emit(const LikeState.loading());
      final response = await _likeRemoteDatasource.getLikedProducts();

      response.fold(
        (error) => emit(LikeState.error(error)),
        (products) => emit(LikeState.successGetLikedProducts(products)),
      );
    });
  }
}
