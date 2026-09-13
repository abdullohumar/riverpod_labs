import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repository/search_repository.dart';

/// LAB 08 — AUTODISPOSE & CACHING (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.

final searchRepositoryProvider = Provider<SearchRepository>((ref) => SearchRepository());

final searchQueryProvider = StateProvider<String>((ref) => '');

// TODO(1): Deklarasikan `searchResultsProvider` sebagai
// `FutureProvider.autoDispose.family<List<String>, String>((ref, query) async { ... })`
// yang:
//   - meng-watch `searchRepositoryProvider` dan meng-await `.search(query)`
//   - kalau hasilnya tidak kosong, panggil `ref.keepAlive()` untuk
//     mendapatkan `KeepAliveLink`, mulai `Timer` 30 detik yang memanggil
//     `link.close()`, dan daftarkan `ref.onDispose(timer.cancel)` supaya
//     timer-nya tidak bertahan lebih lama dari provider-nya kalau
//     dispose lewat jalan lain lebih dulu
//   - mengembalikan hasilnya
