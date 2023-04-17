//This dart contains create, read for Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Insert to Firestore
void createData(String code)
{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference qrhistory = firestore.collection('history');
  Map<String,String> dataToSave ={'qrhistory':code};
  firestore.collection('history').add(dataToSave);
}



