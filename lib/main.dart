import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kanban_board/features/kanban/controllers/add_task_controller.dart';
import 'package:kanban_board/features/kanban/controllers/conectivity_controller.dart';
import 'package:kanban_board/features/kanban/controllers/taskpr_controller.dart';
import 'package:kanban_board/features/kanban/controllers/uplode_controller.dart';
import 'package:kanban_board/features/kanban/screens/kaban_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => AddTaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(), home: const KanbanScreen());
  }
}
