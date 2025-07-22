import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/helps.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:kanban_board/features/kanban/controllers/taskpr_controller.dart';
import 'package:kanban_board/features/kanban/controllers/uplode_controller.dart';
import 'package:kanban_board/features/kanban/widgets/add_task_dialog.dart';
import 'package:kanban_board/features/kanban/widgets/kanban_column.dart';
import 'package:provider/provider.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final uploadProvider = Provider.of<UploadProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Now',
            onPressed: () async {
              final syncManager = SyncManager(taskProvider, uploadProvider);
              await syncManager.syncAll();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sync completed')));
            },
          ),
        ],
      ),
      body: Row(
        children: TaskStatus.values.map((status) {
          final statusTasks = taskProvider.getByStatus(status);

          return Expanded(
            child: KanbanColumn(
              status: status,
              tasks: statusTasks,
              onTaskDropped: (task) {
                task.status = status;
                task.updatedAt = DateTime.now();
                task.updatedBy = 'user_id';
                task.isSynced = false;

                taskProvider.updateTask(task);
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(
              onTaskCreated: (newTask) {
                taskProvider.addTask(newTask);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          tasks.any((t) => !t.isSynced || t.pendingFiles.isNotEmpty)
          ? Container(
              color: Colors.orange.shade100,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("⏳ Some tasks are pending sync or upload..."),
                  TextButton.icon(
                    icon: const Icon(Icons.sync),
                    label: const Text("Sync Now"),
                    onPressed: () async {
                      final syncManager = SyncManager(
                        taskProvider,
                        uploadProvider,
                      );
                      await syncManager.syncAll();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sync completed')),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
