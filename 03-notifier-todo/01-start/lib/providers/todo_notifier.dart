import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

/// LAB 03 — NOTIFIER (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.
class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 0;

  // TODO(1): Implementasikan `build()` supaya mengembalikan state awal:
  // list Todo kosong dan const (`const []`).
  @override
  List<Todo> build() {
    throw UnimplementedError();
  }

  void addTodo(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    // TODO(2): Set `state` menjadi list BARU berisi semua yang sedang ada
    // di `state`, ditambah `Todo(id: '${_nextId++}', title: trimmed)` yang
    // baru.
    // Hint: spread operator -> `[...state, newTodo]`.
    // JANGAN panggil state.add(...) — itu memutasi list di tempat dan
    // Riverpod tidak akan mendeteksi perubahannya.
  }

  void toggle(String id) {
    // TODO(3): Set `state` menjadi list baru di mana Todo yang cocok
    // dengan `id` nilai `completed`-nya dibalik
    // (`todo.copyWith(completed: !todo.completed)`), dan Todo lainnya
    // dibiarkan apa adanya.
    // Hint: list-literal dengan `for` loop dan `if/else`:
    //   [for (final todo in state) if (todo.id == id) ... else todo]
  }

  void remove(String id) {
    // TODO(4): Set `state` menjadi list baru dengan Todo yang cocok
    // `id`-nya dihapus. Hint: `state.where(...).toList()`.
  }

  void clearCompleted() {
    // TODO(5): Set `state` menjadi list baru yang hanya menyisakan todo
    // yang BELUM selesai.
  }
}

// TODO(6): Buat `todosProvider`, sebuah
// `NotifierProvider<TodoNotifier, List<Todo>>` dibangun dari `TodoNotifier.new`.
