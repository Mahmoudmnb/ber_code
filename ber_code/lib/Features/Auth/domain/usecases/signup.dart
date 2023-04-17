import 'package:dartz/dartz.dart';

import '../../../../core/error/errors.dart';
import '../entities/user.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authReposatory;
  SignUpUseCase({required this.authReposatory});
  Future<Either<Failer, Unit>> call(User user) async {
    return await authReposatory.signUp(user);
  }
}
