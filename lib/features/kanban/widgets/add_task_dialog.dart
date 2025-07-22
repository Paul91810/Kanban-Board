import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:kanban_board/features/kanban/controllers/add_task_controller.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends StatelessWidget {
  final void Function(TaskModel) onTaskCreated;

  const AddTaskDialog({super.key, required this.onTaskCreated});

  Future<void> _pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      final paths = result.paths.whereType<String>().toList();
      context.read<AddTaskProvider>().addFiles(paths);
    }
  }

  void _createTask(BuildContext context) {
    final provider = context.read<AddTaskProvider>();

    if (provider.titleController.text.isEmpty) return;

    final task = TaskModel(
      id: const Uuid().v4(),
      title: provider.titleController.text,
      description: provider.descController.text,
      status: TaskStatus.toDo,
      assignedTo: 'user_id',
      updatedAt: DateTime.now(),
      updatedBy: 'user_id',
      attachments: [],
      pendingFiles: provider.pickedFilePaths,
      isSynced: false,
    );

    onTaskCreated(task);
    provider.reset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskProvider>(
      builder: (context, provider, _) => 
      
      
      AlertDialog(
        title: const Text('Create New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: provider.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: provider.descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _pickFiles(context),
                icon: const Icon(Icons.attach_file),
                label: const Text("Attach Files"),
              ),
              if (provider.pickedFilePaths.isNotEmpty)
                Column(
                  children: provider.pickedFilePaths
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
            onPressed: () {
              provider.reset();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => _createTask(context),
            child: const Text("Add Task"),
          ),
        ],
      ),
    );
  }
}
