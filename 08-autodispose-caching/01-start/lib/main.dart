import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/search_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoDispose & Caching',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // TODO(2): Debounce ini: batalkan Timer `_debounce` yang sedang
    // berjalan (kalau ada), lalu mulai Timer 300ms baru yang men-set
    // `ref.read(searchQueryProvider.notifier).state = value.trim().toLowerCase()`.
  }

  @override
  Widget build(BuildContext context) {
    // TODO(3): Watch `searchQueryProvider` ke dalam `query`.
    // TODO(4): Kalau `query` tidak kosong, watch
    // `searchResultsProvider(query)` ke dalam `resultsAsync` (kalau
    // kosong, null).
    const query = '';
    const AsyncValue<List<String>>? resultsAsync = null;

    return Scaffold(
      appBar: AppBar(title: const Text('Search (autoDispose)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Riverpod terms...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Every distinct query string you pause on gets its own '
              'autoDispose.family provider instance, thrown away shortly '
              'after you move on — except successful (non-empty) results, '
              'which stay cached for 30s via ref.keepAlive().',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              // TODO(5): Ganti placeholder ini dengan switch expression
              // atas `resultsAsync` yang menangani: null -> "Type to
              // search", AsyncData dengan hasil kosong -> "No matches",
              // AsyncData dengan hasil -> ListView berisi ListTile,
              // AsyncError -> tampilkan error-nya, dan kondisi loading ->
              // CircularProgressIndicator. (Lihat ../README.md untuk
              // sintaks pattern-matching yang tepat.)
              child: Text('query: "$query"'),
            ),
          ],
        ),
      ),
    );
  }
}
