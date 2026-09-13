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
    // TODO(6): Watch `clockProvider` ke dalam `clockAsync`,
    // `tickerProvider` ke dalam `tickerAsync`, dan
    // `ref.read(tickerProvider.notifier)` ke dalam `ticker` (dipakai
    // tombol-tombol di bawah).

    return Scaffold(
      appBar: AppBar(title: const Text('Streams')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Live clock (StreamProvider)'),
            const SizedBox(height: 8),
            // TODO(7): Ganti dengan `clockAsync.when(data: ..., loading:
            // ..., error: ...)`. Pakai `_formatTime(time)` di `data`.
            const Text('TODO'),
            const SizedBox(height: 40),
            const Text('Controllable ticker (StreamNotifier)'),
            const SizedBox(height: 8),
            // TODO(8): Ganti dengan `tickerAsync.when(...)`.
            const Text('TODO'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO(9): Sambungkan ketiga tombol ini ke
                // `ticker.pause`, `ticker.resume`, `ticker.reset`.
                OutlinedButton(onPressed: null, child: const Text('Pause')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: null, child: const Text('Resume')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: null, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
