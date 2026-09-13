import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LAB 01 — PROVIDER BASICS
///
/// Tujuan: memahami building block paling dasar di Riverpod, `Provider`,
/// dan dua cara widget berinteraksi dengannya: `ref.watch` dan `ref.read`.
///
/// `Provider` menyediakan sebuah nilai yang dihitung sekali dan tidak
/// pernah berubah sendiri (tidak ada API seperti `setState`). Provider
/// cocok dipakai untuk:
///   - dependency injection (repository, service, konfigurasi)
///   - nilai yang *diturunkan* (derived) dari provider lain
///
/// Kalau kamu butuh nilai yang berubah seiring waktu sebagai reaksi dari
/// aksi pengguna, `Provider` adalah alat yang salah — lihat Lab 02
/// (StateProvider) dan Lab 03 (Notifier) untuk itu.

void main() {
  runApp(
    // ProviderScope menyimpan state dari setiap provider di aplikasi.
    // Tanpa ini, pemanggilan ref.watch/ref.read di mana pun akan error
    // saat runtime. Biasanya diletakkan sekali saja, tepat di atas root
    // widget.
    const ProviderScope(child: MyApp()),
  );
}

/// Model immutable sederhana. Tidak ada yang spesifik Riverpod di sini.
class AppInfo {
  const AppInfo({required this.name, required this.version});

  final String name;
  final String version;
}

/// Provider paling dasar: hanya mengembalikan nilai konstan.
/// Widget mana pun yang melakukan `ref.watch(appInfoProvider)` akan
/// mendapat instance yang sama — Riverpod menghitungnya secara lazy,
/// sekali saja, saat pertama kali dibaca, lalu meng-cache-nya selama
/// ProviderScope masih hidup.
final appInfoProvider = Provider<AppInfo>((ref) {
  return const AppInfo(name: 'Provider Basics Lab', version: '1.0.0');
});

/// Provider yang nilainya berupa logika *turunan* (derived), bukan
/// sekadar konstanta. Tetap hanya jalan sekali (waktu hari tidak berubah
/// selama aplikasi terbuka), yang justru pas untuk kegunaan `Provider`.
final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 11) return 'Good morning';
  if (hour < 15) return 'Good afternoon';
  if (hour < 19) return 'Good evening';
  return 'Good night';
});

/// "Repository" adalah class yang tahu cara mengambil/menghasilkan data.
/// Menyediakannya lewat Provider adalah pola dependency injection klasik
/// ala Riverpod: widget tidak pernah membuat `QuoteRepository()` sendiri,
/// mereka meminta ke provider. Ini membuat implementasinya mudah diganti
/// nanti (misalnya saat testing, lihat Lab 10).
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

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository();
});

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

// ConsumerWidget adalah pengganti StatelessWidget ala Riverpod: method
// build-nya menerima parameter tambahan `WidgetRef ref` untuk membaca
// provider.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch membuat widget ini berlangganan (subscribe) ke provider:
    // kalau nilai provider berubah, widget ini akan otomatis rebuild.
    // (Kedua provider ini tidak pernah berubah, tapi inilah pola yang
    // akan kamu pakai berulang di lab-lab selanjutnya untuk nilai yang
    // BENAR-BENAR berubah.)
    final appInfo = ref.watch(appInfoProvider);
    final greeting = ref.watch(greetingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appInfo.name)),
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

// Bagian ini butuh local state sendiri (quote yang sedang ditampilkan),
// makanya jadi ConsumerStatefulWidget, bukan ConsumerWidget.
class _QuoteCard extends ConsumerStatefulWidget {
  const _QuoteCard();

  @override
  ConsumerState<_QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends ConsumerState<_QuoteCard> {
  String? _quote;

  void _newQuote() {
    // ref.read mengambil nilai provider SEKALI SAJA, tanpa berlangganan.
    // Pakai ref.read di dalam callback (onPressed, onTap, initState...) —
    // jangan pernah dipakai di dalam build() untuk membaca nilai yang
    // ingin kamu reaksikan; pakai ref.watch untuk itu.
    final repository = ref.read(quoteRepositoryProvider);
    setState(() => _quote = repository.randomQuote());
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
            const SizedBox(height: 8),
            const Text(
              'Notice: the quote is stored in local State, NOT in the '
              'provider. Provider has no way to hold changing state — '
              'that is exactly what Lab 02 (StateProvider) introduces.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
