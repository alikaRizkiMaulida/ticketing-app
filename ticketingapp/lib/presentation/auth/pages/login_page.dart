import 'package:flutter/material.dart';
// Import material.dart dari Flutter
// Dipakai untuk widget bawaan Flutter
// Contohnya Scaffold, Stack, SizedBox, Center, Align, Padding, Column,
// Text, SnackBar, CircularProgressIndicator, dan lain-lain

import 'package:flutter_bloc/flutter_bloc.dart';
// Import flutter_bloc
// Ini package untuk memakai BLoC di Flutter
//
// Dari sini kita bisa pakai:
// - BlocListener
// - BlocBuilder
// - context.read<LoginBloc>()
//
// BLoC itu dipakai untuk memisahkan logic dari tampilan
// Jadi halaman LoginPage fokus ke UI,
// sedangkan proses login diurus oleh LoginBloc

import 'package:ticketingapp/core/assets/assets.dart';
// Import assets dari project
// Dipakai untuk menampilkan gambar/icon
// Contohnya Assets.images.logoBlue.image()

import 'package:ticketingapp/core/components/components.dart';
// Import components dari project
// Kemungkinan berisi widget custom seperti CustomTextField dan Button

import 'package:ticketingapp/core/constants/colors.dart';
// Import warna dari project
// Contohnya AppColors.primary dan AppColors.white

import 'package:ticketingapp/core/core.dart';
// Import core dari project
// Kemungkinan berisi helper seperti SpaceHeight,
// context.pushReplacement, dan extension lain

import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
// Import AuthLocalDatasource
// Dipakai untuk menyimpan data login ke penyimpanan lokal HP
// Contohnya token dan data user

import 'package:ticketingapp/presentation/home/pages/main_page.dart';
// Import MainPage
// Setelah login berhasil, user akan diarahkan ke MainPage

import 'package:ticketingapp/presentation/auth/bloc/login/login_bloc.dart';
// Import LoginBloc
// Ini berisi logic BLoC untuk login
//
// Biasanya di dalam login_bloc.dart ada:
// - LoginBloc
// - LoginEvent
// - LoginState
//
// LoginEvent = perintah yang dikirim dari UI
// LoginState = keadaan yang dikirim balik dari BLoC ke UI
// LoginBloc = mesin yang memproses event menjadi state

class LoginPage extends StatelessWidget {
  // Ini halaman login
  //
  // Pakai StatelessWidget karena di kode ini tidak memakai setState
  // Untuk perubahan proses login, kode ini memakai BLoC

  const LoginPage({super.key});
  // Constructor LoginPage
  // super.key dipakai sebagai identitas widget di Flutter

