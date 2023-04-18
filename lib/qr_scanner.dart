import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrscanner/historyPage.dart';
import 'package:qrscanner/overlay.dart';
import 'package:qrscanner/result_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'constant.dart';


class QRScanner extends StatefulWidget {

  QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  //Create a boolean to control Scan, flashlight, and camera
  bool isScanComplete = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  MobileScannerController controller = MobileScannerController();

  //To control the boolean when we close screen, reset to false.
  void closeScreen()
  {
    isScanComplete = false;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(

        leading: IconButton
          (onPressed: (){

          Alert(
            context: context,
            type: AlertType.warning,
            title: "Exit?",
            desc: "Are you sure to exit?",
            buttons: [
              DialogButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                //onPressed then quit the app.
                onPressed: () => SystemNavigator.pop(),
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
              DialogButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(189, 2, 2, 1.0),
                  Color.fromRGBO(189, 2, 2, 1.0)
                ]),
              )
            ],
          ).show();

        },
            icon:const Icon
              (Icons.exit_to_app,
              color: Colors.black87,)),

        actions:[

          IconButton(onPressed:(){

            Navigator.push(context,MaterialPageRoute(builder: (context)=> HistoryPage()));

            //Change the icon colour according to true or flash.
          },icon:Icon(Icons.history, color: Colors.grey)),
          //Toggle torch function
          IconButton(onPressed:(){
            setState(() {
              isFlashOn = !isFlashOn;
            });
            controller.toggleTorch();
            //Change the icon colour according to true or flash.
          },icon:Icon(Icons.flash_on, color: isFlashOn ? Colors.blue:Colors.grey)),
          //Switch camera function
          IconButton(onPressed:(){
            setState(() {
              isFrontCamera = !isFrontCamera;
            });
            controller.switchCamera();
          },icon:Icon(Icons.camera_front, color: isFrontCamera ? Colors.blue:Colors.grey)),
        ],

        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,



        title: Text("QRScanner",
            style: TextStyle(
              color: Colors.black87,
              fontWeight:FontWeight.bold,
              letterSpacing: 1.0,
            )),


      ),

      body: Container(
        width: double.infinity,
        padding:EdgeInsets.all(16),
        child: Column(
          children:[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Place a QR code in the area",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize:18,
                  fontWeight:FontWeight.bold,
                  letterSpacing: 1.0,
                )),

                //To create a gap between two text
                SizedBox(
                  height:10,
                ),

                Text('Scanning will be started automatically',
                style: TextStyle(
                  fontSize:16,
                  color: Colors.black54,
                )),
              ]
            )),

            Expanded(
                flex:4,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      allowDuplicates: true,
                      onDetect: (barcode,args) {
                        //Run the code when isScanComplete is false
                        if (!isScanComplete) {

                          //if is null then 3 dash.
                          String code = barcode.rawValue ?? '---';

                          //Set to true when the scan is complete
                          isScanComplete = true;

                          //To pass the value and navigate to ResultScreen  and show the result
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> ResultScreen(closeScreen: closeScreen,code:code)));



                        }
                      }
                  ),
                    //Make it looks like a QR SCanner
                    const QRScannerOverlay(overlayColour: bgColor),
                  ],
                )
            ),
            Expanded(child: Container(
              alignment:Alignment.center,
              child:
              Text("Developed By Group 10 - BTPR2043",
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    color: Colors.black87,
                    fontSize:14,
                    letterSpacing: 1.0,
                  )),
            )),
          ]
        ),
      ),
    );
  }
}


