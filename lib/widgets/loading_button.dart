import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    Key? key,
    required this.onPressed,
    required this.loading,
    required this.buttonText,
  }) : super(key: key);
  final Function() onPressed;
  final bool loading;
  final String buttonText;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          )),
          onPressed: widget.loading ? null : widget.onPressed,
          child: widget.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                )
              : Text(
                  widget.loading ? '' : widget.buttonText,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      );
}
