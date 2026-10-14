// Shared Preferences itu penyimpanan lokal di HP
// Biasanya dipakai untuk menyimpan data kecil
// Contohnya token login, data user, status login, tema aplikasi, dan lain-lain
//
// Sifatnya persistent
// Artinya data tetap ada walaupun aplikasi ditutup
// Data baru hilang kalau:
// - user logout lalu datanya dihapus
// - aplikasi dihapus
// - storage/cache tertentu dibersihkan

import 'package:ticketingapp/data/model/response/auth_response_model.dart';
// Import AuthResponseModel
// AuthResponseModel ini adalah model data untuk hasil login
// Contohnya mungkin berisi token, nama user, email, role, dan data login lainnya
//
// Kenapa perlu di-import?
// Karena di bawah nanti kita memakai AuthResponseModel untuk menyimpan
// dan mengambil data auth

import 'package:shared_preferences/shared_preferences.dart';
// Import package shared_preferences
// Package ini dipakai untuk menyimpan data kecil di penyimpanan lokal HP
//
// Contohnya:
// - menyimpan token login
// - mengecek apakah user sudah login
// - menghapus data login saat logout

class AuthLocalDatasource {
  // Ini adalah class bernama AuthLocalDatasource
  //
  // Auth artinya authentication / login
  // Local artinya lokal, yaitu dari penyimpanan HP
  // Datasource artinya sumber data
  //
  // Jadi AuthLocalDatasource adalah class yang mengurus data login
  // yang disimpan di penyimpanan lokal HP

  Future<void> saveAuthData(AuthResponseModel data) async {
    // Ini adalah fungsi untuk menyimpan data auth / data login
    //
    // Future<void> artinya fungsi ini berjalan secara asynchronous
    // dan tidak mengembalikan nilai apa pun
    //
    // Kenapa pakai async?
    // Karena proses mengambil dan menyimpan data ke SharedPreferences
    // butuh waktu, jadi harus ditunggu
    //
    // AuthResponseModel data artinya fungsi ini butuh data login
    // yang bentuknya AuthResponseModel

    final pref = await SharedPreferences.getInstance();
    // SharedPreferences.getInstance() dipakai untuk mengambil akses
    // ke penyimpanan SharedPreferences di HP
    //
    // Ibaratnya SharedPreferences itu lemari kecil di HP
    // Sebelum menyimpan data, kita harus buka lemarinya dulu
    //
    // await artinya kita menunggu sampai akses SharedPreferences siap
    //
    // Hasilnya disimpan ke variabel pref
    // Nanti pref ini dipakai untuk setString, getString, remove, dan containsKey

    await pref.setString('auth_data', data.toJson());
    // Ini untuk menyimpan data auth ke SharedPreferences
    //
    // setString artinya menyimpan data dalam bentuk String
    //
    // 'auth_data' adalah key atau nama penyimpanannya
    // Ibaratnya nama laci tempat menyimpan data login
    //
    // data.toJson() artinya data AuthResponseModel diubah menjadi String JSON
    //
    // Kenapa harus diubah jadi String?
    // Karena SharedPreferences tidak bisa langsung menyimpan object buatan kita
    // seperti AuthResponseModel
    //
    // SharedPreferences hanya bisa menyimpan data sederhana seperti:
    // String, int, bool, double, dan List<String>
    //
    // Jadi object AuthResponseModel harus diubah dulu menjadi String JSON
    // sebelum disimpan
  }

  Future<void> removeAuthData() async {
    // Ini adalah fungsi untuk menghapus data auth
    //
    // Biasanya dipakai saat user logout
    //
    // Future<void> artinya fungsi ini async
    // dan tidak mengembalikan nilai apa pun

    final pref = await SharedPreferences.getInstance();
    // Ambil akses ke SharedPreferences dulu
    //
    // Kenapa harus getInstance lagi?
    // Karena sebelum menghapus data dari SharedPreferences,
    // kita harus punya akses ke tempat penyimpanannya dulu

    await pref.remove('auth_data');
    // Ini menghapus data yang tersimpan dengan key 'auth_data'
    //
    // Jadi kalau sebelumnya data login disimpan di key 'auth_data',
    // maka saat logout data tersebut dihapus dari HP
    //
    // Setelah ini, biasanya user dianggap sudah tidak login
  }

  Future<AuthResponseModel> getAuthData() async {
    // Ini adalah fungsi untuk mengambil data auth / data login
    //
    // Future<AuthResponseModel> artinya fungsi ini akan mengembalikan
    // data dalam bentuk AuthResponseModel
    //
    // Kenapa Future?
    // Karena proses mengambil data dari SharedPreferences butuh waktu
    // Jadi hasilnya tidak langsung keluar, harus ditunggu

    final pref = await SharedPreferences.getInstance();
    // Ambil akses ke SharedPreferences dulu
    //
    // Ibaratnya buka lemari penyimpanan dulu,
    // baru bisa ambil isi lacinya

    final data = pref.getString('auth_data');
    // Mengambil data String dari SharedPreferences
    // dengan key 'auth_data'
    //
    // Kenapa getString?
    // Karena waktu menyimpan tadi kita pakai setString
    //
    // Jadi pasangannya:
    // setString untuk menyimpan String
    // getString untuk mengambil String
    //
    // Hasilnya disimpan di variabel data
    //
    // data bisa berisi String JSON
    // atau bisa juga null kalau datanya tidak ada

    if (data != null) {
      // Mengecek apakah data auth ada atau tidak
      //
      // Kalau data != null, artinya data login ditemukan
      // Jadi bisa lanjut diubah kembali menjadi object

      return AuthResponseModel.fromJson(data);
      // Ini mengubah data dari String JSON kembali menjadi object AuthResponseModel
      //
      // Waktu disimpan:
      // AuthResponseModel -> String JSON pakai toJson()
      //
      // Waktu diambil:
      // String JSON -> AuthResponseModel pakai fromJson()
      //
      // Jadi fromJson ini kebalikan dari toJson
    } else {
      // Kalau data == null, berarti data auth tidak ditemukan
      // Bisa jadi user belum login
      // Bisa juga user sudah logout dan datanya sudah dihapus

      throw Exception('Data ga ada');
      // Ini melempar error kalau data auth tidak ada
      //
      // Maksudnya aplikasi diberi tahu:
      // "Data login tidak ditemukan"
    }
  }

  Future<bool> isLogin() async {
    // Ini adalah fungsi untuk mengecek apakah user sudah login atau belum
    //
    // Future<bool> artinya fungsi ini mengembalikan nilai boolean
    //
    // Boolean itu cuma punya 2 kemungkinan:
    // true = benar / iya
    // false = salah / tidak
    //
    // Jadi hasil dari fungsi ini:
    // true berarti user sudah login
    // false berarti user belum login

    final pref = await SharedPreferences.getInstance();
    // Ambil akses ke SharedPreferences dulu
    //
    // Kenapa perlu?
    // Karena kita mau mengecek apakah di penyimpanan lokal
    // ada data dengan key 'auth_data' atau tidak

    return pref.containsKey('auth_data');
    // containsKey dipakai untuk mengecek apakah key tertentu ada atau tidak
    //
    // Di sini kita mengecek key 'auth_data'
    //
    // Kalau 'auth_data' ada, hasilnya true
    // Artinya user dianggap sudah login
    //
    // Kalau 'auth_data' tidak ada, hasilnya false
    // Artinya user belum login atau sudah logout
  }
}