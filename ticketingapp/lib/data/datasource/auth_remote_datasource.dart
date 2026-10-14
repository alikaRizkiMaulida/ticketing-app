import 'dart:convert';
// dart:convert dipakai untuk mengubah data JSON
//
// Di kode ini dipakai untuk:
// json.decode(response.body)
//
// Jadi response dari API yang bentuknya teks JSON
// bisa diubah menjadi Map / data yang bisa dibaca Dart

import 'dart:io';
// dart:io dipakai untuk berurusan dengan file dari device
//
// Di kode ini dipakai untuk tipe data File
// File imageFile artinya file gambar yang akan diupload

import 'package:dartz/dartz.dart';
// dartz dipakai untuk memakai Either, Left, dan Right
//
// Either itu seperti hasil yang punya 2 kemungkinan:
// Right = berhasil
// Left = gagal
//
// Jadi daripada langsung throw error,
// kita bisa mengembalikan hasil berhasil atau gagal dengan lebih rapi

import 'package:http/http.dart' as http;
// Package http dipakai untuk request ke API / backend
//
// as http artinya package ini diberi nama pendek "http"
// Jadi nanti bisa dipakai seperti:
// http.post()
// http.MultipartRequest()
// http.Response.fromStream()

import 'package:ticketingapp/core/constants/variable.dart';
// Import file Variable dari project sendiri
//
// Kemungkinan isinya baseUrl API
// Contohnya:
// Variable.baseUrl = "https://domain-api.com"

import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
// Import AuthLocalDatasource
//
// AuthLocalDatasource dipakai untuk mengambil data login
// yang sudah disimpan di local storage / SharedPreferences
//
// Di kode ini dipakai untuk mengambil token saat logout
// dan update profile image

import 'package:ticketingapp/data/model/request/login_request_model.dart';
// Import LoginRequestModel
//
// LoginRequestModel adalah model untuk data yang dikirim saat login
// Contohnya mungkin berisi email dan password

import 'package:ticketingapp/data/model/response/auth_response_model.dart';
// Import AuthResponseModel
//
// AuthResponseModel adalah model untuk data hasil response login
// Contohnya mungkin berisi user dan token

class AuthRemoteDatasource {
  // Ini class AuthRemoteDatasource
  //
  // Remote artinya data dari luar aplikasi, yaitu dari API / server
  //
  // Jadi class ini tugasnya berhubungan dengan backend,
  // seperti login, logout, dan upload foto profile

  Future<Either<String, AuthResponseModel>> login(
      LoginRequestModel data) async {
    // Ini function untuk login
    //
    // LoginRequestModel data adalah data login yang dikirim ke API
    // Misalnya email dan password
    //
    // Future artinya proses ini async / butuh waktu
    // Karena login harus menunggu response dari server
    //
    // Either<String, AuthResponseModel> artinya hasilnya ada 2 kemungkinan:
    //
    // Left(String) = gagal, isinya pesan error dalam bentuk String
    // Right(AuthResponseModel) = berhasil, isinya data login

    final response = await http.post(
      // http.post dipakai untuk mengirim request POST ke API
      //
      // POST biasanya dipakai saat kita ingin mengirim data
      // Contohnya login, register, tambah data, upload, dll
      //
      // await artinya tunggu sampai server memberi response

      Uri.parse('${Variable.baseUrl}/api/login'),
      // Uri.parse dipakai untuk mengubah teks URL menjadi bentuk Uri
      // karena http.post butuh bentuk Uri
      //
      // '${Variable.baseUrl}/api/login'
      // artinya URL login dibuat dari baseUrl + endpoint /api/login
      //
      // Contoh:
      // Variable.baseUrl = "https://api-ticketing.com"
      // maka URL akhirnya:
      // https://api-ticketing.com/api/login

      headers: <String, String>{
        // headers adalah informasi tambahan yang dikirim ke API
        //
        // Bentuknya Map<String, String>
        // Artinya key dan value-nya sama-sama String

        'Content-Type': 'application/json; charset=UTF-8',
        // Content-Type memberi tahu server bahwa data yang dikirim
        // bentuknya JSON

        'Accept': 'application/json',
        // Accept memberi tahu server bahwa aplikasi ingin menerima response
        // dalam bentuk JSON
      },

      body: data.toJson(),
      // body adalah isi data yang dikirim ke API
      //
      // data.toJson() artinya data login diubah menjadi JSON
      //
      // Kenapa harus diubah ke JSON?
      // Karena API biasanya menerima data dalam bentuk JSON
      //
      // Contoh data login:
      // email: user@gmail.com
      // password: 123456
      //
      // Akan dikirim dalam bentuk JSON ke server
    );

    if (response.statusCode == 200) {
      // response.statusCode adalah kode status dari server
      //
      // 200 biasanya artinya berhasil
      //
      // Jadi kalau statusCode 200,
      // berarti login berhasil

      return Right(AuthResponseModel.fromJson(response.body));
      // Right artinya hasil berhasil
      //
      // response.body adalah isi response dari server
      // bentuknya biasanya String JSON
      //
      // AuthResponseModel.fromJson(response.body)
      // artinya response JSON dari server diubah menjadi object AuthResponseModel
      //
      // Jadi data login dari API bisa dipakai di aplikasi
    } else {
      // Kalau statusCode bukan 200,
      // berarti login gagal

      return Left(response.body);
      // Left artinya hasil gagal
      //
      // response.body dikembalikan sebagai pesan error
      // supaya nanti bisa ditampilkan atau diproses
    }
  }

