import 'package:dartz/dartz.dart';
import 'package:ticketingapp/core/constants/variable.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:ticketingapp/data/model/request/create_ticker_request_model.dart';
import 'package:ticketingapp/data/model/response/create_ticket_response_model.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/api-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        });

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // EndPoint create produk / create tiket
  Future<Either<String, CreateTicketResponseModel>> createTicket(
      CreateTicketRequestModel model) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response =
        await http.post(Uri.parse('${Variable.baseUrl}/api/api-product'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${authData.token}',
            },
            body: model.toJson());

    if (response.statusCode == 200) {
      return Right(CreateTicketResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // end point buat update
  Future<Either<String, CreateTicketResponseModel>> updateTicket(
      CreateTicketRequestModel requestModel, int id) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    // Patch ini bisa kalau mau update sebagian data aja
    // Put => mengganti seluruh data => semua field harus dikirim kalau ga ya nilainya null
    final response = await http.patch(
        Uri.parse('${Variable.baseUrl}/api/api-product/$id'),
        headers: headers,
        body: requestModel.toJson());

    if (response.statusCode == 200) {
      return Right(CreateTicketResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  // delete ticket
  Future<Either<String, String>> deleteTicket(int id) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final response = await http.delete(
      Uri.parse('${Variable.baseUrl}/api/api-product/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Right('Sukses hapus data');
    } else {
      return Left(response.body);
    }
  }
}


// Saat ngirim data baru atau memperbarui data : post, patch, put berarti butuh body
// Kalau get, delete cukup endpoint dan header