import 'package:provider/provider.dart';

import 'home.dart';
import 'injection.dart';
import 'Features/Auth/presentation/pages/auth_page.dart';
import 'Features/Auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bero code',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            surfaceTint: Colors.lightGreenAccent,
            error: Colors.red,
            onError: Colors.orange,
            background: Colors.deepOrangeAccent,
            onBackground: Colors.deepOrange,
            surface: Colors.redAccent,
            brightness: Brightness.light,
            primary: Color.fromRGBO(35, 185, 155, 1),
            onSurface: Colors.white,
            onPrimary: Colors.red,
            secondary: Colors.redAccent,
            onSecondary: Colors.orange,
          ),
          primaryColor: const Color.fromRGBO(20, 132, 127, 1),
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: context.read<AuthProvider>().isLogedIn(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const HomePage();
            } else {
              return AuthPage();
            }
          },
        ));
  }
}
