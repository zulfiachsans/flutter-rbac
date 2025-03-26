import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rbac/presentation/widgets/navbar_screen.dart';
import 'package:flutter_rbac/presentation/widgets/text_form_field.dart';
import 'package:flutter_rbac/utils/colors.dart';
import 'package:flutter_rbac/utils/text_style.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final Future<void> Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  const AuthForm({
    Key? key,
    required this.isLoading,
    required this.submitFn,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (!isValid!) return;

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );

      if (!mounted) return;

      setState(() {
        _errorMessage = null;
      });

      if (_isLogin) {
        // 🔴 Jika Login, Ambil Data Username dari Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          _userName = userData.data()?['username'] ?? 'Pengguna';

          // 🔴 Navigasi ke NavbarScreen setelah berhasil login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NavbarScreen(username: _userName),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Terjadi kesalahan, coba lagi.";

      if (e.code == 'user-not-found') {
        errorMessage = "Email belum terdaftar. Silakan daftar terlebih dahulu.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Password salah. Coba lagi.";
      } else if (e.code == 'invalid-credential') {
        errorMessage = "Cek kembali email & password Anda.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Tidak ada koneksi internet.";
      }

      if (!mounted) return;

      setState(() {
        _errorMessage = errorMessage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = "Terjadi kesalahan, coba lagi.";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * .05,
                  horizontal: 40.0,
                ),
                child: SizedBox(
                  child: Image.asset(
                    !_isLogin
                        ? 'assets/images/signup-illustration.png'
                        : 'assets/images/login-illustration.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Text(
              _isLogin ? 'Login' : 'Sign Up',
              textAlign: TextAlign.center,
              style: semiBoldStyle.copyWith(
                fontSize: 24,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin)
                    CustomTextField(
                      key: const ValueKey('username'),
                      label: 'Username',
                      isUsername: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    key: const ValueKey('email'),
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    key: const ValueKey('password'),
                    label: 'Password',
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 18),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: _trySubmit,
                        child: Text(
                          _isLogin ? 'Login' : 'Signup',
                          style: mediumStyle.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: _isLogin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: regularStyle.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text('Sign Up'),
                              ],
                            )
                          : Text('I Already have an account'),
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
