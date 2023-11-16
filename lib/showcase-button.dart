import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowCaseButton extends StatelessWidget {

  final Widget title;
  final bool isOutline;
  final Color? color;
  final VoidCallback? onPressed;

  ShowCaseButton({
    required this.title,
    this.isOutline = true,
    this.color,
    this.onPressed
  });

  @override Widget build(BuildContext context) {
    return CupertinoButton(
      child: title,
      onPressed: onPressed,
    );
  }

}