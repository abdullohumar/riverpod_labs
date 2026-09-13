import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/todo.dart';

/// LAB 04 — COMPUTED / DERIVED PROVIDERS (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.
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

// TODO(1): Deklarasikan `filterProvider`, sebuah `StateProvider<TodoFilter>`
// yang mulai dari `TodoFilter.all`.

// TODO(2): Deklarasikan `filteredTodosProvider`, sebuah
// `Provider<List<Todo>>` yang:
//   - meng-watch `filterProvider` dan `todosProvider`
//   - mengembalikan `todos` apa adanya saat filter `.all`
//   - mengembalikan hanya todo yang belum selesai saat filter `.active`
//   - mengembalikan hanya todo yang sudah selesai saat filter `.completed`
// Hint: switch EXPRESSION cocok dipakai di sini:
//   return switch (filter) {
//     TodoFilter.all => todos,
//     TodoFilter.active => ...,
//     TodoFilter.completed => ...,
//   };
