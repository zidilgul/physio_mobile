import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'egzersizlerim.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QrCodeScannerState();
}

class QrCodeScannerState extends State<QrCodeScanner> {

  Barcode? result;
  QRViewController? controller;
  late String  newResult = "";
  bool flash_on = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState(){
    getCameraPermission();
    super.initState();
  }

  void getCameraPermission() async {
    print(await Permission.camera.status); // prints PermissionStatus.granted
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {

        });
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Please enable camera to scan barcodes')));
        Navigator.of(context).pop();
      }
    } else {
      setState(() {

      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    _buildQrView(context),
                    Container(
                      height: MediaQuery.of(context).size.height/6,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height/12,
                              width: MediaQuery.of(context).size.width/6,
                              child: IconButton(
                                  onPressed: ()async{
                                    await controller?.toggleFlash();
                                    setState(() {});
                                  },
                                  icon:Icon(Icons.flash_on,size: MediaQuery.of(context).size.height/15,color: Colors.white24)
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height/12,
                              width: MediaQuery.of(context).size.width/6,
                              child: IconButton(onPressed: ()async{
                                await controller?.flipCamera();
                                setState(() {});
                              },
                                icon: Icon(Icons.camera_front,size: MediaQuery.of(context).size.height/15,color: Colors.white24,),))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6),
                      child: Container(
                          height: MediaQuery.of(context).size.height/13,
                          width: MediaQuery.of(context).size.width,
                          ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => EgzersizMain()),
                                (Route<dynamic> route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(child: Container(
                              height: MediaQuery.of(context).size.height/21,
                                width: MediaQuery.of(context).size.width/2,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.black38)
                                ),
                                child: Center(child: Text("Bitir",style: TextStyle(color: Colors.white,letterSpacing: 2),)))),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 350 ||
        MediaQuery.of(context).size.height < 350) ? 250.0 : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.transparent,
          borderRadius: 10,
          borderLength: 45,
          borderWidth: 7,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }


  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        newResult = (result!.code!.contains("|") ? result!.code!.split('|')[1] : result!.code)!;
      });
      if(scanData != null){
        this.controller?.pauseCamera();
        this.controller?.dispose();

      }
    });

  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}