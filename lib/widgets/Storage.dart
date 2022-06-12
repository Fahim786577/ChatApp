import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {

final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

Future uploadFile(String filePath, String? fileName)async{
    File file = File(filePath);

    try{
      firebase_storage.TaskSnapshot taskSnapshot = await storage.ref('profilepics/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;

    }on firebase_core.FirebaseException catch(e){
      print(e);
    }


  }

}