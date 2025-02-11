import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_demo/data/model/User.dart';
import 'package:flutter_login_demo/data/repository/UserRepository.dart';
import 'package:flutter_login_demo/data/repository/UserRepositoryImpl.dart';
import 'package:flutter_login_demo/login/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IUserRepository userRepo = UserRepositoryImpl();
  AuthCubit() : super(AuthInitial());
  Future<void> signIn(User user) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      User? existingUser = await userRepo.checkUser(user.userName);
      if (existingUser != null) {
        if (existingUser.password == user.password) {
          User loggedInUser =
              await userRepo.login(user.copyWith(isLoggedIn: true));
          emit(AuthSuccess(
              existingUser, "Welcome back, ${loggedInUser.userName}!"));
        } else {
          emit(AuthFailure("Incorrect password. Please try again."));
        }
      } else {
        User newUser =
            await userRepo.createUser(user.copyWith(isLoggedIn: true));
        emit(AuthSuccess(newUser,
            "Account created successfully! Welcome, ${newUser.userName}!"));
      }
    } catch (e) {
      emit(
          AuthFailure("An unexpected error occurred. Please try again later."));
      if (kDebugMode) {
        print("Login Error: $e");
      }
    }
  }

  Future<void> signOut(User user) async {
    try {
      await userRepo.logout(user.copyWith(isLoggedIn: false));
      emit(AuthFailure("You have been logged out successfully."));
    } catch (e) {
      emit(AuthFailure("Logout failed. Please try again."));
    }
  }
}
