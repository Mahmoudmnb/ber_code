import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String password;
  const User({required this.email, required this.name, required this.password});
  @override
  List<Object?> get props => [name, email, password];
}
