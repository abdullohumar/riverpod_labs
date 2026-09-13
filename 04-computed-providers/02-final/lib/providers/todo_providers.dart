import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/todo.dart';

class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 3;

  @override
  List<Todo> build() {

    return const [
      Todo(id: '0', title: 'Learn Provider', completed: true),
      Todo(id: '1', title: 'Learn StateProvider', completed: true),
      Todo(id: '2', title: 'Learn Notifier', completed: false),
    ];
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
}

final todosProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);

enum TodoFilter { all, active, completed }

final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);
  final todos = ref.watch(todosProvider);

  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((t) => !t.completed).toList(),
    TodoFilter.completed => todos.where((t) => t.completed).toList(),
  };
});
