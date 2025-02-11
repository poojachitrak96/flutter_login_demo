import 'package:flutter_login_demo/data/model/User.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLogout extends AuthState {}


class AuthSuccess extends AuthState {
  final User user;
  final String message;
  AuthSuccess(this.user, this.message);
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}
