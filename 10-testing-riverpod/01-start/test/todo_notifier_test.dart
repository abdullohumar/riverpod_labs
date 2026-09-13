import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_testing_app/providers/todo_notifier.dart';

/// LAB 10 — TESTING RIVERPOD (starter, bagian 1: menguji sebuah Notifier)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.
///
/// Pola untuk setiap test di sini sama:
///   1. final container = ProviderContainer.test();
///   2. lakukan sesuatu lewat container.read(todosProvider.notifier)
///   3. assert atas container.read(todosProvider)
void main() {
  // TODO(1): Tulis test bernama 'starts empty' yang membuat
  // `ProviderContainer.test()` dan meng-assert `container.read(todosProvider)`
  // kosong.

  // TODO(2): Tulis test bernama 'addTodo appends a new, incomplete todo'
  // yang memanggil `container.read(todosProvider.notifier).addTodo('Buy milk')`
  // dan meng-assert list hasilnya panjang 1, dengan title 'Buy milk' dan
  // completed == false.

  // TODO(3): Tulis test bernama
  // 'addTodo ignores blank/whitespace-only titles' yang memanggil
  // addTodo('   ') dan meng-assert list-nya tetap kosong.

  // TODO(4): Tulis test bernama 'toggle flips only the matching todo'
  // yang menambah dua todo, meng-toggle id yang PERTAMA, dan meng-assert
  // hanya yang itu yang sekarang completed (yang satunya tetap false).

  // TODO(5): Tulis test bernama 'remove deletes the matching todo' yang
  // menambah satu todo, menghapusnya berdasarkan id, dan meng-assert
  // list-nya kosong.

  // TODO(6): Tulis test bernama
  // 'a widget watching todosProvider is notified on change' yang memakai
  // `container.listen(todosProvider, (previous, next) { ... },
  // fireImmediately: false)` untuk menghitung berapa kali provider-nya
  // berubah, menambah dua todo, dan meng-assert callback-nya terpicu
  // tepat dua kali.
}
