import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// LAB 09 — RIVERPOD CODE GENERATION
///
/// Semua isi file ini adalah fungsi atau class Dart BIASA yang diberi
/// anotasi `@riverpod`. `build_runner` membaca anotasi ini dan menulis
/// `providers.g.dart`, yang berisi definisi
/// `Provider`/`FutureProvider`/`NotifierProvider`/dsb sesungguhnya — mesin
/// yang persis sama dari Lab 01-08, cuma di-generate alih-alih ditulis
/// tangan.
///
/// Jalankan ini sambil kamu mengedit:
///   dart run build_runner watch -d
/// (-d menghapus hasil yang konflik secara otomatis; pakai `build`
/// alih-alih `watch` untuk sekali jalan saja.)

/// Provider berbasis FUNGSI. `@riverpod` pada fungsi top-level yang
/// mengembalikan `T` menghasilkan setara `Provider<T>` — di sini, karena
/// tidak ada parameter tambahan selain `ref`, jadi yang biasa (bukan
/// family).
///
/// DEFAULT PENTING: provider hasil generate itu `autoDispose` SECARA
/// DEFAULT — kebalikan dari default API manual yang kamu pakai di
/// Lab 01-08! Ini `riverpod_generator` mengarahkanmu ke pilihan yang
/// lebih aman (Lab 08).
@riverpod
String greeting(Ref ref) => 'Hello from a generated provider';

/// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
/// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
/// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
/// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
/// `FutureProvider.autoDispose.family<List<String>, String>`.
@riverpod
Future<List<String>> searchWords(Ref ref, String query) async {
  const words = [
    'provider', 'consumer', 'notifier', 'family', 'autoDispose', 'keepAlive',
    'future', 'stream', 'riverpod', 'widget', 'state', 'generator', 'codegen',
  ];
  await Future.delayed(const Duration(milliseconds: 400));
  if (query.isEmpty) return const [];
  return words.where((w) => w.contains(query.toLowerCase())).toList();
}

/// Provider berbasis CLASS: `@riverpod` pada sebuah class yang meng-extend
/// mixin `_$ClassName` hasil generate menghasilkan setara `NotifierProvider`
/// (lab ini) — bentuk yang persis sama juga berlaku untuk `AsyncNotifier`,
/// cukup buat `build()` mengembalikan `Future<T>`.
///
/// `@Riverpod(keepAlive: true)` KELUAR dari default autoDispose — pakai
/// ini dengan sengaja, untuk state yang memang seharusnya bertahan
/// setelah layarnya ditutup (bandingkan dengan `ref.keepAlive()` di
/// Lab 08, yang melakukan hal sama tapi sementara/bersyarat dari dalam
/// isi provider).
@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;

  void decrement() => state--;
}
