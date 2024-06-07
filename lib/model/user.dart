import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? email;
  final String? password;
  final String? oldPassword;
  final bool? premium;

  const User({this.email, this.password, this.oldPassword, this.premium});

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'] as String?,
        password: json['password'] as String?,
        oldPassword: json['oldPassword'] as String?,
        premium: json['premium'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'oldPassword': oldPassword,
        'premium': premium,
      };

  User copyWith({
    String? email,
    String? password,
    String? oldPassword,
    bool? premium,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      oldPassword: oldPassword ?? this.oldPassword,
      premium: premium ?? this.premium,
    );
  }

  @override
  List<Object?> get props => [email, password, oldPassword, premium];
}
