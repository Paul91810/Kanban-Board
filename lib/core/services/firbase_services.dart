import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addTask() async {
  final taskId = FirebaseFirestore.instance.collection('tasks').doc().id;

  await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
    'title': 'Design UI',
    'description': 'Create wireframes for the app',
    'status': 'To Do',
    'assignedTo': 'user_id_123',
    'updatedAt': FieldValue.serverTimestamp(),
    'updatedBy': 'user_id_123',
    'attachments': [
      'https://firebasestorage.googleapis.com/.../file1.png',
      'https://firebasestorage.googleapis.com/.../file2.pdf',
    ],
  });
}



