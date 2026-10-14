import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ticketingapp/core/constants/variable.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:http/http.dart' as http;

class ImageRemoteDatasources {
  Future<Either<String, String>> updateProfileImage(
      File imageFile) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse('${Variable.baseUrl}/api/update-profile-image');

      //  Membuat request multipart untuk mengirim file gambar
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer ${authData.token}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      });

      var multipartFile =
          await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(multipartFile);

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Right('Sukses upload gambar');
      } else {
        return Left(responseData);
      }
    } catch (e) {
      print('Error: $e');
      return Left(e.toString());
    }
  }
}
