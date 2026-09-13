import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_providers.dart';

/// LAB 04 — COMPUTED / DERIVED PROVIDERS (starter)
///
/// Mulai dari providers/todo_providers.dart (TODO 1-2), baru kembali ke
/// sini untuk TODO 3-5.

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
    // TODO(3): Watch `filteredTodosProvider` (BUKAN todosProvider
    // langsung) ke dalam `visibleTodos`, dan watch `filterProvider` ke
    // dalam `filter`.
    const visibleTodos = <dynamic>[];
    const filter = TodoFilter.all;

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
                // TODO(4): Set state filterProvider menjadi selection.first.
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
                        value: todo.completed as bool,
                        onChanged: (_) => ref.read(todosProvider.notifier).toggle(todo.id as String),
                        title: Text(
                          todo.title as String,
                          style: todo.completed == true
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

/// TODO(5): Buat badge ini meng-watch, lewat `.select`, HANYA JUMLAH todo
/// yang selesai dari `todosProvider` — bukan seluruh list-nya.
/// Hint:
///   ref.watch(todosProvider.select((todos) => todos.where((t) => t.completed).length))
/// Penghitung `(rebuilt Nx)` adalah instrumentasi: begitu ini benar,
/// menambah todo baru (yang belum selesai) TIDAK boleh menambah
/// angkanya, hanya meng-toggle status selesai yang boleh.
class _CompletedBadge extends ConsumerWidget {
  const _CompletedBadge();

  static int _builds = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const completedCount = 0;
    _builds++;
    return Chip(label: Text('$completedCount done (rebuilt ${_builds}x)'));
  }
}
