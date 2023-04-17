import 'package:dartz/dartz.dart';

import '../../../../core/error/errors.dart';
import '../repository/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository authReposatory;
  ForgetPasswordUseCase({required this.authReposatory});
  Future<Either<Failer, Unit>> call(String email, String newPassword) async {
    return await authReposatory.forgetPassword(email, newPassword);
  }
}
