part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  // Add Payment Method
  const factory OrderEvent.addPaymentMethod(
    String paymentMethod,
    List<OrderItem> orders,
  ) = _AddPaymentMethod;

  // Tambah nominal Payment
  const factory OrderEvent.addNominalPayment(
    int nominalPayment,
  ) = _AddNominalPayment;
}
