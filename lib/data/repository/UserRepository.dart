import 'package:flutter_login_demo/data/model/User.dart';

abstract class IUserRepository {
  Future<User?> checkUser(String userName);
  Future<User> createUser(User user);
  Future<User> login(User user);
  Future<void> logout(User user);
  Future<User> updateUser(User user);
}
