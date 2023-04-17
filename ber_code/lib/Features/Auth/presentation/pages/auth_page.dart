import 'dart:convert';
import 'package:ber_code/core/internet_info/internet_info.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_models.dart';
import '../../../../core/error/errors.dart';
import '../../../../home.dart';
import '../provider/auth_provider.dart';
import '../widgets/widgets_paths.dart';

// ignore: must_be_immutable
class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext toastContext = ToastContext();
    toastContext.init(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: deviceSize.height * 0.16),
                  Container(
                    height: deviceSize.height * 0.802,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: SwitchBetweenTwoText(
                              firstText: 'Create an account',
                              secondText: 'Welcome Back',
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SwitchBetweenTwoText(
                                firstText: 'SignUp to continue',
                                secondText: 'LogIn to continue',
                                textStyle:
                                    TextStyle(color: Colors.grey.shade600),
                              )),
                          const SizedBox(height: 10),
                          AuthForm(formKey: formKey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(right: 20, top: 10),
                                  child: HideItem(
                                    visabl:
                                        context.watch<AuthProvider>().isSignIn,
                                    maxHight: 35,
                                    child: TextButton(
                                      onPressed: () {
                                        showResetDialog(context);
                                      },
                                      child: const Text('Forgot password ?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: context
                                            .read<AuthProvider>()
                                            .isButtonLoding
                                        ? null
                                        : () => logicButton(context),
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: deviceSize.width * 0.8,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: !context
                                                .read<AuthProvider>()
                                                .isButtonLoding
                                            ? const SwitchBetweenTwoText(
                                                firstText: 'SIGN UP',
                                                secondText: 'LOG IN',
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1),
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )),
                                  ),
                                  const SizedBox(height: 15),
                                  HideItem(
                                    visabl:
                                        context.watch<AuthProvider>().isSignIn,
                                    maxHight: 15,
                                    child: Text(
                                      'or connect with',
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                  HideItem(
                                      visabl: context
                                          .watch<AuthProvider>()
                                          .isSignIn,
                                      maxHight: 100,
                                      child: const AlternativeSignInMethod()),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const SwitchBetweenTwoText(
                                        firstText: 'Already have an account ?',
                                        secondText:
                                            '      dont have an account ?',
                                        textStyle: TextStyle(fontSize: 15),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<AuthProvider>()
                                              .changeSignInOrSignUp();
                                        },
                                        child: SwitchBetweenTwoText(
                                          firstText: 'sign in',
                                          secondText: 'sign up',
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool isLoding = false;
  Future<dynamic> showResetDialog(BuildContext context) {
    controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Reset password',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        ),
        content: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: controller,
              decoration: const InputDecoration.collapsed(hintText: 'email'),
            )),
        alignment: Alignment.center,
        actions: [
          Center(
              child: StatefulBuilder(
            builder: (context, setState) => TextButton(
                onPressed: () async {
                  if (controller.text.isEmpty ||
                      !controller.text.contains('@') ||
                      !controller.text.contains('.com')) {
                    Toast.show('invalid email', duration: 3);
                  } else {
                    var netInfo = GetIt.instance.get<InternetInfoImp>();
                    if (await netInfo.isconnected) {
                      setState(() {
                        isLoding = true;
                      });
                      if (await context
                          .read<AuthProvider>()
                          .verifyEmail(email: controller.text)) {
                        var result = await context
                            .read<AuthProvider>()
                            .resetPassword(controller.text);
                        result.fold((l) {
                          Toast.show((l as ServerFailer).errorMessage);
                        }, (r) {
                          setState(() => isLoding = false);
                          Navigator.pop(ctx);
                          Toast.show('open your email to reset password',
                              duration: 3);
                        });
                      } else {
                        setState(() => isLoding = false);
                        Toast.show(
                            'email not found , pleas enter a valid email',
                            duration: 3);
                      }
                    } else {
                      Toast.show('check your internet connction', duration: 3);
                    }
                  }
                },
                child: !isLoding
                    ? const Text(
                        'Reset',
                        style: TextStyle(fontSize: 20),
                      )
                    : const CircularProgressIndicator()),
          ))
        ],
      ),
    );
  }

  logicButton(BuildContext context) async {
    bool isvalidete = formKey.currentState!.validate();
    Either<Failer, Unit>? result;
    if (isvalidete) {
      context.read<AuthProvider>().setButtonLoding(true);
      context.read<AuthProvider>().changeValidate(isvalidete);
      formKey.currentState!.save();
      if (context.read<AuthProvider>().isSignIn) {
        result = await context.read<AuthProvider>().signIn();
      } else {
        result = await context.read<AuthProvider>().signUp();
      }
      result.fold((l) {
        var s = l as ServerFailer;
        var errorMessage = s.errorMessage;

        Toast.show(errorMessage, duration: 2);
      }, (r) {
        SharedPreferences db = GetIt.instance.get<SharedPreferences>();
        db.setString('currentUser',
            json.encode(UserModel.toJson(context.read<AuthProvider>().user)));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      });
      context.read<AuthProvider>().setButtonLoding(false);
    }
  }
}
