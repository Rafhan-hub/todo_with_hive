
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
      body: SafeArea(
        child: ValueListenableBuilder(
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
                  trailing: Wrap(
                    spacing: 0, 
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async{
                          await editDialogBox(context, todo, index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          todoService.deletetask(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
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
        title: const Text('Add Task'),
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
              debugPrint('Task : $itemName');

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

editDialogBox(BuildContext context, TodoModel todo, int index) {
  final TodoService todoService = TodoService();
  TextEditingController textFieldController = TextEditingController();
  textFieldController.text = todo.title;
  bool isChecked = todo.isCompleted;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  todoService.updateTask(todo, index);
                },
              ),
              Expanded(
                child: TextField(
                  controller: textFieldController,
                ),
              ),
            ],
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
          onPressed: () async {
            String itemName = textFieldController.text.trim();

            // update task in hive
            todoService.updateTask(TodoModel(itemName, todo.isCompleted), index, isEditTitle: true);

            // close the pop-up
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
