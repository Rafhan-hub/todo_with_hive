import 'package:flutter/material.dart';
import 'package:todo_with_hive/task_widget.dart';
import 'package:todo_with_hive/todo_service.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({super.key});

  final TodoService todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: todoService.fetchAllData(), 
      builder:(context, snapshot) {
        if(snapshot.hasData) {
          return TaskScreen();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

