import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:qrscanner/qr_scanner.dart';
import 'package:qrscanner/result_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'constant.dart';
import 'crud_function.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  //Creating variable to use for connection and list.
  CollectionReference historyRefs = FirebaseFirestore.instance.collection('history');
  List<String> historyList = [];


  @override
  //Run once on this page
  void initState() {
    super.initState();
    getHistory();
  }

  //Get the file from the firestore and insert to the list.
  Future<void> getHistory() async {
    QuerySnapshot querySnapshot = await historyRefs.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    documents.forEach((document) {
      String qrhistory = document[fieldName];
      setState(() {
        historyList.add(qrhistory);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton
          (onPressed: (){

          Navigator.pop(context);
        },
            icon:const Icon
              (Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,)),
        centerTitle: true,

        actions:[

          IconButton(onPressed:(){

            Alert(
              context: context,
              type: AlertType.warning,
              title: "Delete",
              desc: "Are you sure to delete all the history?",
              buttons: [
                DialogButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  //onPressed then delete the history
                  onPressed: ()  {
                    deleteCollection();
                    historyList.clear();
                    Navigator.pop(context);
                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "Success",
                      desc: "All the history deleted.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.black54, fontSize: 20),
                          ),
                          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=> QRScanner())),
                          width: 120,
                        )
                      ],
                    ).show();
                    },
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

            //Change the icon colour according to true or flash.
          },icon:Icon(Icons.delete, color: Colors.grey)),

        ],

        title: Text("History",
            style: TextStyle(
              color: Colors.black87,
              fontWeight:FontWeight.bold,
              letterSpacing: 1.0,
            )),

      ),

      //Create listview in the app
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (BuildContext context, int index) {
          String history = historyList[index];
          return ListTile(
            title: Text(history),
            onTap: () {
              //navigate to result_screen with history detail.
              Navigator.push(context,MaterialPageRoute(builder: (context)=> ResultScreen(closeScreen: closeScreen,code:history)));
            },
          );
        },
      ),
    );
  }
}

void closeScreen()
{

}