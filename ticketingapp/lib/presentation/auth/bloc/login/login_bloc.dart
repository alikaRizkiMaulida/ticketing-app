// ignore_for_file: public_member_api_docs, sort_constructors_first
// Baris ini untuk menyuruh analyzer Dart mengabaikan warning tertentu
//
// public_member_api_docs:
// biasanya warning kalau class/function public belum diberi dokumentasi
//
// sort_constructors_first:
// biasanya warning kalau urutan constructor tidak sesuai aturan style
//
// Jadi ini bukan kode utama aplikasi,
// cuma instruksi supaya warning tertentu tidak muncul

import 'package:bloc/bloc.dart';
// Import package bloc
// Package ini dipakai untuk membuat BLoC
//
// BLoC itu seperti "mesin logic"
// Tugasnya menerima perintah dari UI,
// lalu mengubah state sesuai hasil proses

import 'package:flutter/foundation.dart';
// Import foundation dari Flutter
//
// Biasanya dipakai untuk fitur dasar Flutter/Dart
// Kadang dipakai oleh generated code atau annotation tertentu
//
// Di potongan kode ini belum terlihat dipakai langsung

import 'package:freezed_annotation/freezed_annotation.dart';
// Import freezed_annotation
//
// Freezed dipakai untuk membuat class event/state dengan lebih rapi
// Biasanya membantu membuat union/sealed class seperti:
// - initial
// - loading
// - success
// - error
//
// File event dan state biasanya nanti digenerate oleh build_runner

import 'package:ticketingapp/data/datasource/auth_remote_datasource.dart';
// Import AuthRemoteDatasource
//
// AuthRemoteDatasource adalah class yang berhubungan dengan API/server
//
// Di kode ini dipakai untuk memanggil API login:
// authRemoteDatasource.login(dataRequest)

import 'package:ticketingapp/data/model/request/login_request_model.dart';
// Import LoginRequestModel
//
// LoginRequestModel adalah model data untuk request login
// Biasanya berisi email dan password
//
// Data dari user akan dimasukkan ke model ini,
// lalu dikirim ke API

import 'package:ticketingapp/data/model/response/auth_response_model.dart';
// Import AuthResponseModel
//
// AuthResponseModel adalah model data hasil response login
//
// Biasanya berisi token dan data user
// Kalau login berhasil, hasilnya akan berbentuk AuthResponseModel

part 'login_bloc.freezed.dart';
// part ini menghubungkan file ini dengan file hasil generate Freezed
//
// File login_bloc.freezed.dart dibuat otomatis oleh build_runner
//
// Biasanya file ini berisi kode tambahan untuk event dan state,
// misalnya maybeWhen, when, copyWith, dan lain-lain

part 'login_event.dart';
// Ini menghubungkan file login_bloc.dart dengan file login_event.dart
//
// login_event.dart biasanya berisi daftar event/perintah untuk LoginBloc
//
// Contohnya event login:
// LoginEvent.login(email: ..., password: ...)

part 'login_state.dart';
// Ini menghubungkan file login_bloc.dart dengan file login_state.dart
//
// login_state.dart biasanya berisi daftar state/kondisi login
//
// Contohnya:
// - initial
// - loading
// - success
// - error

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // Ini adalah class LoginBloc
  //
  // LoginBloc adalah mesin yang mengatur proses login
  //
  // Bloc<LoginEvent, LoginState> artinya:
  //
  // LoginBloc menerima LoginEvent
  // lalu menghasilkan LoginState
  //
  // Bahasa gampangnya:
  // UI ngirim perintah ke LoginBloc
  // LoginBloc memproses
  // LoginBloc kasih kabar balik lewat state

  final AuthRemoteDatasource authRemoteDatasource;
  // Ini adalah variabel untuk menyimpan AuthRemoteDatasource
  //
  // AuthRemoteDatasource dipakai untuk memanggil API login ke server
  //
  // Kenapa ditaruh di dalam Bloc?
  // Karena Bloc yang bertugas mengurus logic login,
  // jadi Bloc perlu akses ke datasource API

  LoginBloc(
    this.authRemoteDatasource,
    // Ini constructor LoginBloc
    //
    // this.authRemoteDatasource artinya saat LoginBloc dibuat,
    // kita harus mengirim AuthRemoteDatasource
    //
    // Jadi LoginBloc bisa memakai authRemoteDatasource
    // untuk memanggil API login

  ) : super(_Initial()) {
    // super(_Initial()) artinya state awal LoginBloc adalah _Initial
    //
    // _Initial itu kondisi awal
    // Maksudnya belum ada proses login yang sedang berjalan
    //
    // Bahasa gampang:
    // "LoginBloc baru nyala, belum ngapa-ngapain"

    on<_login>((event, emit) async {
      // on<_login> artinya:
      //
      // "Kalau ada event _login yang masuk,
      // jalankan kode di dalam sini"
      //
      // Event _login biasanya terjadi saat user pencet tombol Login
      //
      // event berisi data yang dikirim dari UI
      // Contohnya:
      // event.email
      // event.password
      //
      // emit dipakai untuk mengubah state
      //
      // async dipakai karena proses login ke API butuh waktu

      emit(_Loading());
      // Ini mengubah state menjadi _Loading
      //
      // Maksudnya proses login sedang berjalan
      //
      // Nanti UI bisa mendengar state ini
      // lalu menampilkan loading muter
      //
      // Bahasa gampang:
      // LoginBloc bilang ke UI:
      // "Sebentar ya, aku lagi login..."

      final dataRequest =
          LoginRequestModel(email: event.email, password: event.password);
      // Ini membuat object LoginRequestModel
      //
      // Data email dan password diambil dari event
      //
      // event.email berasal dari input email yang dikirim dari LoginPage
      // event.password berasal dari input password yang dikirim dari LoginPage
      //
      // LoginRequestModel ini nanti dikirim ke API
      //
      // Bahasa gampang:
      // email dan password dibungkus dulu ke dalam satu paket data
      // sebelum dikirim ke server

      final response = await authRemoteDatasource.login(dataRequest);
      // Ini memanggil function login dari AuthRemoteDatasource
      //
      // dataRequest dikirim ke API login
      //
      // await artinya tunggu sampai API selesai memberi jawaban
      //
      // Hasilnya disimpan di variabel response
      //
      // response ini bentuknya Either
      // Jadi ada 2 kemungkinan:
      //
      // Left  = gagal
      // Right = berhasil

      response.fold(
        // fold dipakai untuk membuka hasil Either
        //
        // Karena response punya 2 kemungkinan,
        // fold menyediakan 2 bagian:
        //
        // bagian kiri  = kalau gagal
        // bagian kanan = kalau berhasil

        (error) => emit(_Error(error)),
        // Bagian ini jalan kalau response adalah Left
        //
        // Artinya login gagal
        //
        // error berisi pesan error dari API
        //
        // emit(_Error(error)) artinya state diubah menjadi _Error
        //
        // Nanti UI bisa menampilkan SnackBar atau pesan error

        (data) => emit(_Success(data)),
        // Bagian ini jalan kalau response adalah Right
        //
        // Artinya login berhasil
        //
        // data berisi hasil login
        // Bentuknya AuthResponseModel
        //
        // emit(_Success(data)) artinya state diubah menjadi _Success
        //
        // Nanti UI bisa:
        // - menyimpan data login
        // - pindah ke MainPage
      );
    });
  }
}