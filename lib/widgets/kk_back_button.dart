import 'package:flutter/material.dart';

class KKBackButton extends StatelessWidget {
  const KKBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const SizedBox(
              height: 50, width: 50, child: Icon(Icons.arrow_back)),
        ),
      );
}
