// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:food_bank/common/widgets.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScannerScreen extends StatefulWidget {
//   static String name = 'qr-scanner';
//   static String route = '/qr-scanner';
//   const QRScannerScreen({super.key});

//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print(scanData.code);
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const FoodBankAppBar(
//         title: 'Scan QR to Redeem Food',
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderWidth: 10,
//                 borderColor: Colors.white,
//                 borderRadius: 10,
//               ),
//             ),
//           ),
//           // GestureDetector(
//           //     onTap: () {
//           //       showModalBottomSheet(
//           //           context: context,
//           //           isScrollControlled: true,
//           //           isDismissible: false,
//           //           useSafeArea: true,
//           //           builder: (context) {
//           //             return const TwoStepOrderInProgressBottomSheet();
//           //           });
//           //     },
//           //     child: Text('Scan now')),
//         ],
//       ),
//     );
//   }
// }
