class Todo {
  const Todo({required this.id, required this.title, this.completed = false});

  final String id;
  final String title;
  final bool completed;

  Todo copyWith({bool? completed}) {
    return Todo(id: id, title: title, completed: completed ?? this.completed);
  }
}
