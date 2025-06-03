import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final data = await ApiService.fetchTodos();
    setState(() => todos = data);
  }

  Future<void> addTodo() async {
    if (_controller.text.trim().isEmpty) return;
    await ApiService.addTodo(_controller.text.trim());
    _controller.clear();
    fetchTodos();
  }

  Future<void> toggleTodo(Todo todo) async {
    await ApiService.toggleComplete(todo.id, !todo.isCompleted);
    fetchTodos();
  }

  Future<void> deleteTodo(String id) async {
    await ApiService.deleteTodo(id);
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My To-Do App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a new to-do',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: addTodo),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchTodos,
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (_, index) {
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
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteTodo(todo.id),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
