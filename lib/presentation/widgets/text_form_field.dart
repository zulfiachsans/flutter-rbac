import 'package:flutter/material.dart';
import 'package:flutter_rbac/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool isUsername;
  final bool isEmail;
  final bool autoCorrect;
  final bool enableSuggestions;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextField({
    required super.key,
    required this.label,
    this.isUsername = false,
    this.isPassword = false,
    this.isEmail = false,
    this.autoCorrect = false,
    this.enableSuggestions = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.isUsername
          ? TextCapitalization.words
          : widget.isEmail
              ? TextCapitalization.none
              : TextCapitalization.none,
      key: widget.key,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        prefixIcon: Icon(
          widget.isPassword
              ? Icons.lock
              : widget.isUsername
                  ? Icons.person
                  : Icons.email,
          color: AppColors.primaryColor,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
