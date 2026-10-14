import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:ticketingapp/core/constants/variable.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:ticketingapp/data/model/response/like_response_model.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';

class LikeRemoteDatasource {
  Future<Either<String, LikeResponseModel>> toggleLike(int productId) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/api-like'), // Sesuaikan dengan route
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode({
        'product_id': productId,
      }),
    );

    // Tambahkan print untuk debug
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Right(LikeResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, List<Product>>> getLikedProducts() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/api-liked-products'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      print('Get Liked Products Status: ${response.statusCode}');
      print('Get Liked Products Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          final products = data.map((e) => Product.fromMap(e)).toList();
          print('Parsed ${products.length} products');
          return Right(products);
        } else {
          return const Right([]);
        }
      } else {
        return Left('Failed to load liked products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLikedProducts: $e');
      return Left(e.toString());
    }
  }
}
