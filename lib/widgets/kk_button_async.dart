import 'package:flutter/material.dart';

class KKButtonAsync extends StatefulWidget {
  const KKButtonAsync({
    Key? key,
    required this.onPressed,
    required this.loading,
    required this.buttonText,
  }) : super(key: key);
  final Function() onPressed;
  final bool loading;
  final String buttonText;

  @override
  State<KKButtonAsync> createState() => _KKButtonAsyncState();
}

class _KKButtonAsyncState extends State<KKButtonAsync> {
  @override
  Widget build(BuildContext context) => ElevatedButton(
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
                ),
        ),
      );
}
