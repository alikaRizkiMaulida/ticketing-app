// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ticketingapp/data/datasource/auth_remote_datasource.dart';

part 'logout_bloc.freezed.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  LogoutBloc(
    this._authRemoteDatasource,
  ) : super(_Initial()) {
    on<_Logout>((event, emit) async{
      emit(_Loading());
      final result = await _authRemoteDatasource.logout();

      result.fold(
        (error) => emit(_Error(error)),
        (data) => emit(_Success()) 
        );
    });
  }
}
