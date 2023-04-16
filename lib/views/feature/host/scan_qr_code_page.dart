import 'package:event_finder/services/firestore/event_ticket_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodePage extends StatefulWidget {
  const ScanQrCodePage({super.key});

  @override
  State<ScanQrCodePage> createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  List<String> qrCodesScanned = [];
  bool qrCodeProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  KKBackButton(),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            const Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan a code'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code == null) return;
      if (!qrCodeProcessing) {
        debugPrint('Found Code');
        qrCodeProcessing = true;
        controller.pauseCamera();
        print(scanData.code);
        if (StateService().lastSelectedEvent!.uid !=
            scanData.code!.split('_')[1]) {
          _showQrCodeResultDialog(
              'Falsches Event',
              const Icon(
                Icons.error,
                color: Colors.red,
              ));
        } else {
          if (qrCodesScanned.contains(scanData.code!)) {
            _showQrCodeResultDialog(
                'Code bereits eingelöst',
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ));
          } else {
            final isValid = await EventTicketDocService()
                .checkIfQrCodeStillValid(scanData.code!);
            if (isValid) {
              qrCodesScanned.add(scanData.code!);
              _showQrCodeResultDialog(
                'Scannen erfolgreich',
                const Icon(
                  Icons.check,
                  color: Colors.greenAccent,
                ),
              );
            } else {
              _showQrCodeResultDialog(
                  'Code bereits eingelöst',
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
            }
          }
        }
      }
    });
  }

  void _showQrCodeResultDialog(String text, Icon icon) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(text),
              const SizedBox(height: 25),
              icon,
              const Divider(),
              Center(
                child: TextButton(
                  onPressed: () {
                    qrCodeProcessing = false;
                    controller!.resumeCamera();
                    Navigator.pop(context);
                  },
                  child: const Text('Nächster Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