  Future<Either<String, String>> logout() async {
    // Ini function untuk logout
    //
    // Future karena proses logout butuh request ke server
    //
    // Either<String, String> artinya hasilnya:
    //
    // Left(String) = gagal, isinya pesan error
    // Right(String) = berhasil, isinya pesan sukses

    final authData = await AuthLocalDatasource().getAuthData();
    // Mengambil data auth dari penyimpanan lokal
    //
    // Kenapa perlu ambil authData?
    // Karena untuk logout biasanya API butuh token
    //
    // Token itu seperti kartu akses
    // Supaya server tahu user mana yang sedang logout

    final response = await http.post(
      // Mengirim request POST ke API logout

      Uri.parse('${Variable.baseUrl}/api/logout'),
      // URL API logout
      //
      // Dibuat dari baseUrl + /api/logout

      headers: <String, String>{
        'Authorization': 'Bearer ${authData.token}',
        // Authorization dipakai untuk mengirim token ke server
        //
        // Bearer ${authData.token}
        // artinya token dikirim dengan format Bearer Token
        //
        // Contoh:
        // Authorization: Bearer abc123

        'Content-Type': 'application/json; charset=UTF-8',
        // Memberi tahu server bahwa request memakai format JSON

        'Accept': 'application/json',
        // Memberi tahu server bahwa aplikasi ingin response JSON
      },
    );

    if (response.statusCode == 200) {
      // Kalau statusCode 200,
      // berarti logout berhasil

      return Right('Logout berhasil');
      // Mengembalikan hasil berhasil
      // Isinya teks "Logout berhasil"
    } else {
      // Kalau statusCode bukan 200,
      // berarti logout gagal

      return Left(response.body);
      // Mengembalikan hasil gagal
      // Isinya response error dari server
    }
  }

