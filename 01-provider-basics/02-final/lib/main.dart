import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class AppInfo {
  const AppInfo({required this.name, required this.version});

  final String name;
  final String version;
}

final appInfoProvider = Provider<AppInfo>((ref) {
  return const AppInfo(name: 'Provider Basics Lab', version: '1.0.0');
});

final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 11) return 'Good morning';
  if (hour < 15) return 'Good afternoon';
  if (hour < 19) return 'Good evening';
  return 'Good night';
});

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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class _QuoteCard extends ConsumerStatefulWidget {
  const _QuoteCard();

  @override
  ConsumerState<_QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends ConsumerState<_QuoteCard> {
  String? _quote;

  void _newQuote() {
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
