import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/article.dart';
import '../repository/article_repository.dart';

final articleRepositoryProvider = Provider<ArticleRepository>((ref) => ArticleRepository());

final articlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(articleRepositoryProvider).fetchArticles();
});

final articleProvider = FutureProvider.family<Article, String>((ref, id) {
  return ref.watch(articleRepositoryProvider).fetchArticle(id);
});
