import 'package:dartz/dartz.dart';

import '../../../../core/error/errors.dart';
import '../entities/user.dart';
import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authReposatory;
  SignInUseCase({required this.authReposatory});
  Future<Either<Failer, Unit>> call(User user) async {
    return await authReposatory.signIn(user);
  }
}
