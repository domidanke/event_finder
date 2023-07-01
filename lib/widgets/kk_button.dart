import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class KKButton extends StatelessWidget {
  const KKButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);
  final Function() onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(secondaryColor),
        ),
        onPressed: onPressed,
        child: Container(
          constraints: const BoxConstraints(
              maxHeight: 50, minHeight: 36.0, minWidth: 100),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: primaryBackgroundColor),
          ),
        ),
      );
}
