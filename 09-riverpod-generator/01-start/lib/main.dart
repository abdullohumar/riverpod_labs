import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// LAB 09 — RIVERPOD CODE GENERATION (starter)
///
/// File ini tidak perlu diubah. Selesaikan TODO di providers.dart lalu
/// jalankan `dart run build_runner build -d`, dan ini akan tetap
/// ter-compile dan berjalan tanpa perubahan — mengonsumsi provider hasil
/// generate terlihat identik dengan mengonsumsi yang ditulis tangan.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Generator',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
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
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = ref.watch(greetingProvider);
    final counter = ref.watch(counterProvider);
    final searchAsync = ref.watch(searchWordsProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(greeting, style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => ref.read(counterProvider.notifier).decrement(),
                  icon: const Icon(Icons.remove),
                ),
                Text('$counter', style: Theme.of(context).textTheme.headlineMedium),
                IconButton(
                  onPressed: () => ref.read(counterProvider.notifier).increment(),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const Divider(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Search words...', border: OutlineInputBorder()),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: searchAsync.when(
                data: (words) => ListView(children: [for (final w in words) ListTile(title: Text(w))]),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('$error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
