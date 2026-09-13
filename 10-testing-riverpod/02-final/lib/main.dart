import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_notifier.dart';
import 'providers/user_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing Riverpod',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosProvider);
    final userNameAsync = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: userNameAsync.when(
          data: (name) => Text('Hi, $name'),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Testing Riverpod'),
        ),
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
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return CheckboxListTile(
                  value: todo.completed,
                  onChanged: (_) => ref.read(todosProvider.notifier).toggle(todo.id),
                  title: Text(todo.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
