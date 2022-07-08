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
    final theme = Theme.of(context);
    Color color = this.color ?? theme.colorScheme.primary;

    return TextButton(
      child: title,
      style: theme.outlinedButtonTheme.style?.copyWith(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
        ),
        side: MaterialStateProperty.all(BorderSide(color: color, width: 1)),
      ),
      onPressed: onPressed,
    );
  }

}