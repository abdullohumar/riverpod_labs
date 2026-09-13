import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/stream_providers.dart';

String _formatTime(DateTime time) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamProvider',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
      home: const StreamsPage(),
    );
  }
}

class StreamsPage extends ConsumerWidget {
  const StreamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockAsync = ref.watch(clockProvider);
    final tickerAsync = ref.watch(tickerProvider);
    final ticker = ref.read(tickerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Streams')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Live clock (StreamProvider)'),
            const SizedBox(height: 8),
            // AsyncValue.when tetap berlaku untuk stream: loading muncul
            // sekali (sebelum event pertama), lalu jadi `data` di setiap
            // event berikutnya.
            clockAsync.when(
              data: (time) => Text(
                _formatTime(time),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
            ),
            const SizedBox(height: 40),
            const Text('Controllable ticker (StreamNotifier)'),
            const SizedBox(height: 8),
            tickerAsync.when(
              data: (count) => Text('$count', style: Theme.of(context).textTheme.displayMedium),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: ticker.pause, child: const Text('Pause')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: ticker.resume, child: const Text('Resume')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: ticker.reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
