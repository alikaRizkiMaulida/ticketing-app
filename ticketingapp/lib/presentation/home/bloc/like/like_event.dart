part of 'like_bloc.dart';

@freezed
class LikeEvent with _$LikeEvent {
  const factory LikeEvent.started() = _Started;
  const factory LikeEvent.toggleLike(int productId) = _ToggleLike;
  const factory LikeEvent.getLikedProducts() = _GetLikedProducts;
}