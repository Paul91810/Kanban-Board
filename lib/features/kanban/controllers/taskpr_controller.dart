import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get unsyncedTasks => _tasks.where((t) => !t.isSynced).toList();

  void loadFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    _tasks = snapshot.docs.map((doc) => TaskModel.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i != -1) _tasks[i] = task;
    notifyListeners();
  }

  void markSynced(TaskModel task) {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i != -1) {
      _tasks[i].isSynced = true;
      _tasks[i].pendingFiles.clear();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  List<TaskModel> getByStatus(TaskStatus status) => _tasks.where((t) => t.status == status).toList();
}
