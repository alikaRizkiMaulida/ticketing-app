import 'package:flutter/material.dart';
// Import material.dart dari Flutter
// Dipakai untuk widget bawaan Flutter
// Contohnya Scaffold, FutureBuilder, Stack, Column, Spacer,
// Padding, Center, Text, CircularProgressIndicator, dan lain-lain

import 'package:ticketingapp/core/assets/assets.dart';
// Import assets dari project
// Dipakai untuk menampilkan gambar/logo
// Contohnya Assets.images.logoBlue.image()

import 'package:ticketingapp/core/core.dart';
// Import core dari project
// Kemungkinan berisi AppColors, SpaceHeight,
// dan helper lain yang sering dipakai di aplikasi

import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
// Import AuthLocalDatasource
// Dipakai untuk mengecek apakah user sudah login atau belum
//
// Di kode ini yang dipakai adalah:
// AuthLocalDatasource().isLogin()

import 'package:ticketingapp/presentation/auth/pages/login_page.dart';
// Import LoginPage
// Kalau user belum login, nanti akan diarahkan ke halaman ini

import 'package:ticketingapp/presentation/home/pages/main_page.dart';
// Import MainPage
// Kalau user sudah login, nanti akan diarahkan ke halaman utama ini

class SplashScreen extends StatefulWidget {
  // Ini adalah halaman SplashScreen
  //
  // SplashScreen adalah halaman awal yang muncul saat aplikasi baru dibuka
  // Biasanya isinya logo aplikasi dan loading sebentar
  //
  // Di kode ini SplashScreen juga dipakai untuk mengecek:
  // user sudah login atau belum

  const SplashScreen({super.key});
  // Constructor SplashScreen
  // super.key dipakai sebagai identitas widget di Flutter

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  // createState dipakai untuk menghubungkan StatefulWidget
  // dengan class State-nya
  //
  // State-nya bernama _SplashScreenState
}

class _SplashScreenState extends State<SplashScreen> {
  // Ini class State dari SplashScreen
  //
  // Sebenarnya di kode ini belum ada setState
  // Tapi tetap boleh pakai StatefulWidget
  //
  // Bisa juga dibuat StatelessWidget,
  // karena proses async-nya sudah ditangani oleh FutureBuilder

  @override
  Widget build(BuildContext context) {
    // build adalah fungsi untuk membuat tampilan halaman
    // context adalah informasi posisi widget di aplikasi

    return Scaffold(
      // Scaffold adalah kerangka utama halaman Flutter

      body: FutureBuilder(
        // FutureBuilder adalah widget untuk menunggu proses async
        //
        // Bahasa gampang:
        // FutureBuilder itu seperti penjaga yang nunggu jawaban
        //
        // Kalau prosesnya belum selesai:
        // tampilkan loading
        //
        // Kalau prosesnya sudah selesai:
        // tampilkan halaman sesuai hasilnya
        //
        // Di kode ini FutureBuilder dipakai untuk menunggu pengecekan login

        future: Future.delayed(
          // Future.delayed artinya menjalankan proses setelah delay / jeda waktu
          //
          // Di sini aplikasinya sengaja menunggu 2 detik
          // supaya splash screen terlihat dulu

          Duration(seconds: 2),
          // Lama delay-nya 2 detik

          () => AuthLocalDatasource().isLogin(),
          // Setelah 2 detik, jalankan fungsi isLogin()
          //
          // AuthLocalDatasource().isLogin()
          // dipakai untuk mengecek apakah data login masih ada
          // di SharedPreferences / penyimpanan lokal HP
          //
          // Hasilnya adalah boolean:
          // true  = user sudah login
          // false = user belum login
        ),

        builder: (context, snapshot) {
          // builder adalah bagian yang membangun UI
          // berdasarkan kondisi Future
          //
          // context adalah informasi posisi widget
          //
          // snapshot adalah objek yang berisi hasil dari Future
          //
          // Bahasa gampang:
          // snapshot itu seperti laporan hasil pengecekan
          //
          // Snapshot bisa memberi tahu:
          // - prosesnya masih loading atau sudah selesai
          // - datanya apa
          // - ada error atau tidak

          if (snapshot.connectionState == ConnectionState.done) {
            // snapshot.connectionState dipakai untuk mengecek status Future
            //
            // ConnectionState.done artinya proses Future sudah selesai
            //
            // Jadi pengecekan login sudah selesai

            if (snapshot.data == true) {
              // snapshot.data adalah hasil dari Future
              //
              // Karena future-nya menjalankan isLogin(),
              // maka snapshot.data berisi true atau false
              //
              // Kalau snapshot.data == true,
              // artinya user sudah pernah login

              return MainPage();
              // Kalau user sudah login,
              // tampilkan MainPage / halaman utama aplikasi
            } else {
              // Kalau snapshot.data bukan true,
              // berarti user belum login

              return LoginPage();
              // Kalau belum login,
              // tampilkan halaman LoginPage
            }
          }

          return Stack(
            // Kalau Future belum selesai,
            // maka tampilkan tampilan splash/loading ini
            //
            // Stack dipakai untuk menumpuk widget
            // Tapi di kode ini sebenarnya Stack hanya punya 1 child,
            // jadi Stack belum terlalu diperlukan
            //
            // Bisa saja langsung return Column(...)

            children: [
              Column(
                // Column menyusun widget dari atas ke bawah

                children: [
                  Spacer(),
                  // Spacer memberi ruang kosong fleksibel
                  //
                  // Di sini dipakai supaya logo bisa terdorong ke bagian tengah

                  Padding(
                    // Padding memberi jarak di sekitar logo

                    padding: EdgeInsets.all(80),
                    // Jarak di semua sisi sebesar 80

                    child: Center(
                      // Center membuat logo berada di tengah

                      child: Assets.images.logoBlue.image(),
                      // Menampilkan logo dari assets project
                    ),
                  ),

                  Spacer(),
                  // Spacer kedua memberi ruang kosong lagi
                  //
                  // Dengan Spacer di atas dan bawah,
                  // posisi logo dan teks jadi lebih tertata

                  Text(
                    'Ticketing App',
                    // Menampilkan teks nama aplikasi

                    style: TextStyle(
                      fontSize: 24,
                      // Ukuran teks 24

                      fontWeight: FontWeight.bold,
                      // Teks dibuat tebal
                    ),
                  ),

                  Center(
                    // Center membuat loading berada di tengah horizontal

                    child: CircularProgressIndicator(
                      // CircularProgressIndicator adalah loading muter bawaan Flutter

                      color: AppColors.primary,
                      // Warna loading memakai warna utama aplikasi
                    ),
                  ),

                  SpaceHeight(40),
                  // Memberi jarak bawah sebesar 40
                  //
                  // SpaceHeight kemungkinan widget custom dari project
                  // Mirip seperti SizedBox(height: 40)
                ],
              )
            ],
          );
        },
      ),
    );
  }
}