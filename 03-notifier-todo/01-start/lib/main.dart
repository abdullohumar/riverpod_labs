import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/todo.dart';
import 'providers/todo_notifier.dart';

/// LAB 03 — NOTIFIER (starter)
///
/// Mulai dari providers/todo_notifier.dart (TODO 1-6), baru kembali ke
/// sini. TODO di file ini mengasumsikan todosProvider sudah ada.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifier Todo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange)),
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

  void _submit() {
    // TODO(7): Panggil `ref.read(todosProvider.notifier).addTodo(...)`
    // dengan teks yang sedang ada di `_controller`, lalu bersihkan
    // controller-nya.
  }

  @override
  Widget build(BuildContext context) {
    // TODO(8): Watch `todosProvider` dan simpan di `todos`.
    const todos = <Todo>[];
    final remaining = todos.where((t) => !t.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo (Notifier)'),
        actions: [
          IconButton(
            tooltip: 'Clear completed',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // TODO(9): Panggil clearCompleted() di notifier.
            },
          ),
        ],
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
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _submit, child: const Text('Add')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('$remaining remaining of ${todos.length}'),
            ),
          ),
          const Divider(),
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('No todos yet — add one above.'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return _TodoTile(todo: todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(color: Colors.red),
      onDismissed: (_) {
        // TODO(10): Panggil remove(todo.id) di notifier.
      },
      child: CheckboxListTile(
        value: todo.completed,
        onChanged: (_) {
          // TODO(11): Panggil toggle(todo.id) di notifier.
        },
        title: Text(
          todo.title,
          style: todo.completed
              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
              : null,
        ),
      ),
    );
  }
}
