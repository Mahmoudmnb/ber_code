import '../../../../core/error/errors.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failer, Unit>> signIn(User user);
  Future<Either<Failer, Unit>> signUp(User user);
  Future<Either<Failer, Unit>> forgetPassword(String email, String newPassword);
}
