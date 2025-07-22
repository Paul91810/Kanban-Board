import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text("Assigned: ${task.assignedTo}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (!task.isSynced)
              Text("⏳ Unsynced", style: TextStyle(fontSize: 12, color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }
}
