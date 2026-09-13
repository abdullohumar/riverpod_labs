import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/article_providers.dart';

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
    final articlesAsync = ref.watch(articlesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: RefreshIndicator(
        // Pull-to-refresh: `ref.refresh` menjalankan ulang fungsi provider
        // dan mengembalikan Future hasilnya, jadi RefreshIndicator bisa
        // meng-await-nya dan tahu kapan harus menyembunyikan spinner-nya.
        onRefresh: () => ref.refresh(articlesProvider.future),
        // `.when` memaksamu menangani ketiga kondisi AsyncValue.
        child: articlesAsync.when(
          data: (articles) => ListView.builder(
            // AlwaysScrollable supaya RefreshIndicator tetap berfungsi
            // meski list-nya cukup pendek sehingga tidak bisa di-scroll
            // sendiri.
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(article.title),
                subtitle: Text(article.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ArticleDetailPage(articleId: article.id)),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorView(
            message: '$error',
            onRetry: () => ref.invalidate(articlesProvider),
          ),
        ),
      ),
    );
  }
}

class ArticleDetailPage extends ConsumerWidget {
  const ArticleDetailPage({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Setiap articleId mendapat AsyncValue independennya sendiri
    // (gabungan family dari Lab 05 + async dari lab ini).
    final articleAsync = ref.watch(articleProvider(articleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: articleAsync.when(
        data: (article) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(article.body),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          message: '$error',
          onRetry: () => ref.invalidate(articleProvider(articleId)),
        ),
      ),
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
            // ref.invalidate menandai provider sebagai basi (stale):
            // pembacaan berikutnya akan menjalankan fungsinya lagi dari
            // nol. Ini cara paling sederhana untuk membuat tombol
            // "Retry".
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
