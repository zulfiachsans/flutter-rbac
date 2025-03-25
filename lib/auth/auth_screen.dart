import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await authResult.user!.updateDisplayName(userName);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan, coba lagi.";

      if (e.code == 'email-already-in-use') {
        message = "Email sudah digunakan.";
      } else if (e.code == 'user-not-found') {
        message = "Email belum terdaftar.";
      } else if (e.code == 'wrong-password') {
        message = "Password salah.";
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(
        isLoading: _isLoading,
        submitFn: _submitAuthForm,
      ),
    );
  }
}
