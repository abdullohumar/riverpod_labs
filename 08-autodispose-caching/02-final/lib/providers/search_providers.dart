import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repository/search_repository.dart';

/// LAB 08 — AUTODISPOSE & CACHING
///
/// Secara default, state sebuah provider tetap hidup selama seluruh
/// lifetime `ProviderScope`, bahkan setelah setiap widget yang
/// meng-watch-nya sudah hilang. Ini tidak masalah untuk segelintir
/// provider yang berlaku di seluruh aplikasi, tapi Lab 05 sudah
/// mengingatkan masalahnya untuk `.family`: setiap argumen berbeda yang
/// pernah kamu pakai menyimpan state cache-nya sendiri SELAMANYA. Untuk
/// kolom search-as-you-type, artinya satu instance provider bocor per
/// keystroke.
///
/// `.autoDispose` memperbaiki ini: state provider dihancurkan secara
/// otomatis begitu tidak ada listener-nya lagi (dengan jeda singkat
/// untuk bertahan dari widget rebuild yang cepat).

final searchRepositoryProvider = Provider<SearchRepository>((ref) => SearchRepository());

/// Menyimpan teks pencarian saat ini (yang sudah di-debounce).
/// StateProvider biasa — debounce-nya sendiri terjadi di lapisan UI
/// (lihat main.dart).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// `.autoDispose.family`: satu instance provider yang bisa dibuang PER
/// STRING QUERY. Ketik "ripple" huruf demi huruf dan setiap query
/// perantara ("r", "ri", "riv"...) akan dibuang sesaat setelah kamu
/// berhenti meng-watch-nya — tidak ada yang menumpuk.
final searchResultsProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, query) async {
  final repository = ref.watch(searchRepositoryProvider);
  final results = await repository.search(query);

  // Tanpa ini, begitu kamu mengosongkan kolom pencarian (dan tidak ada
  // widget yang meng-watch query ini lagi), hasilnya akan langsung
  // dibuang — pencarian identik yang diulang akan memukul "network" lagi.
  //
  // `ref.keepAlive()` mengembalikan sebuah link yang meng-override
  // autoDispose SEKALI, menjaga instance ini tetap hidup meski
  // listener-nya nol — tapi HANYA sampai kita sendiri yang menutup
  // link-nya secara eksplisit. Di sini kita menjaga hasil yang sukses
  // dan tidak kosong tetap di-cache selama 30 detik setelah listener
  // terakhirnya pergi, baru membiarkannya dispose seperti biasa.
  if (results.isNotEmpty) {
    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), link.close);
    ref.onDispose(timer.cancel);
  }

  return results;
});
