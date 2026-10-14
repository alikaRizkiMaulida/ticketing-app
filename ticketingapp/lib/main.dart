import 'package:flutter/material.dart';
import 'package:ticketingapp/data/datasource/auth_remote_datasource.dart';
import 'package:ticketingapp/data/datasource/category_remote_datasource.dart';
import 'package:ticketingapp/data/datasource/like_remote_datasource.dart';
import 'package:ticketingapp/data/datasource/order_remote_datasource.dart';
import 'package:ticketingapp/data/datasource/product_local_datasource.dart';
import 'package:ticketingapp/data/datasource/product_remote_datasource.dart';
import 'package:ticketingapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:ticketingapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:ticketingapp/presentation/auth/pages/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/category/category_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/history/history_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/like/like_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/order/order_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/sync_order/sync_order_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
              ProductRemoteDatasource(), ProductLocalDatasource.instance)
            ..add(ProductEvent.syncProduct()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LikeBloc(LikeRemoteDatasource()),
        ),
        BlocProvider(
            create: (context) => CategoryBloc(CategoryRemoteDatasource())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
