import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/article.dart';
import '../repository/article_repository.dart';

/// LAB 06 — FUTUREPROVIDER & ASYNCVALUE
///
/// `FutureProvider` menjalankan fungsi asinkron dan menyediakan hasilnya
/// sebagai `AsyncValue<T>` — tipe dengan tepat tiga kemungkinan:
/// `AsyncData`, `AsyncLoading`, `AsyncError`. UI dipaksa menangani
/// ketiganya lewat `.when(...)`, jadi kamu tidak bisa tidak sengaja lupa
/// kondisi loading atau error seperti yang mudah terjadi kalau memakai
/// `Future` mentah + `FutureBuilder`.

final articleRepositoryProvider = Provider<ArticleRepository>((ref) => ArticleRepository());

/// Mengambil seluruh daftar artikel. `ref.watch` pada
/// `articleRepositoryProvider` di sini adalah pola dependency injection
/// yang sama seperti di setiap lab sebelumnya — FutureProvider tidak
/// istimewa dalam hal itu, hanya TIPE KEMBALIANNYA (sebuah Future) yang
/// istimewa.
final articlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(articleRepositoryProvider).fetchArticles();
});

/// FutureProvider + family: mengambil satu artikel berdasarkan id.
/// Menggabungkan Lab 05 (family) dengan lab ini (async) — ini adalah
/// bentuk yang sangat umum di dunia nyata: "layar detail untuk id X."
final articleProvider = FutureProvider.family<Article, String>((ref, id) {
  return ref.watch(articleRepositoryProvider).fetchArticle(id);
});
