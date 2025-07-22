import 'package:flutter/material.dart';

class AddTaskProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final List<String> pickedFilePaths = [];

  void addFiles(List<String> paths) {
    pickedFilePaths.addAll(paths);
    notifyListeners();
  }

  void disposeControllers() {
    titleController.dispose();
    descController.dispose();
  }

  void reset() {
    titleController.clear();
    descController.clear();
    pickedFilePaths.clear();
    notifyListeners();
  }
}
