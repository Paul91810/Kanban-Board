import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadFile(String taskId, File file) async {
    final storageRef = FirebaseStorage.instance
        .ref('task_attachments/$taskId/${file.path.split('/').last}');

    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }
}
