import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class DatabaseMethods{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future uploadFile(String filePath, String fileName)async{
    File file = File(filePath);

    try{
      firebase_storage.TaskSnapshot taskSnapshot = await storage.ref('profilepics/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
     
      return downloadUrl;
      

    }on firebase_core.FirebaseException catch(e){
      print(e);
    }


  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }
  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}