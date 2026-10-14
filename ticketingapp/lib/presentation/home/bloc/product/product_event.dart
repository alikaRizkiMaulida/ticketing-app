part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.started() = _Started;
  const factory ProductEvent.getProducts() = _GetProducts;
  const factory ProductEvent.syncProduct() = _SyncProduct;
  const factory ProductEvent.getLocalProducts() = _GetProductsLocal; 
  // tambah tiket\
  const factory ProductEvent.createTicket(Product model) = _CreateTicket;
  const factory ProductEvent.updateTicket(Product model) = _UpdateTicket;
  const factory ProductEvent.deleteTicket(int id) = _DeleteTicket;
}