import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hintTxt,
    this.obscureTxt = false,
    this.validator,
    this.textEditingController,
  });

  final String hintTxt;
  final bool obscureTxt;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscurePassword;
  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureTxt;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      validator: widget.validator,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: widget.hintTxt,
        hintStyle: TextStyle(fontSize: 19, fontWeight: FontWeight(500)),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 234, 231, 231),
            width: 4,
          ),
        ),

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 234, 231, 231),
            width: 4,
          ),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 116, 187, 245),
            width: 4,
          ),
        ),
        suffixIcon: widget.obscureTxt
            ? IconButton(
                icon: _obscurePassword
                    ? Icon(Icons.visibility_outlined)
                    : Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
