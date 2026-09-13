import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 0;

  @override
  List<Todo> build() {
    return const [];
  }

  void addTodo(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    state = [...state, Todo(id: '${_nextId++}', title: trimmed)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void clearCompleted() {
    state = state.where((todo) => !todo.completed).toList();
  }
}

final todosProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);
