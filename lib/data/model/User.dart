import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userName;
  final String password;
  final bool? isLoggedIn;
  final int? counterValue;

  const User({
    required this.userName,
    required this.password,
    this.isLoggedIn,
    this.counterValue = 0,
  });

  const User.name(
    this.userName,
    this.password,
    this.isLoggedIn,
    this.counterValue,
  );

  User copyWith({
    String? userName,
    String? password,
    bool? isLoggedIn,
    int? counterValue,
  }) {
    return User(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      counterValue: counterValue ?? this.counterValue,
    );
  }

  @override
  String toString() {
    return 'User{userName: $userName, password: $password, isLoggedIn: $isLoggedIn, counterValue: $counterValue}';
  }

  @override
  List<Object?> get props => [userName];
}
