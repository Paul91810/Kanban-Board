import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends StatefulWidget {
  final void Function(TaskModel) onTaskCreated;

  const AddTaskDialog({super.key, required this.onTaskCreated});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  List<String> pickedFilePaths = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        pickedFilePaths.addAll(result.paths.whereType<String>());
      });
    }
  }

  void _createTask() {
    if (_titleController.text.isEmpty) return;

    final task = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      status: TaskStatus.toDo,
      assignedTo: 'user_id', // Replace with actual user if needed
      updatedAt: DateTime.now(),
      updatedBy: 'user_id',
      attachments: [],
      pendingFiles: pickedFilePaths,
      isSynced: false,
    );

    widget.onTaskCreated(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text("Attach Files"),
            ),
            if (pickedFilePaths.isNotEmpty)
              Column(
                children: pickedFilePaths
                    .map((e) => ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(File(e).path.split('/').last),
                        ))
                    .toList(),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _createTask,
          child: const Text("Add Task"),
        ),
      ],
    );
  }
}
