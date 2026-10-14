part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.login({
    required String email,
    required String password,
  }) = _login;
}

// Aksi yang bakal dilakukan
// Kalau state => keadaan aplikasi setelah aksi terjadi
// state menentukan apa yang di tampilkan di layar
// Bloc mengelola perubahan state