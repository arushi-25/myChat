import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService();

  Future<String> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    try {
      Reference fileRef = _firebaseStorage
          .ref('users/pfps')
          .child('$uid${p.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        return await fileRef.getDownloadURL();
      } else {
        throw Exception('File upload failed');
      }
    } catch (e) {
      throw Exception('Error uploading profile picture: $e');
    }
  }
  Future<String?> uploadImageChat({
    required File file, required String chatID}) async{
      Reference fileRef = _firebaseStorage
         .ref('chats/$chatID')
         .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
      UploadTask task = fileRef.putFile(file);
      return task.then((p){
        if(p.state == TaskState.success){
          return fileRef.getDownloadURL();
        }
      });
  }
}
