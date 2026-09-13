import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/article.dart';
import '../repository/article_repository.dart';

/// LAB 06 — FUTUREPROVIDER & ASYNCVALUE (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.

final articleRepositoryProvider = Provider<ArticleRepository>((ref) => ArticleRepository());

// TODO(1): Deklarasikan `articlesProvider`, sebuah
// `FutureProvider<List<Article>>` yang mengembalikan
// `ref.watch(articleRepositoryProvider).fetchArticles()`.

// TODO(2): Deklarasikan `articleProvider`, sebuah
// `FutureProvider.family<Article, String>` yang mengembalikan
// `ref.watch(articleRepositoryProvider).fetchArticle(id)`.
