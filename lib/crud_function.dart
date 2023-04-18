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

  Future<void> deleteCollection() async {
    // Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        collectionName);

    // Get all the documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Create a batch operation
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Delete each document in the batch
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    // Commit the batch operation
    await batch.commit();
  }

