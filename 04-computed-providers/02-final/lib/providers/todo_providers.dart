import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/todo.dart';

/// LAB 04 — COMPUTED / DERIVED PROVIDERS
///
/// Ide intinya: sebuah `Provider` bisa memanggil `ref.watch` ke provider
/// LAIN di dalam builder-nya sendiri. Riverpod melacak dependency itu
/// secara otomatis. Kalau provider yang di-watch berubah, fungsi provider
/// ini dijalankan ulang, dan apa pun yang meng-watch provider INI juga
/// ikut rebuild — penghitungan ulangnya menjalar persis seperti formula
/// spreadsheet yang bergantung pada sel lain.

class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 3;

  @override
  List<Todo> build() {
    // Diisi data contoh supaya filtering langsung terlihat.
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

/// StateProvider biasa — filter yang sedang dipilih. Tidak ada yang baru
/// di sini, ini pola yang sama dari Lab 02.
final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

/// INILAH PROVIDER TURUNAN (DERIVED). Dia meng-watch KEDUANYA:
/// `todosProvider` dan `filterProvider`. Riverpod menghitung ulang list
/// ini setiap kali SALAH SATU dari keduanya berubah — tambah todo, toggle
/// salah satu, atau ganti filter, dan fungsi provider ini dijalankan
/// ulang lalu setiap widget yang meng-watch-nya ikut rebuild.
///
/// Perhatikan apa yang didapat UI dari ini: tidak ada widget yang perlu
/// tahu bagaimana filtering bekerja. Setiap layar yang butuh "todo yang
/// harus ditampilkan" tinggal meng-watch `filteredTodosProvider` dan
/// mendapat jawaban yang benar, dihitung di tepat satu tempat.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);
  final todos = ref.watch(todosProvider);

  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((t) => !t.completed).toList(),
    TodoFilter.completed => todos.where((t) => t.completed).toList(),
  };
});
