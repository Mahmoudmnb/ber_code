import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

import '../../../../core/constant.dart';
import '../../../../core/internet_info/internet_info.dart';
import '../../../../core/error/errors.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  InternetInfo info;
  AuthRepositoryImpl({required this.info});
  @override
  Future<Either<Failer, Unit>> forgetPassword(
      String email, String newPassword) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failer, Unit>> signIn(User user) async {
    if (await info.isconnected) {
      var res = await http.get(
        Uri.parse(
            'https://parseapi.back4app.com/login?username=${user.name}&password=${user.password}'),
        headers: Constant.header,
      );
      if (res.statusCode == 200) {
        return const Right(unit);
      } else {
        var s = json.decode(res.body);
        return Left(ServerFailer(errorMessage: s['error']));
      }
    } else {
      return Left(ServerFailer(errorMessage: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failer, Unit>> signUp(User user) async {
    if (await info.isconnected) {
      Map<String, String> body = {
        'username': user.name,
        'password': user.password,
        'email': user.email
      };
      var res = await http.post(
          Uri.parse('https://parseapi.back4app.com/users'),
          headers: Constant.header,
          body: json.encode(body));
      print(res.body);
      if (res.statusCode == 201) {
        return const Right(unit);
      } else {
        var s = json.decode(res.body);
        return Left(ServerFailer(errorMessage: s['error']));
      }
    } else {
      return Left(ServerFailer(errorMessage: 'check your internet connection'));
    }
  }
}
