import 'package:flutter/material.dart';

class CustomizedInput extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  final TextInputType type;
  CustomizedInput({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hint,
    required this.type,
  });

  @override
  State<CustomizedInput> createState() => _CustomizedInputState();
}

class _CustomizedInputState extends State<CustomizedInput> {
  bool hide = true;
  void initState() {
    super.initState();
    hide = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        keyboardType: widget.type,
        obscureText: hide,
        controller: widget.controller,
        onChanged: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        decoration: InputDecoration(
          labelText: widget.hint,
          suffixIcon: widget.obscureText == true
              ? InkWell(
                  onTap: () {
                    setState(() {
                      hide = !hide;
                    });
                  },
                  child: Icon(hide == true
                      ? Icons.visibility_off
                      : Icons.visibility_rounded),
                )
              : null,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13))),
        ),
      ),
    );
  }
}
