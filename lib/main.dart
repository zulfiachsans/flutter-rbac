import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rbac/auth/auth_screen.dart';
import 'package:flutter_rbac/presentation/pages/home_page.dart';
import 'package:flutter_rbac/presentation/pages/splash_screen.dart';
import 'package:flutter_rbac/presentation/widgets/navbar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: snapshot.connectionState != ConnectionState.done
              ? const Splashscreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Splashscreen();
                    }
                    if (userSnapshot.hasData) {
                      return NavbarScreen(
                        username:
                            FirebaseAuth.instance.currentUser?.displayName ??
                                "Pengguna",
                      );
                    }
                    return const AuthScreen();
                  },
                ),
        );
      },
    );
  }
}