  @override
  Widget build(BuildContext context) {
    // build adalah fungsi untuk membuat tampilan halaman
    // context adalah informasi posisi widget di aplikasi

    final emailController = TextEditingController();
    // Controller untuk input email
    // Dipakai untuk mengambil teks yang diketik user di field email
    //
    // Nanti emailnya diambil lewat:
    // emailController.text

    final passwordController = TextEditingController();
    // Controller untuk input password
    // Dipakai untuk mengambil teks password yang diketik user
    //
    // Nanti passwordnya diambil lewat:
    // passwordController.text
    //
    // Catatan:
    // Karena controller dibuat di dalam build pada StatelessWidget,
    // ini kurang ideal untuk form yang serius
    // Lebih rapi kalau LoginPage dibuat StatefulWidget
    // lalu controller di-dispose

    return Scaffold(
      // Scaffold adalah kerangka utama halaman Flutter

      backgroundColor: AppColors.primary,
      // Warna background halaman adalah warna utama aplikasi

      body: Stack(
        // Stack dipakai untuk menumpuk widget
        //
        // Di sini ada 2 bagian utama:
        // 1. Logo di bagian atas
        // 2. Form login putih di bagian bawah

        children: [
          SizedBox(
            // SizedBox ini memberi area dengan tinggi tertentu

            height: 260.0,
            // Tingginya 260

            child: Center(
              // Center membuat logo berada di tengah area SizedBox

              child: Assets.images.logoBlue.image(height: 200),
              // Menampilkan gambar logo dari assets
              // Tinggi gambarnya 200
            ),
          ),

          Align(
            // Align dipakai untuk mengatur posisi widget

            alignment: Alignment.bottomCenter,
            // Form login diletakkan di bawah tengah layar

            child: SingleChildScrollView(
              // SingleChildScrollView membuat form bisa discroll
              // Berguna kalau layar kecil atau keyboard muncul

              child: ClipRRect(
                // ClipRRect dipakai untuk memotong bentuk widget
                // supaya sudutnya bisa melengkung

                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20.0)),
                // Membuat sudut atas kiri dan atas kanan form menjadi melengkung 20

                child: ColoredBox(
                  // ColoredBox memberi warna background

                  color: AppColors.white,
                  // Warna form adalah putih

                  child: Padding(
                    // Padding memberi jarak isi form dari pinggir

                    padding: EdgeInsets.symmetric(
                      horizontal: 28.0,
                      // Jarak kiri dan kanan 28

                      vertical: 44.0,
                      // Jarak atas dan bawah 44
                    ),

                    child: Column(
                      // Column menyusun isi form dari atas ke bawah

                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Isi Column dibuat rata kiri

                      children: [
                        CustomTextField(
                          // CustomTextField adalah input custom dari project

                          controller: emailController,
                          // Input email dikontrol oleh emailController
                          // Jadi teks email bisa diambil nanti

                          label: 'Email Address',
                          // Label input adalah Email Address
                        ),

                        const SpaceHeight(36.0),
                        // Memberi jarak tinggi 36 antara input email dan password

                        CustomTextField(
                          // Input password

                          controller: passwordController,
                          // Input password dikontrol oleh passwordController

                          obscureText: true,
                          // obscureText true artinya teks password disembunyikan
                          // Biasanya jadi titik-titik

                          label: 'Password',
                          // Label input adalah Password
                        ),

                        const SpaceHeight(80.0),
                        // Memberi jarak tinggi 80 sebelum tombol login

                        BlocListener<LoginBloc, LoginState>(
                          // BlocListener itu pendengar state dari BLoC
                          //
                          // Bahasa gampangnya:
                          // BlocListener itu seperti penjaga pintu
                          // Dia tidak menggambar UI
                          // Dia cuma mendengar:
                          // "Login berhasil nih"
                          // atau
                          // "Login gagal nih"
                          //
                          // Biasanya BlocListener dipakai untuk aksi sekali jalan,
                          // misalnya:
                          // - pindah halaman
                          // - tampilkan snackbar
                          // - tampilkan dialog
                          // - simpan token
                          //
                          // Di kode ini, BlocListener dipakai untuk:
                          // - menyimpan data login saat sukses
                          // - pindah ke MainPage saat sukses
                          // - menampilkan snackbar saat error

                          listener: (context, state) {
                            // listener ini akan jalan setiap LoginState berubah
                            //
                            // state adalah keadaan terbaru dari LoginBloc
                            //
                            // Contoh state:
                            // - loading
                            // - success
                            // - error

                            state.maybeWhen(
                                // maybeWhen dipakai untuk mengecek state tertentu
                                //
                                // Bahasa gampang:
                                // "Kalau state-nya success, lakukan ini"
                                // "Kalau state-nya error, lakukan itu"
                                // "Kalau state lainnya, abaikan saja"
                                //
                                // maybeWhen biasanya muncul kalau state dibuat pakai freezed

                                orElse: () {},
                                // orElse wajib ada di maybeWhen
                                //
                                // Artinya:
                                // Kalau state bukan success dan bukan error,
                                // tidak usah melakukan apa-apa

                                success: (data) async {
                                  // Bagian ini jalan kalau login berhasil
                                  //
                                  // data adalah data hasil login dari API
                                  // Bentuknya kemungkinan AuthResponseModel
                                  //
                                  // Biasanya data berisi token dan data user

                                  await AuthLocalDatasource()
                                      .saveAuthData(data);
                                  // Menyimpan data login ke penyimpanan lokal HP
                                  //
                                  // Kenapa disimpan?
                                  // Supaya user tidak perlu login ulang
                                  // saat aplikasi ditutup lalu dibuka lagi

                                  context.pushReplacement(const MainPage());
                                  // Pindah ke MainPage
                                  //
                                  // pushReplacement artinya halaman login diganti
                                  // dengan MainPage
                                  //
                                  // Jadi user tidak bisa balik ke LoginPage
                                  // hanya dengan tombol back
                                },

                                error: (error) {
                                  // Bagian ini jalan kalau login gagal
                                  //
                                  // error adalah pesan error dari LoginBloc
                                  // Misalnya email salah, password salah, atau server error

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    // SnackBar adalah pesan kecil yang muncul di bawah layar

                                    content: Text(error),
                                    // Isi snackbar adalah pesan error

                                    backgroundColor: Colors.red,
                                    // Warna snackbar merah
                                    // Supaya user tahu ini pesan gagal/error
                                  ));
                                });
                          },

                          child: BlocBuilder<LoginBloc, LoginState>(
                            // BlocBuilder itu pembangun UI berdasarkan state BLoC
                            //
                            // Bahasa gampang:
                            // BlocBuilder itu bagian yang menggambar ulang tampilan
                            // saat state berubah
                            //
                            // Di kode ini, BlocBuilder dipakai untuk mengganti:
                            //
                            // State biasa  -> tampil tombol Login
                            // State loading -> tampil loading muter
                            //
                            // Jadi kalau sedang proses login,
                            // tombol Login diganti jadi CircularProgressIndicator

                            builder: (context, state) {
                              // builder ini akan jalan saat state berubah
                              //
                              // state adalah keadaan terbaru dari LoginBloc

                              return state.maybeWhen(
                                // maybeWhen dipakai untuk memilih UI berdasarkan state
                                //
                                // Kalau state loading, tampilkan loading
                                // Kalau state lainnya, tampilkan tombol login

                                orElse: () {
                                  // orElse artinya tampilan default
                                  //
                                  // Kalau state bukan loading,
                                  // maka tampilkan tombol Login

                                  return Button.filled(
                                      // Button.filled adalah tombol custom dari project

                                      onPressed: () {
                                        // onPressed jalan saat tombol Login ditekan

                                        context.read<LoginBloc>().add(
                                            // context.read<LoginBloc>()
                                            // artinya mengambil LoginBloc yang sudah disediakan
                                            // di atas widget tree
                                            //
                                            // Bahasa gampang:
                                            // "Cari mesin LoginBloc, lalu suruh dia kerja"

                                            LoginEvent.login(
                                                // LoginEvent.login adalah event/perintah
                                                // yang dikirim ke LoginBloc
                                                //
                                                // Bahasa gampang:
                                                // UI bilang ke BLoC:
                                                // "Tolong login pakai email dan password ini"

                                                email: emailController.text,
                                                // Mengambil teks email dari input

                                                password:
                                                    passwordController.text
                                                // Mengambil teks password dari input
                                                ));

                                        // context.pushReplacement(const MainPage());
                                        // Ini dikomentari
                                        //
                                        // Kalau ini dipakai langsung,
                                        // user akan pindah ke MainPage tanpa nunggu login berhasil
                                        //
                                        // Jadi lebih benar pindah halaman dilakukan
                                        // di BlocListener saat state success
                                      },

                                      label: 'Login');
                                  // Teks tombol adalah Login
                                },

                                loading: () {
                                  // Bagian ini jalan kalau state sedang loading
                                  //
                                  // Loading biasanya terjadi setelah tombol Login ditekan
                                  // dan aplikasi sedang menunggu jawaban dari API

                                  return Center(
                                    // Loading dibuat di tengah

                                    child: CircularProgressIndicator(),
                                    // CircularProgressIndicator adalah loading muter bawaan Flutter
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}