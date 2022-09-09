import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  List<TextInputFormatter>? inputFormaters;
  TextInputType? inputType;
  final TextEditingController controller;
  final bool obscure;
  final String label;
  final String hint;
  final String? Function(String?) validator;
  CustomTextField(
      {Key? key,
      this.inputType,
      this.inputFormaters,
      required this.validator,
      required this.controller,
      required this.obscure,
      required this.hint,
      required this.label})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                inputFormatters: widget.inputFormaters,
                keyboardType: widget.inputType,
                validator: widget.validator,
                onChanged: (t) {
                  setState(() {});
                },
                controller: widget.controller,
                style: TextStyle(color: Colors.white),
                obscureText: widget.obscure,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                    hintText: widget.hint,
                    label: Text(
                      widget.label,
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purple.shade800, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15))))),
      ],
    );
  }
}
