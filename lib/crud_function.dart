//This dart contains create, read for Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constant.dart';

//Insert to Firestore
void createData(String code)
{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference qrhistory = firestore.collection(collectionName);
  Map<String,String> dataToSave ={fieldName:code};
  firestore.collection(collectionName).add(dataToSave);
}



