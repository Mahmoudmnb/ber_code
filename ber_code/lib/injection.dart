import 'package:shared_preferences/shared_preferences.dart';

import 'Features/Auth/domain/usecases/signin.dart';
import 'Features/Auth/domain/usecases/signup.dart';
import 'Features/Auth/data/Repository/auth_repository_imp.dart';
import 'core/internet_info/internet_info.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  SharedPreferences db = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(authReposatory: sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(authReposatory: sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(info: sl<InternetInfoImp>()));

  sl.registerLazySingleton<InternetInfoImp>(
      () => InternetInfoImp(netInfo: sl<InternetConnectionCheckerPlus>()));
  //libs
  sl.registerLazySingleton<InternetConnectionCheckerPlus>(
      () => InternetConnectionCheckerPlus());
  sl.registerLazySingleton<SharedPreferences>(() => db);
  SignInUseCase(
      authReposatory: AuthRepositoryImpl(
          info: InternetInfoImp(netInfo: InternetConnectionCheckerPlus())));
}
