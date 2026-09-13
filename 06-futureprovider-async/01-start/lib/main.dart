import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/article_providers.dart';

/// LAB 06 — FUTUREPROVIDER & ASYNCVALUE (starter)
///
/// Mulai dari providers/article_providers.dart (TODO 1-2), baru kembali
/// ke sini untuk TODO 3-6.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureProvider',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const ArticleListPage(),
    );
  }
}

class ArticleListPage extends ConsumerWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(3): Watch `articlesProvider` ke dalam `articlesAsync`
    // (tipe: AsyncValue<List<Article>> — import model Article kalau kamu
    // ingin menuliskan tipenya secara eksplisit).

    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO(4): Panggil `ref.refresh(articlesProvider.future)` dan
          // await hasilnya (RefreshIndicator butuh sebuah Future untuk
          // tahu kapan harus menyembunyikan spinner-nya).
        },
        // TODO(5): Ganti placeholder ini dengan
        // `articlesAsync.when(data: ..., loading: ..., error: ...)`.
        // - data: buat ListView.builder atas artikel-artikelnya. onTap
        //   tiap tile harus push `ArticleDetailPage(articleId: article.id)`.
        // - loading: CircularProgressIndicator yang di-center.
        // - error: sebuah `_ErrorView` dengan
        //   `onRetry: () => ref.invalidate(articlesProvider)`.
        child: const Center(child: Text('TODO: handle AsyncValue states')),
      ),
    );
  }
}

class ArticleDetailPage extends ConsumerWidget {
  const ArticleDetailPage({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(6): Watch `articleProvider(articleId)` ke dalam `articleAsync`
    // lalu tangani dengan `.when(...)`, bentuknya sama seperti TODO(5)
    // tapi untuk satu artikel. Saat error, retry dengan
    // `ref.invalidate(articleProvider(articleId))`.

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: const Center(child: Text('TODO: handle AsyncValue states')),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
