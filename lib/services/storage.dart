import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://money-goals-flutter.appspot.com/");

  Future<String> uploadProfileImage(File image, String userId) async {
    String path = 'profileImages/$userId';
    var uploadTask = _storage.ref().child(path).putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
