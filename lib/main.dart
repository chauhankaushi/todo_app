import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/todo.dart';

void main() {
  runApp(TodoApp());
}

// ignore: use_key_in_widget_constructors
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class TodoScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    setState(() => isLoading = true);
    try {
      todos = await ApiService.fetchTodos();
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> addTodo() async {
    if (controller.text.trim().isEmpty) return;
    await ApiService.addTodo(controller.text.trim());
    controller.clear();
    loadTodos();
  }

  Future<void> toggleTodo(Todo todo) async {
    await ApiService.toggleComplete(todo.id, !todo.isCompleted);
    loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await ApiService.deleteTodo(id);
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Enter new todo',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(onPressed: addTodo, child: Text('Add')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration:
                                  todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => toggleTodo(todo),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteTodo(todo.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
