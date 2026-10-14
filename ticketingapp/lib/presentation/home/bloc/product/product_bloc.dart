// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticketingapp/data/datasource/product_local_datasource.dart';

import 'package:ticketingapp/data/datasource/product_remote_datasource.dart';
import 'package:ticketingapp/data/model/request/create_ticker_request_model.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  final ProductLocalDatasource productLocalDatasource;
  ProductBloc(
    this.productRemoteDatasource,
    this.productLocalDatasource,
  ) : super(_Initial()) {
    List<Product> products = [];

    on<_GetProducts>((event, emit) async {
      emit(_Loading());
      final response = await productRemoteDatasource.getProducts();

      response.fold((error) => emit(_Error(error)),
          (data) => emit(_Success(data.data ?? [])));
    });

    on<_SyncProduct>((event, emit) async {
      // Ini untuk ngecek status internet
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      // Kalau ga ada koneksi, maka keliat Eror
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(_Error('No internet connection'));
      } else {
        emit(_Loading());
        // Ambil data produk dari API
        final response = await productRemoteDatasource.getProducts();
        // hapus dulu data yang ada di lokal karena kita pengen update data jadi yang baru
        productLocalDatasource.removeAllProduct();
        // Simpan data yang baru ke dalam database local
        productLocalDatasource.insertAllProduct(
            // Jadi kalau data ga ada atau error atau gagal ambil data
            // Maka product diisi dengan daftar kosong
            response.getOrElse(() => ProductResponseModel(data: [])).data ??
                []);
        products =
            response.getOrElse(() => ProductResponseModel(data: [])).data ?? [];
        emit(_Success(products));
      }
    });

    on<_GetProductsLocal>((event, emit) async {
      emit(_Loading());
      final localProducts = await productLocalDatasource.getAllProducts();
      products = localProducts;
      emit(_Success(products));
    });

    // Create Ticket
    on<_CreateTicket>((event, emit) async {
      emit(_Loading());

      final requestData = CreateTicketRequestModel(
        name: event.model.name,
        price: event.model.price,
        stock: event.model.stock,
        categoryId: event.model.categoryId,
        criteria: event.model.criteria!.toLowerCase(),
      );

      final response = await productRemoteDatasource.createTicket(requestData);

      response.fold(
        (error) => emit(_Error(error)),
        (data) {
          products.add(data.data);
          emit(_Success(products));
        },
      );
    });

    on<_UpdateTicket>((event, emit) async {
      emit(_Loading());

      // Pake kode ini supaya data yang dikirim ke API sesuai dengan format yang diminta
      // Jadi data yang mau dikirim ke API tuh dikemas di wadah yang namanya requestData
      final requestData = CreateTicketRequestModel(
          name: event.model.name,
          price: event.model.price,
          stock: event.model.stock);

      final response = await productRemoteDatasource.updateTicket(
          requestData, event.model.id!);

      response.fold((error) => emit(_Error(error)), 
      (r) {
        // Kenapa lebih baik pake map()
        // karena map membuat list baru berdasarkan list lama tapi dengan nilai yang sudah di update
        // lebih aman karena tidak mengubah list asli
        // Membantu mencari nilai atau data berdasarkan id
        final updateProduct = products.map((product) {
          // cek apakah id produk yang mau di update sesuai dengan id produk yang ada di server
          if (product.id == event.model.id) {
            // jika iya, maka update data produk
            return r.data;
          }
          // jika ga, maka tetap kasih data produk yang lama
          // fungsinya untuk mempertahankan data produk yang tidak perlu di update
          return product;
          // Ubah hasil map() ke List lagi
        }).toList();

        // Simpan data list produk yang baru
        products = updateProduct;
        // kirim state sukses ke UI dengan bawa data list produk yang baru
        emit(_Success(updateProduct));
      });
    });

    on<_DeleteTicket>((event, emit) async {
      emit(_Loading());

      final response = await productRemoteDatasource.deleteTicket(event.id);

      response.fold((error) => emit(_Error(error)), (r) {
        products.removeWhere((product) => product.id == event.id);
        emit(_Success(products));
      });
    });
  }
}
