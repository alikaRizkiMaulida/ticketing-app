// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ticketingapp/data/datasource/product_local_datasource.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_model.dart';

part 'history_bloc.freezed.dart';
part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  ProductLocalDatasource productLocalDatasource;
  HistoryBloc(
    this.productLocalDatasource,
  ) : super(_Initial()) {
    on<HistoryEvent>((event, emit) async {
      emit(_Loading());
      final histories = await productLocalDatasource.getAllOrder();
      emit(_Success(histories));
    });
  }
}
