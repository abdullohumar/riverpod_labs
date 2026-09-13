import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_providers.dart';

/// LAB 04 — COMPUTED / DERIVED PROVIDERS
///
/// Lihat providers/todo_providers.dart untuk `filteredTodosProvider`,
/// konsep utamanya. File ini juga mendemonstrasikan `.select` pada widget
/// `_CompletedBadge` di bawah — baca komentarnya baik-baik.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Computed Providers',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget ini hanya pernah meng-watch provider TURUNAN — dia tidak
    // perlu tahu sama sekali bahwa ada filter untuk memutuskan apa yang
    // dirender.
    final visibleTodos = ref.watch(filteredTodosProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Computed Providers'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Center(child: _CompletedBadge()))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'New todo', border: OutlineInputBorder()),
                    onSubmitted: (value) {
                      ref.read(todosProvider.notifier).addTodo(value);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    ref.read(todosProvider.notifier).addTodo(_controller.text);
                    _controller.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SegmentedButton<TodoFilter>(
              segments: const [
                ButtonSegment(value: TodoFilter.all, label: Text('All')),
                ButtonSegment(value: TodoFilter.active, label: Text('Active')),
                ButtonSegment(value: TodoFilter.completed, label: Text('Completed')),
              ],
              selected: {filter},
              onSelectionChanged: (selection) {
                ref.read(filterProvider.notifier).state = selection.first;
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: visibleTodos.isEmpty
                ? const Center(child: Text('Nothing to show for this filter.'))
                : ListView.builder(
                    itemCount: visibleTodos.length,
                    itemBuilder: (context, index) {
                      final todo = visibleTodos[index];
                      return CheckboxListTile(
                        value: todo.completed,
                        onChanged: (_) => ref.read(todosProvider.notifier).toggle(todo.id),
                        title: Text(
                          todo.title,
                          style: todo.completed
                              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// `.select` memungkinkan widget bergantung pada SATU potongan kecil dari
/// nilai sebuah provider, bukan keseluruhannya, jadi dia hanya rebuild
/// saat potongan itu berubah.
///
/// Tanpa `.select`, meng-watch `todosProvider` langsung di sini akan
/// me-rebuild badge ini setiap kali ADA todo yang ditambah, dihapus, atau
/// di-toggle — bahkan saat jumlah yang selesai tidak berubah (misalnya
/// menambah todo baru yang belum dicentang). Dengan `.select`, dia hanya
/// rebuild saat hasil hitungannya sendiri berbeda dari sebelumnya.
///
/// Penghitung `(rebuilt Nx)` di bawah HANYA instrumentasi untuk demo ini
/// — hapus di kode sungguhan. Coba ganti ke `ref.watch(todosProvider)`
/// (list penuh) lalu tambahkan beberapa todo: perhatikan angkanya
/// melompat di setiap penambahan, bukan cuma saat jumlah selesai berubah.
class _CompletedBadge extends ConsumerWidget {
  const _CompletedBadge();

  static int _builds = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(
      todosProvider.select((todos) => todos.where((t) => t.completed).length),
    );
    _builds++;
    return Chip(label: Text('$completedCount done (rebuilt ${_builds}x)'));
  }
}
