import 'dart:math';

import '../models/article.dart';

/// Backend palsu. Di aplikasi sungguhan ini akan memanggil `http`/`dio`.
/// Delay buatan dan kegagalan acaknya sengaja ditaruh di sini, supaya
/// kamu benar-benar melihat kondisi loading dan error milik `AsyncValue`,
/// bukan cuma jalur mulusnya saja.
class ArticleRepository {
  final _articles = const [
    Article(id: 'a1', title: 'Why immutability matters', body: 'Immutable state makes changes explicit...'),
    Article(id: 'a2', title: 'Providers as a dependency graph', body: 'Every provider can depend on others...'),
    Article(id: 'a3', title: 'AsyncValue: data, loading, error', body: 'AsyncValue models three states so your UI cannot forget one...'),
  ];

  Future<List<Article>> fetchArticles({bool simulateFailure = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (simulateFailure || Random().nextDouble() < 0.2) {
      throw Exception('Network error: could not reach the server');
    }
    return _articles;
  }

  Future<Article> fetchArticle(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _articles.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Article $id not found'),
    );
  }
}
