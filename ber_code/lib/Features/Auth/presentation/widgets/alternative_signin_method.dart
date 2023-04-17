import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../../../core/error/errors.dart';
import '../../../../core/internet_info/internet_info.dart';
import '../../../../home.dart';
import '../../data/models/auth_models.dart';
import '../../domain/entities/user.dart';
import '../provider/auth_provider.dart';

class AlternativeSignInMethod extends StatelessWidget {
  const AlternativeSignInMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext toastContext = ToastContext();
    toastContext.init(context);
    return !context.watch<AuthProvider>().isLoding
        ? Row(
            children: [
              imageContainer('Google', context),
              imageContainer('Facebook', context),
              imageContainer('Twitter', context),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  InkWell imageContainer(String type, BuildContext context) {
    return InkWell(
      onTap: () async {
        InternetInfoImp con = GetIt.instance.get<InternetInfoImp>();
        if (await con.isconnected) {
          if (type == 'Google') {
            GoogleSignIn googleSignIn = GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/contacts.readonly',
              ],
            );
            var user = await googleSignIn.signIn();
            if (user != null) {
              showPasswordDialog(context).then((password) async {
                if (password != null) {
                  context.read<AuthProvider>().setLodingState(true);
                  var result = await context.read<AuthProvider>().signUp(
                      googleUser: User(
                          email: user.email,
                          name: user.displayName ?? '',
                          password: password));
                  result.fold((l) async {
                    var result = l as ServerFailer;
                    if (result.errorMessage ==
                        'Account already exists for this username.') {
                      var t = await context.read<AuthProvider>().signIn(
                          googleUser: User(
                              email: user.email,
                              name: user.displayName ?? '',
                              password: password));
                      t.fold((l) {
                        googleSignIn.signOut();
                        context.read<AuthProvider>().setLodingState(false);
                        Toast.show((l as ServerFailer).errorMessage,
                            duration: 3);
                      }, (r) {
                        SharedPreferences db =
                            GetIt.instance.get<SharedPreferences>();
                        db.setString(
                            'currentUser',
                            json.encode(UserModel.toJson(
                                context.read<AuthProvider>().user)));
                        context.read<AuthProvider>().setLodingState(false);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                      });
                    }
                  }, (r) {
                    SharedPreferences db =
                        GetIt.instance.get<SharedPreferences>();
                    db.setString(
                        'currentUser',
                        json.encode(UserModel.toJson(
                            context.read<AuthProvider>().user)));
                    context.read<AuthProvider>().setLodingState(false);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
                  });
                }
              });
            }
          }
        } else {
          Toast.show('check your internt conntection', duration: 2);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          type == 'Google'
              ? MdiIcons.google
              : type == 'Facebook'
                  ? MdiIcons.facebook
                  : MdiIcons.twitter,
          size: 50,
          color: type == 'Google'
              ? Colors.redAccent
              : type == 'Facebook'
                  ? Colors.blue
                  : Colors.teal,
        ),
      ),
    );
  }
}

Future<dynamic> showPasswordDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Enter password',
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
            keyboardType: TextInputType.visiblePassword,
            controller: controller,
            decoration: const InputDecoration.collapsed(hintText: 'Password'),
          )),
      alignment: Alignment.center,
      actions: [
        Center(
          child: TextButton(
              onPressed: () {
                if (controller.text.length >= 6) {
                  Navigator.pop(context, controller.text);
                } else {
                  Toast.show('passwrd maust be six character at least',
                      duration: 3);
                }
              },
              child: const Text(
                'Enter',
                style: TextStyle(fontSize: 20),
              )),
        )
      ],
    ),
  );
}
