import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:kanban_board/features/kanban/controllers/taskpr_controller.dart';
import 'package:path/path.dart';

class UploadProvider with ChangeNotifier {
  Map<String, double> progress = {};

  Future<void> uploadPendingFiles(TaskModel task, TaskProvider taskProvider) async {
    List<String> uploaded = [];

    for (String path in List.from(task.pendingFiles)) {
      try {
        final file = File(path);
        final ref = FirebaseStorage.instance.ref('tasks/${task.id}/${basename(path)}');
        final taskSnap = ref.putFile(file);

        taskSnap.snapshotEvents.listen((e) {
          progress[task.id] = e.bytesTransferred / e.totalBytes;
          notifyListeners();
        });

        final url = await (await taskSnap).ref.getDownloadURL();
        uploaded.add(url);
        task.pendingFiles.remove(path);
      } catch (_) {}
    }

    task.attachments.addAll(uploaded);
    progress.remove(task.id);
    taskProvider.markSynced(task);
    notifyListeners();
  }
}
