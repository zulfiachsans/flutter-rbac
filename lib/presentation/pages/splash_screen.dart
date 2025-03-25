import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rbac/auth/auth_screen.dart';
import 'package:flutter_rbac/presentation/widgets/navbar_screen.dart';
import 'package:flutter_rbac/utils/colors.dart';
import 'package:flutter_rbac/utils/text_style.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Timer(const Duration(minutes: 1), () {
      if (!mounted) return; // ✅ Cek apakah widget masih aktif sebelum navigasi
      User? user = FirebaseAuth.instance.currentUser;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => user != null
              ? NavbarScreen(username: user.displayName ?? "Pengguna")
              : const AuthScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * .5,
            ),
            Text(
              "HomeEase",
              style: regularStyle.copyWith(
                fontSize: 24,
                color: AppColors.buttonColor,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
