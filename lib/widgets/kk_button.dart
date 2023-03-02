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
        onPressed: onPressed,
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0, maxWidth: 250, maxHeight: 70, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
