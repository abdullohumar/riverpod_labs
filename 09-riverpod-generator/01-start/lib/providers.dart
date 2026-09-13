import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// LAB 09 — RIVERPOD CODE GENERATION (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.
///
/// Setelah SETIAP TODO, jalankan (di terminal, dari folder project ini):
///   dart run build_runner build -d
/// untuk meng-generate ulang providers.g.dart. Atau biarkan
/// `dart run build_runner watch -d` berjalan di background kalau kamu
/// lebih suka dia generate ulang otomatis setiap disimpan.

// TODO(1): Beri anotasi fungsi ini dengan `@riverpod` supaya menjadi
// provider hasil generate (`greetingProvider`).
String greeting(Ref ref) => 'Hello from a generated provider';

// TODO(2): Beri anotasi fungsi ini dengan `@riverpod`. Karena punya
// parameter tambahan (`query`) selain `ref`, dia otomatis menjadi
// provider FAMILY (`searchWordsProvider(query)`) — tanpa perlu `.family`.
Future<List<String>> searchWords(Ref ref, String query) async {
  const words = [
    'provider', 'consumer', 'notifier', 'family', 'autoDispose', 'keepAlive',
    'future', 'stream', 'riverpod', 'widget', 'state', 'generator', 'codegen',
  ];
  await Future.delayed(const Duration(milliseconds: 400));
  if (query.isEmpty) return const [];
  return words.where((w) => w.contains(query.toLowerCase())).toList();
}

// TODO(3): Beri anotasi class ini dengan `@Riverpod(keepAlive: true)`
// (BUKAN `@riverpod` biasa — counter biasa sebaiknya keluar dari default
// autoDispose, karena seharusnya bertahan setelah layarnya ditutup) dan
// buat dia meng-extend `_$Counter`.
class Counter {
  int build() => 0;

  void increment() => state++;

  void decrement() => state--;
}
