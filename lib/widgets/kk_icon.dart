import 'package:flutter/material.dart';

class KKIcon extends StatelessWidget {
  const KKIcon({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
  }) : super(key: key);
  final Icon icon;
  final Color? color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(height: 50, width: 50, child: icon),
        ),
      );
}
