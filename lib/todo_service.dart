import 'package:hive/hive.dart';
import 'package:todo_with_hive/todo_model.dart';

class TodoService {

  final String boxName = 'todoBox';
  Future<Box<TodoModel>> get _box async => await Hive.openBox<TodoModel>(boxName);

  Future<void> addTask (TodoModel todoModel) async{

    var box = await _box;
    box.add(todoModel);

  }

  Future<List<TodoModel>> fetchAllData () async{

    var box = await _box;
    return box.values.toList();

  }

  Future<void> deletetask(int index) async{

    var box = await _box;
    box.deleteAt(index);

  }

  Future<void> updateTask(TodoModel todoModel, int index, {bool isEditTitle = false}) async{
    var box = await _box;
    if(!isEditTitle) {
      todoModel.isCompleted = !todoModel.isCompleted;
    }
    await box.putAt(index, todoModel);
  }
}