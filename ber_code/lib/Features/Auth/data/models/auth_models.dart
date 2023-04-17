import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required email, required name, required password}) : super(email: '', name: '', password: '');
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'], name: json['name'], password: json['password']);
  }
  static Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };
  }
}
