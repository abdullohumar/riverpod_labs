import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// StateProvider sekarang ada di entrypoint "legacy" milik Riverpod 3.x.
// Bukan berarti deprecated, hanya sudah tidak termasuk barrel export
// default.
import 'package:flutter_riverpod/legacy.dart';

/// LAB 02 — STATEPROVIDER
///
/// `StateProvider<T>` adalah provider paling sederhana yang benar-benar
/// bisa mengubah nilainya saat runtime. Ia hanyalah wrapper tipis di
/// sekitar satu field mutable, berguna untuk potongan state UI yang
/// sederhana dan berdiri sendiri (counter, filter yang dipilih, toggle)
/// yang tidak butuh logika khusus.
///
/// Catatan: di Riverpod 3.x, `StateProvider` ada di dalam API "legacy".
/// Tetap berfungsi sempurna dan masih jadi alat yang tepat untuk state
/// sepele seperti counter ini — tapi begitu kamu butuh validasi, banyak
/// field, atau logika bisnis seputar perubahannya, gunakan `Notifier`
/// (Lab 03). Anggap saja StateProvider seperti `useState`, dan Notifier
/// seperti reducer kecil berbasis class.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Menyimpan nilai counter. Mulai dari 0.
final counterProvider = StateProvider<int>((ref) => 0);

/// Menyimpan berapa besar penambahan/pengurangan tiap tap. StateProvider
/// kedua yang independen — ini menunjukkan provider bisa saling
/// berdampingan tanpa wiring khusus: `counterProvider` tidak perlu tahu
/// `stepProvider` itu ada.
final stepProvider = StateProvider<int>((ref) => 1);

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
    final step = ref.watch(stepProvider);

    // ref.listen memungkinkanmu menjalankan side effect sekali jalan
    // (SnackBar, navigasi, dialog) setiap kali nilai provider berubah,
    // TANPA me-rebuild widget seperti yang dilakukan ref.watch. Ini
    // padanan Riverpod untuk bereaksi terhadap stream, dan harus
    // dipanggil di dalam build().
    ref.listen<int>(counterProvider, (previous, next) {
      if (next != 0 && next % 10 == 0) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Milestone! Counter hit $next')));
      }
    });

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
              // .notifier memberimu StateController tanpa berlangganan ke
              // nilainya — persis yang kamu butuhkan di dalam callback.
              ref.read(counterProvider.notifier).state -= ref.read(stepProvider);
            },
            tooltip: 'Decrement by $step',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: () => ref.read(counterProvider.notifier).state = 0,
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () {
              ref.read(counterProvider.notifier).state += ref.read(stepProvider);
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

// Dipisah jadi ConsumerWidget sendiri supaya HANYA bagian ini yang
// rebuild saat counter berubah — step selector di bawah tidak ikut
// render ulang setiap kali tap.
class _CounterDisplay extends ConsumerWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
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
          onSelected: (_) => ref.read(stepProvider.notifier).state = value,
        );
      }).toList(),
    );
  }
}
