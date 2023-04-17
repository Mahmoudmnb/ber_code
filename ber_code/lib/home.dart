import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Features/Auth/presentation/pages/auth_page.dart';
import 'Features/Auth/presentation/provider/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                if (await context.read<AuthProvider>().logOut()) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AuthPage(),
                  ));
                }
              },
              child: const Text('hello in home page')),
        ],
      )),
    );
  }
}
