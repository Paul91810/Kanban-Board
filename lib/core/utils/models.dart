import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { toDo, inProgress, done }

class TaskModel {
  String id;
  String title;
  String description;
  TaskStatus status;
  String assignedTo;
  DateTime updatedAt;
  String updatedBy;
  List<String> attachments;
  List<String> pendingFiles; 
  bool isSynced;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.updatedAt,
    required this.updatedBy,
    required this.attachments,
    this.pendingFiles = const [],
    this.isSynced = true,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data, String id) {
    return TaskModel(
      id: id,
      title: data['title'],
      description: data['description'],
      status: TaskStatus.values.firstWhere((e) => e.name == data['status']),
      assignedTo: data['assignedTo'],
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'],
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'assignedTo': assignedTo,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'attachments': attachments,
    };
  }
}
