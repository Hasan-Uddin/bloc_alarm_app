import 'package:flutter/material.dart';

class CustomBtnImg extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon icon;
  final double marginVer;
  const CustomBtnImg({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.marginVer = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: marginVer),
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          // Make background transparent for an outlined look
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(69),
            side: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        icon: icon,
        iconAlignment: IconAlignment.end,
        label: Text(text, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
