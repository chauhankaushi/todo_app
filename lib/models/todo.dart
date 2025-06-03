class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({required this.id, required this.title, required this.isCompleted});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isCompleted': isCompleted};
  }
}
