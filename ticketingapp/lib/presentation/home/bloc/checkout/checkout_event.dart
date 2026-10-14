part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;
  // tambah checout
  const factory CheckoutEvent.addCheckout(Product product) = _AddCheckout;
  // Hapus data co
  const factory CheckoutEvent.removeCheckout(Product product) = _RemoveCheckout;
}