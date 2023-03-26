import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../theme/theme.dart';

class QrCode extends StatelessWidget {
  const QrCode({Key? key, required this.data, required this.size})
      : super(key: key);
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: QrImage(
        size: size,
        data: data,
        padding: const EdgeInsets.all(12),
        backgroundColor: primaryWhite,
      ),
    );
  }
}
