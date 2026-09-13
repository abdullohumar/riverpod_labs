import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

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
