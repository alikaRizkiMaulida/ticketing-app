import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ticketingapp/data/datasource/order_remote_datasource.dart';
import 'package:ticketingapp/data/datasource/product_local_datasource.dart';
import 'package:ticketingapp/data/model/request/order_request_model.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(
    this.orderRemoteDatasource,
  ) : super(_Initial()) {
    on<_SyncOrder>((event, emit) async {
      emit(_Loading());
      try {
        final orderIsSyncFalse = await ProductLocalDatasource.instance.getOrdersIsSyncFalse();
        print('Found ${orderIsSyncFalse.length} orders to sync');
        
        bool hasError = false;

        for (final order in orderIsSyncFalse) {
          try {
            print('Syncing order ID: ${order.id}');
            final orderItems = await ProductLocalDatasource.instance.getOrderItemsByIdOrder(order.id!);
            print('Order items found: ${orderItems.length}');
            
            final orderRequest = OrderRequestModel(
              cashierName: order.cashierName,
              paymentAmount: order.nominalPayment,
              transactionTime: order.transactionTime,
              cashierId: order.cashierId,
              totalPrice: order.totalPrice,
              totalItem: order.totalQuantity,
              paymentMethod: order.paymentMethod,
              orderItems: orderItems,
            );

            print('Sending order request: ${orderRequest.toJson()}');
            final response = await orderRemoteDatasource.sendOrder(orderRequest);
            print('Server response: $response');

            if (response) {
              print('Successfully synced order ID: ${order.id}');
              await ProductLocalDatasource.instance.updateOrderIsSync(order.id!);
              print('Updated local sync status for order ID: ${order.id}');
            } else {
              print('Failed to sync order ID: ${order.id}');
              hasError = true;
            }
          } catch (e, stackTrace) {
            print('Error syncing order ID: ${order.id}');
            print('Error details: $e');
            print('Stack trace: $stackTrace');
            hasError = true;
          }
        }

        if (hasError) {
          emit(_Error('Beberapa order gagal disinkronkan. Cek log untuk detail.'));
        } else {
          emit(_Success());
        }
      } catch (e, stackTrace) {
        print('Fatal error during sync process: $e');
        print('Stack trace: $stackTrace');
        emit(_Error('Error: $e'));
      }
    });
  }
}