  Future<Either<String, AuthResponseModel>> updateProfileImage(
      File imageFile) async {
    // Ini function untuk update / upload foto profile
    //
    // File imageFile adalah file gambar yang mau dikirim ke API
    //
    // Hasilnya Either:
    //
    // Left(String) = gagal, isinya pesan error
    // Right(AuthResponseModel) = berhasil, isinya data auth terbaru

    try {
      // try dipakai untuk mencoba menjalankan kode yang berisiko error
      //
      // Contohnya:
      // - koneksi internet bermasalah
      // - file tidak ditemukan
      // - API error
      // - token tidak ada
      //
      // Kalau ada error, nanti akan ditangkap oleh catch

      final authData = await AuthLocalDatasource().getAuthData();
      // Mengambil data auth dari penyimpanan lokal
      //
      // Dibutuhkan untuk mengambil token
      // Karena update profile image biasanya harus login dulu

      final url =
          Uri.parse('${Variable.baseUrl}/api/update-profile-image');
      // Membuat URL endpoint untuk upload foto profile
      //
      // Uri.parse mengubah teks URL menjadi Uri
      // supaya bisa dipakai oleh request HTTP

      var request = http.MultipartRequest('POST', url);
      // MultipartRequest dipakai untuk mengirim data berbentuk file
      //
      // Kenapa tidak pakai http.post biasa?
      // Karena http.post biasa lebih cocok untuk data teks / JSON
      //
      // Kalau mau upload gambar, PDF, atau file lain,
      // biasanya pakai MultipartRequest
      //
      // 'POST' artinya method request-nya POST
      // url adalah alamat API tujuan

      request.headers.addAll(
        {
          // headers tambahan untuk request upload

          'Authorization': 'Bearer ${authData.token}',
          // Mengirim token ke server
          //
          // Token ini membuktikan bahwa user sudah login
          // dan punya izin untuk update profile image

          'Content-Type': 'application/json; charset=UTF-8',
          // Catatan:
          // Untuk MultipartRequest, biasanya Content-Type tidak perlu ditulis manual
          // karena multipart punya Content-Type sendiri
          //
          // Kalau ditulis manual application/json,
          // kadang bisa bikin upload file bermasalah
          //
          // Biasanya cukup pakai Authorization dan Accept saja

          'Accept': 'application/json',
          // Memberi tahu server bahwa aplikasi ingin menerima response JSON
        },
      );

      var multipartFile =
          await http.MultipartFile.fromPath('image', imageFile.path);
      // Membuat file gambar menjadi MultipartFile
      //
      // 'image' adalah nama field yang dikirim ke API
      // Nama ini harus sesuai dengan yang diminta backend
      //
      // imageFile.path adalah lokasi file gambar di HP
      //
      // Contoh:
      // /storage/emulated/0/Download/foto.jpg
      //
      // await dipakai karena proses membaca file butuh waktu

      request.files.add(multipartFile);
      // Menambahkan file gambar ke request
      //
      // Jadi request ini sekarang membawa file dengan field bernama 'image'

      final streamedResponse = await request.send();
      // Mengirim request upload ke server
      //
      // Hasil dari request.send() bentuknya StreamedResponse
      //
      // StreamedResponse itu response yang datang secara streaming
      // Biasanya dipakai untuk request multipart / upload file

      final response = await http.Response.fromStream(streamedResponse);
      // Mengubah StreamedResponse menjadi Response biasa
      //
      // Kenapa diubah?
      // Supaya kita lebih mudah membaca:
      // response.statusCode
      // response.body

      if (response.statusCode == 200) {
        // Kalau statusCode 200,
        // berarti upload foto berhasil

        final jsonResponse = json.decode(response.body);
        // Mengubah response.body dari String JSON menjadi Map
        //
        // Contoh response.body:
        // {"data": {"name": "Dila", "image": "foto.jpg"}}
        //
        // Setelah json.decode, datanya bisa diakses seperti:
        // jsonResponse['data']

        final authResponse = AuthResponseModel.fromMap({
          // Membuat AuthResponseModel baru dari Map
          //
          // Kenapa dibuat baru?
          // Karena response update profile kemungkinan hanya mengirim data user,
          // bukan token baru
          //
          // Jadi token lama tetap dipakai dari authData.token

          'user': jsonResponse['data'],
          // Mengambil data user terbaru dari response API
          //
          // Biasanya data ini berisi user yang fotonya sudah berubah

          'token': authData.token,
          // Token tetap memakai token lama
          // Karena API update profile image biasanya tidak mengirim token baru
        });

        return Right(authResponse);
        // Mengembalikan hasil berhasil
        //
        // Isinya AuthResponseModel terbaru
        // yang berisi user terbaru dan token lama
      } else {
        // Kalau statusCode bukan 200,
        // berarti upload gambar gagal

        print('Gagal mengunggah gambar: ${response.statusCode}');
        // Menampilkan statusCode error di debug console
        //
        // Ini membantu developer tahu error-nya status berapa
        // Contoh 400, 401, 422, 500

        print('Response body: ${response.body}');
        // Menampilkan isi response error dari server
        //
        // Berguna untuk debugging

        return Left(response.body);
        // Mengembalikan hasil gagal
        // Isinya response body dari server
      }
    } catch (e) {
      // catch akan menangkap error yang terjadi di dalam try
      //
      // Misalnya:
      // - internet error
      // - token tidak ada
      // - file gambar error
      // - parsing JSON gagal

      print('Error: $e');
      // Menampilkan error ke debug console

      return Left(e.toString());
      // Mengembalikan hasil gagal
      //
      // e.toString() mengubah error menjadi teks
      // supaya bisa dikirim sebagai Left
    }
  }
}