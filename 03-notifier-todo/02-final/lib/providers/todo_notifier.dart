import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

/// `Notifier<T>` adalah cara modern yang direkomendasikan untuk menyimpan
/// state yang butuh logika sungguhan (banyak operasi, validasi, lebih
/// dari satu field). Bandingkan dengan `StateProvider` dari Lab 02: di
/// sana, mengubah state cukup satu baris dari UI (`state++`). Di sini, UI
/// tidak pernah menyentuh `state` secara langsung — dia hanya memanggil
/// method bernama (`addTodo`, `toggle`, `remove`). Notifier adalah
/// satu-satunya tempat yang tahu BAGAIMANA state berubah; UI hanya tahu
/// APA yang ingin terjadi. Pemisahan ini yang membuat logika bisnis bisa
/// di-test secara terisolasi (lihat Lab 10).
class TodoNotifier extends Notifier<List<Todo>> {
  int _nextId = 0;

  // `build` menggantikan constructor: dia mengembalikan state AWAL, dan
  // Riverpod akan memanggilnya lagi secara otomatis kalau notifier ini
  // dibuat ulang (misalnya setelah `ref.invalidate`, atau dengan
  // autoDispose — Lab 08).
  @override
  List<Todo> build() {
    return const [];
  }

  void addTodo(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    // Jangan pernah memutasi `state` di tempat (bukan `state.add(...)`).
    // Riverpod mendeteksi perubahan lewat identity/equality — mengganti
    // `state` dengan list baru itulah yang benar-benar memberi tahu
    // listener. Ini juga menjaga referensi lama (misalnya yang tertangkap
    // di build sebelumnya) tetap aman secara immutable.
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
