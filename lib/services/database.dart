import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
//Create
  Future addStudentsDetails(
      Map<String, dynamic> studentInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Students")
        .doc(id)
        .set(studentInfoMap);
  }

//Read
  Future<Stream<QuerySnapshot>> getStudentsDetails() async {
    return await FirebaseFirestore.instance.collection("Students").snapshots();
  }

//Update
  Future updateStudentsDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Students")
        .doc(id)
        .update(updateInfo);
  }

//Delete
  Future deleteStudentsDetails(String id) async {
    return await FirebaseFirestore.instance.collection("Students").doc(id);
  }
}
