import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscanner/crud_function.dart';
import 'constant.dart';
import 'package:qrscanner/qr_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';


class ResultScreen extends StatefulWidget {

  //Set up some variable to use
  final String code;
  final Function() closeScreen;

  ResultScreen({super.key,required this.closeScreen,required this.code});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //createData(code);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton
          (onPressed: (){
            widget.closeScreen();
            Navigator.pop(context);
        },
            icon:const Icon
              (Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,)),
        centerTitle: true,
        title: Text("QRScanner",
            style: TextStyle(
              color: Colors.black87,
              fontWeight:FontWeight.bold,
              letterSpacing: 1.0,
            )),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Show QR Code here

            QrImage(
                data: widget.code, //pass the code here
                size:150,
                version: QrVersions.auto),


            const Text("Scanned Result",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight:FontWeight.bold,
                letterSpacing: 1.0,
              )),

            SizedBox(
                height:10
            ),

            Text("${widget.code}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: 1.0,
                )),

            SizedBox(
                height:10
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width-100,
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 55.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: Size(180, 50),
                    ),


                    onPressed: () async {
                      String url = widget.code;
                      final uri = Uri.parse(url);

                      if (await canLaunchUrl(uri))
                        {
                          await launchUrl(uri);

                        }else {
                        Clipboard.setData(ClipboardData(text:widget.code));
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "This is not a link.",
                          desc: "The system have already copy ${widget.code} to cilpbaord for further use.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Ok",
                                style: TextStyle(color: Colors.black54, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                    }
                      },

                    child:
                  Text("Open in Browser",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        letterSpacing: 1.0,
                      )),),

                  IconButton(onPressed:(){
                    setState(() {
                      //onTap Copy to Clipboard
                      Clipboard.setData(ClipboardData(text:widget.code));
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Copied to the clipboard.",
                        desc: "${widget.code} have copied to the clipboard.",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Ok",
                              style: TextStyle(color: Colors.black54, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    });

                  },icon:Icon(Icons.copy, color: Colors.blue)),
                ],
              ),
            )

          ]

        ),
      )
    );
  }
}


