import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_testing_app/providers/todo_notifier.dart';

/// LAB 10 — TESTING RIVERPOD (bagian 1: menguji sebuah Notifier)
///
/// Inti dari semuanya: logika `TodoNotifier` bisa diuji TANPA memompa
/// (pump) satu widget pun. `ProviderContainer` adalah padanan "tanpa
/// kepala" dari `ProviderScope` — dia menyimpan state provider, tapi
/// sama sekali tidak ada widget tree yang menempel padanya.
void main() {
  test('starts empty', () {
    // ProviderContainer.test() men-dispose dirinya sendiri secara
    // otomatis di akhir test ini (lewat addTearDown) — tidak perlu
    // memanggil container.dispose() sendiri.
    final container = ProviderContainer.test();

    expect(container.read(todosProvider), isEmpty);
  });

  test('addTodo appends a new, incomplete todo', () {
    final container = ProviderContainer.test();

    container.read(todosProvider.notifier).addTodo('Buy milk');

    final todos = container.read(todosProvider);
    expect(todos, hasLength(1));
    expect(todos.single.title, 'Buy milk');
    expect(todos.single.completed, isFalse);
  });

  test('addTodo ignores blank/whitespace-only titles', () {
    final container = ProviderContainer.test();

    container.read(todosProvider.notifier).addTodo('   ');

    expect(container.read(todosProvider), isEmpty);
  });

  test('toggle flips only the matching todo', () {
    final container = ProviderContainer.test();
    final notifier = container.read(todosProvider.notifier);
    notifier.addTodo('Buy milk');
    notifier.addTodo('Walk the dog');
    final targetId = container.read(todosProvider).first.id;

    notifier.toggle(targetId);

    final todos = container.read(todosProvider);
    expect(todos.firstWhere((t) => t.id == targetId).completed, isTrue);
    expect(todos.where((t) => t.id != targetId).single.completed, isFalse);
  });

  test('remove deletes the matching todo', () {
    final container = ProviderContainer.test();
    final notifier = container.read(todosProvider.notifier);
    notifier.addTodo('Buy milk');
    final id = container.read(todosProvider).single.id;

    notifier.remove(id);

    expect(container.read(todosProvider), isEmpty);
  });

  test('a widget watching todosProvider is notified on change', () {
    final container = ProviderContainer.test();
    var callCount = 0;

    // container.listen adalah padanan ref.listen (Lab 02) di luar
    // widget — berguna untuk memastikan BERAPA KALI sebuah provider
    // berubah, bukan cuma nilai akhirnya.
    container.listen(todosProvider, (previous, next) => callCount++, fireImmediately: false);

    container.read(todosProvider.notifier).addTodo('Buy milk');
    container.read(todosProvider.notifier).addTodo('Walk the dog');

    expect(callCount, 2);
  });
}
