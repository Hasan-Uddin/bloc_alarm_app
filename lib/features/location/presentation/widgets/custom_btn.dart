import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final double marginVer;
  const CustomBtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.marginVer = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: marginVer),
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(69),
          ),
        ),
        child: Text(text!, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
