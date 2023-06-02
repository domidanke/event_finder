import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    this.icon = const Icon(
      Icons.arrow_back,
      color: primaryWhite,
    ),
    this.color = primaryWhite,
    this.onPressed,
  }) : super(key: key);
  final Icon icon;
  final Color color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 60,
        height: 60,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: color, width: 1),
          ),
          child: onPressed == null
              ? icon
              : IconButton(
                  icon: icon,
                  color: color,
                  onPressed: onPressed,
                  splashRadius: 31,
                  splashColor: Colors.white.withOpacity(0.5),
                ),
        ),
      );
}
