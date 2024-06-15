import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String? btnText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;
  const CustomBtn(
      {super.key, this.btnText, this.onTap, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => onTap!));
      },
      child: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Text(
          btnText!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor!),
        ),
      ),
    );
  }
}
