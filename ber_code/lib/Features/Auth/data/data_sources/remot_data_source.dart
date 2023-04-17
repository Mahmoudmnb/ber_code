
import '../../../../core/constant.dart';
import '../models/auth_models.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<bool> signUp(UserModel userModel);
  Future<bool> signIn(UserModel userModel);
  Future<bool> forgetPassword(String email, String newPassword);
}

class RemoteDataSourceImp extends RemoteDataSource {
  @override
  Future<bool> forgetPassword(String email, String newPassword) {
    throw UnimplementedError();
  }

  @override
  Future<bool> signIn(UserModel userModel) {
    throw UnimplementedError();
  }

  @override
  Future<bool> signUp(UserModel userModel) {
    Map<String, String> header = {
      'X-Parse-Application-Id': Constant.appId,
      'X-Parse-REST-API-Key': Constant.restApiKey,
      'X-Parse-Revocable-Session': '1',
      'Content-Type': 'application/json'
    };
    Map<String, String> body = {'username': '', 'password': ''};
    http.post(Uri.parse('https://parseapi.back4app.com/users'),
        headers: header, body: body);
    return Future.value(true);
  }
}
