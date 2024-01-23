
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_with_hive/todo_model.dart';
import 'package:todo_with_hive/todo_service.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

 final TextEditingController textFieldController = TextEditingController();
 final TodoService todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Todo List'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoModel>('todoBox').listenable(),
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var todo = value.getAt(index);
              return ListTile(
                title: Text(todo!.title),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    todoService.updateTask(todo, index);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    todoService.deletetask(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogBox(context, textFieldController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

showDialogBox(BuildContext context, TextEditingController textFieldController) {
  final TodoService todoService = TodoService();
  showDialog(
    context: context,
    builder: (context)  => 
    AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: textFieldController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async{
              String itemName = textFieldController.text.trim();
              debugPrint('Added item: $itemName');

              // store task in hive
              await todoService.addTask(TodoModel(itemName.toString(), false));

              // close the pop up
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
    ),
  );
}
