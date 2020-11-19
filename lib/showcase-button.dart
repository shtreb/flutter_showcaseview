import 'package:flutter/material.dart';

class ShowCaseButton extends StatelessWidget {

  final String title;
  final bool isOutline;
  final Color color;
  final VoidCallback onPressed;

  ShowCaseButton({
    @required this.title,
    this.isOutline = true,
    this.color,
    this.onPressed
  });

  @override Widget build(BuildContext context) {
    Color color = this.color ??
        Theme.of(context).buttonColor ??
        Colors.blue;

    var widget;

    if (isOutline) {
      widget = OutlineButton(
          child: Text(title),
          color: color,
          borderSide: BorderSide(color: color, width: 1),
          highlightedBorderColor: color.withOpacity(.75),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          )
      );
    } else {
      widget = MaterialButton(
          child: Text(title),
          color: color,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          )
      );
    }

    return widget;
  }

}