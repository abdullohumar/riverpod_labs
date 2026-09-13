import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LAB 01 — PROVIDER BASICS (starter)
///
/// Ikuti TODO bernomor di file ini secara berurutan. Penjelasan lengkap
/// tiap konsep ada di ../README.md — baca dulu, baru kembali ke sini.
/// Bandingkan hasilmu dengan ../02-final kalau sudah selesai.

void main() {
  runApp(
    // TODO(1): Bungkus MyApp dengan widget `ProviderScope` supaya provider
    // bisa berfungsi.
    // Hint: `ProviderScope(child: MyApp())`.
    const MyApp(),
  );
}

class AppInfo {
  const AppInfo({required this.name, required this.version});

  final String name;
  final String version;
}

// TODO(2): Ubah ini menjadi Provider<AppInfo>.
// Hint: `final appInfoProvider = Provider<AppInfo>((ref) { ... });`
// Harus mengembalikan `const AppInfo(name: 'Provider Basics Lab', version: '1.0.0')`.
const appInfoPlaceholder = AppInfo(name: '', version: '');

// TODO(3): Buat `greetingProvider`, sebuah `Provider<String>`, yang
// mengembalikan sapaan berbeda tergantung `DateTime.now().hour`:
//   < 11 -> 'Good morning'
//   < 15 -> 'Good afternoon'
//   < 19 -> 'Good evening'
//   selain itu -> 'Good night'

class QuoteRepository {
  final _quotes = const [
    'Simple things should be simple, complex things should be possible.',
    'Make it work, make it right, make it fast.',
    'State management is just: where does the truth live?',
    'A provider is just a smarter, testable global variable.',
    'Composition over inheritance, providers over singletons.',
  ];

  String randomQuote() => _quotes[Random().nextInt(_quotes.length)];
}

// TODO(4): Sediakan QuoteRepository lewat `Provider<QuoteRepository>`
// dengan nama `quoteRepositoryProvider`.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Basics',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const HomePage(),
    );
  }
}

// TODO(5): Ubah `HomePage` dari `StatelessWidget` menjadi `ConsumerWidget`
// supaya method build-nya menerima `WidgetRef ref`. Jangan lupa ubah juga
// signature method `build` menjadi `build(BuildContext context, WidgetRef ref)`.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(6): Ganti dua baris ini dengan:
    //   final appInfo = ref.watch(appInfoProvider);
    //   final greeting = ref.watch(greetingProvider);
    const appInfo = appInfoPlaceholder;
    const greeting = 'TODO: implement greetingProvider';

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Basics')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(greeting, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('v${appInfo.version}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 32),
              const _QuoteCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO(7): Ubah `_QuoteCard` dari `StatefulWidget` menjadi
// `ConsumerStatefulWidget`, dan State-nya dari `State<_QuoteCard>` menjadi
// `ConsumerState<_QuoteCard>`.
class _QuoteCard extends StatefulWidget {
  const _QuoteCard();

  @override
  State<_QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<_QuoteCard> {
  String? _quote;

  void _newQuote() {
    // TODO(8): Ambil repository dengan `ref.read(quoteRepositoryProvider)`
    // (BUKAN ref.watch — ini aksi sekali pakai di dalam callback, bukan
    // sesuatu yang perlu di-rebuild oleh widget) lalu set `_quote` menjadi
    // `repository.randomQuote()` di dalam setState.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _quote ?? 'Tap the button to fetch a quote from the repository.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _newQuote,
              icon: const Icon(Icons.refresh),
              label: const Text('New quote'),
            ),
          ],
        ),
      ),
    );
  }
}
