import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateProvider sekarang ada di entrypoint "legacy" milik Riverpod 3.x.
// Bukan berarti deprecated, hanya sudah tidak termasuk barrel export
// default.
import 'package:flutter_riverpod/legacy.dart';

/// LAB 02 — STATEPROVIDER (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// TODO(1): Deklarasikan `counterProvider`, sebuah `StateProvider<int>`
// yang mulai dari 0.

// TODO(2): Deklarasikan `stepProvider`, sebuah `StateProvider<int>` yang
// mulai dari 1.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StateProvider Counter',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(3): Watch `stepProvider` dan simpan di variabel lokal `step`.
    const step = 1;

    // TODO(4): Pakai `ref.listen<int>(counterProvider, (previous, next) { ... })`
    // untuk menampilkan SnackBar (lewat `ScaffoldMessenger.of(context)`)
    // setiap kali `next` adalah kelipatan 10 yang bukan nol. Ini harus
    // dipanggil langsung di dalam build(), bukan di dalam callback.

    return Scaffold(
      appBar: AppBar(title: const Text('StateProvider Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _CounterDisplay(),
            const SizedBox(height: 24),
            _StepSelector(step: step),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: () {
              // TODO(5): Kurangi state counterProvider dengan step saat
              // ini. Hint: `ref.read(counterProvider.notifier).state -= ...`
            },
            tooltip: 'Decrement by $step',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () {
              // TODO(6): Reset state counterProvider ke 0.
            },
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () {
              // TODO(7): Tambahkan step saat ini ke state counterProvider.
            },
            tooltip: 'Increment by $step',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _CounterDisplay extends ConsumerWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(8): Watch counterProvider dan tampilkan nilainya, bukan 0.
    const count = 0;
    return Text('$count', style: Theme.of(context).textTheme.displayLarge);
  }
}

class _StepSelector extends ConsumerWidget {
  const _StepSelector({required this.step});

  final int step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      children: [1, 2, 5, 10].map((value) {
        return ChoiceChip(
          label: Text('step $value'),
          selected: step == value,
          onSelected: (_) {
            // TODO(9): Set state stepProvider menjadi `value`.
          },
        );
      }).toList(),
    );
  }
}
