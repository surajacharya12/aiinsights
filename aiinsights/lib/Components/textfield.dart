import 'package:flutter/material.dart';
import 'colors.dart';

class InputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool passwordInvisible;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.passwordInvisible = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.passwordInvisible; // Default to true if it's a password field
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.passwordInvisible ? _obscureText : false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            icon: Icon(widget.icon),
            suffixIcon: widget.passwordInvisible
                ? IconButton(
                    icon: Icon(
                      // FIX: show correct icon for current state
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
