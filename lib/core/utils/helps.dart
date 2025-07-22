import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:kanban_board/features/kanban/controllers/taskpr_controller.dart';
import 'package:kanban_board/features/kanban/controllers/uplode_controller.dart';

class SyncManager {
  final TaskProvider taskProvider;
  final UploadProvider uploadProvider;

  SyncManager(this.taskProvider, this.uploadProvider);

  Future<void> syncAll() async {
    for (final task in taskProvider.unsyncedTasks) {
      final ref = FirebaseFirestore.instance.collection('tasks').doc(task.id);
      final doc = await ref.get();

      if (doc.exists) {
        final remote = TaskModel.fromMap(doc.data()!, doc.id);
        final merged = _merge(task, remote);
        await uploadProvider.uploadPendingFiles(merged, taskProvider);
        await ref.set(merged.toMap());
        taskProvider.markSynced(merged);
      } else {
        await uploadProvider.uploadPendingFiles(task, taskProvider);
        await ref.set(task.toMap());
        taskProvider.markSynced(task);
      }
    }
  }

  TaskModel _merge(TaskModel local, TaskModel remote) {
    return TaskModel(
      id: local.id,
      title: local.updatedAt.isAfter(remote.updatedAt) ? local.title : remote.title,
      description: local.updatedAt.isAfter(remote.updatedAt) ? local.description : remote.description,
      status: local.updatedAt.isAfter(remote.updatedAt) ? local.status : remote.status,
      assignedTo: local.assignedTo,
      updatedAt: DateTime.now(),
      updatedBy: local.updatedBy,
      attachments: {...local.attachments, ...remote.attachments}.toList(),
      isSynced: true,
    );
  }
}
