import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

/// Bentuk TodoNotifier yang persis sama dari Lab 03. Logika bisnis
/// seperti ini — tanpa widget Flutter sama sekali — adalah tepat yang
/// murah dan bernilai untuk di-unit-test, itulah inti lab ini. Lihat
/// test/todo_notifier_test.dart.
class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 0;

  @override
  List<Todo> build() => const [];

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
}

final todosProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);
