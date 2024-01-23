import 'package:hive_flutter/hive_flutter.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {

  @HiveField(0)
  final String title;

  @HiveField(1, defaultValue: false)
  bool isCompleted;

  TodoModel(this.title, this.isCompleted);
}