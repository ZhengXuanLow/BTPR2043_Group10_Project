import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'constant.dart';

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
              //onTap Copy to Clipboard
              Alert(
                context: context,
                type: AlertType.success,
                title: "Copied to the clipboard.",
                desc: "$history have copied to the clipboard.",
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
              Clipboard.setData(ClipboardData(text:history));
            },
          );
        },
      ),
    );
  }
}