import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;  // Correct validator type to return String? (nullable)

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: widget.validator,  // validator logic
        controller: widget.controller,
        obscureText: (widget.hintText == "Password" || widget.hintText == "Confirm Password") 
          ? _isObscured : false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          suffixIcon: (widget.hintText == "Password" || widget.hintText == "Confirm Password")
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;  // Toggle password visibility
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
