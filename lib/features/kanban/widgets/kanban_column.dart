import 'package:flutter/material.dart';
import 'package:kanban_board/core/utils/models.dart';
import 'package:kanban_board/features/kanban/widgets/task_card.dart';

class KanbanColumn extends StatelessWidget {
  final TaskStatus status;
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskDropped;

  const KanbanColumn({
    super.key,
    required this.status,
    required this.tasks,
    required this.onTaskDropped,
  });

  String get statusLabel {
    switch (status) {
      case TaskStatus.toDo:
        return "📝 To Do";
      case TaskStatus.inProgress:
        return "🚧 In Progress";
      case TaskStatus.done:
        return "✅ Done";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskModel>(
      onWillAcceptWithDetails : (_) => true,
      onAccept: onTaskDropped,
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              Text(statusLabel, style: Theme.of(context).textTheme.titleLarge),
              Divider(),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, index) {
                    return Draggable<TaskModel>(
                      data: tasks[index],
                      feedback: Material(
                        child: TaskCard(task: tasks[index]),
                        elevation: 6,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: TaskCard(task: tasks[index]),
                      ),
                      child: TaskCard(task: tasks[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
