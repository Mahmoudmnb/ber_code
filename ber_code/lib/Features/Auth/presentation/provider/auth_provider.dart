import 'dart:convert';

import 'package:ber_code/core/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../domain/usecases/signin.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/signup.dart';
import '../../../../core/error/errors.dart';

class AuthProvider extends ChangeNotifier {
  bool? visibl = false;
  bool isSignIn = false;
  bool validate = true;
  bool _isLoding = false;
  bool _isButtonLinding = false;
  String _name = '';
  String _email = '';
  String _password = '';
  late User user;
  // states
  get isButtonLoding => _isButtonLinding;
  get isLoding => _isLoding;

  void setButtonLoding(bool loding) {
    _isButtonLinding = loding;
    notifyListeners();
  }

  void setLodingState(bool loding) {
    _isLoding = loding;
    notifyListeners();
  }

  void changeValidate(bool isValidate) {
    validate = isValidate;
    notifyListeners();
  }

  void visableChangeSatate() async {
    visibl = !visibl!;
    notifyListeners();
  }

  void changeSignInOrSignUp() {
    isSignIn = !isSignIn;
    notifyListeners();
  }

  set setName(newName) {
    _name = newName;
    notifyListeners();
  }

  set setEmail(newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  set setPassword(newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  Future<bool> isLogedIn() async {
    SharedPreferences db = await SharedPreferences.getInstance();
    var result = db.getString('currentUser');
    if (result == null) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  //logic
  Future<Either<Failer, Unit>> signUp({User? googleUser}) async {
    var s = GetIt.instance.get<SignUpUseCase>();
    if (googleUser == null) {
      user = User(email: _email, name: _name, password: _password);
    } else {
      user = googleUser;
    }
    return await s(user);
  }

  Future<Either<Failer, Unit>> signIn({User? googleUser}) async {
    var s = GetIt.instance.get<SignInUseCase>();
    if (googleUser == null) {
      user = User(email: _email, name: _name, password: _password);
    } else {
      user = googleUser;
    }
    return await s(user);
  }

  Future<bool> logOut() {
    SharedPreferences db = GetIt.instance.get<SharedPreferences>();
    var s = db.remove('currentUser');
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    googleSignIn.signOut();
    return s;
  }

  Future<Either<Failer, Unit>> resetPassword(String email) async {
    http.Response? res;
    res = await http.post(
        Uri.parse('https://parseapi.back4app.com/requestPasswordReset'),
        headers: Constant.header,
        body: json.encode({'email': email}));
    if (res.statusCode == 200) {
      return const Right(unit);
    } else {
      return Left(ServerFailer(errorMessage: json.decode(res.body)['error']));
    }
  }

  Future<bool> verifyEmail({String? email}) async {
    String verEmail;
    if (email == null) {
      verEmail = _email;
    } else {
      verEmail = email;
    }
    var res = await http.post(
        Uri.parse('https://parseapi.back4app.com/verificationEmailRequest'),
        headers: Constant.header,
        body: json.encode({'email': verEmail}));
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
