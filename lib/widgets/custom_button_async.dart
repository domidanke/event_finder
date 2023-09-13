import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CustomButtonAsync extends StatefulWidget {
  const CustomButtonAsync({
    Key? key,
    required this.onPressed,
    required this.loading,
    required this.buttonText,
  }) : super(key: key);
  final Function() onPressed;
  final bool loading;
  final String buttonText;

  @override
  State<CustomButtonAsync> createState() => _CustomButtonAsyncState();
}

class _CustomButtonAsyncState extends State<CustomButtonAsync> {
  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(secondaryColor),
        ),
        onPressed: widget.loading ? null : widget.onPressed,
        child: Container(
          constraints: const BoxConstraints(
              maxHeight: 50, minHeight: 36.0, minWidth: 100),
          alignment: Alignment.center,
          child: widget.loading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.loading ? '' : widget.buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, color: primaryBackgroundColor),
                ),
        ),
      );
}
