import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../repository/notes_repository.dart';

part 'notes_providers.g.dart';

/// CAPSTONE (starter) — ikuti TODO bernomor. Penjelasan lengkap ada di
/// ../README.md. `test/notes_notifier_test.dart` sudah lengkap dan
/// menjelaskan persis apa yang harus dilakukan file ini — perlakukan
/// sebagai spesifikasimu. Jalankan `flutter test` setelah tiap TODO untuk
/// mengecek pekerjaanmu.

// TODO(1): Beri anotasi ini dengan `@Riverpod(keepAlive: true)` (notes
// seharusnya bertahan meski layar notes sempat ditutup sebentar — lihat
// keputusan Lab 08, dibuat sebaliknya di sini dengan sengaja).
NotesRepository notesRepository(Ref ref) => NotesRepository();

// TODO(2): Beri anotasi class ini dengan `@Riverpod(keepAlive: true)` dan
// buat dia meng-extend `_$NotesNotifier`.
class NotesNotifier {
  // TODO(3): Override `build()` supaya mengembalikan
  // `ref.watch(notesRepositoryProvider).loadNotes()`.
  Future<List<Note>> build() {
    throw UnimplementedError();
  }

  Future<void> addNote({required String title, required String body}) async {
    if (title.trim().isEmpty) return;
    // TODO(4): Implementasikan method ini:
    //   - `final current = await future;` (state yang sedang resolved saat ini)
    //   - buat sebuah `Note(id: const Uuid().v4(), title: ..., body: ...,
    //     createdAt: DateTime.now())`
    //   - `final updated = [...current, note];`
    //   - `state = AsyncData(updated);`
    //   - `await ref.read(notesRepositoryProvider).saveNotes(updated);`
  }

  Future<void> deleteNote(String id) async {
    // TODO(5): Bentuknya sama seperti addNote, tapi filter list saat ini
    // untuk menghapus note dengan `id` ini sebelum di-assign ke `state`
    // dan disimpan.
  }

  Future<void> togglePin(String id) async {
    // TODO(6): Bentuknya sama lagi, tapi ganti note yang cocok `id`-nya
    // dengan `n.copyWith(pinned: !n.pinned)`, biarkan note lainnya apa
    // adanya.
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

// TODO(7): Beri anotasi fungsi ini dengan `@riverpod`. Fungsi ini harus:
//   - meng-watch `searchQueryProvider` (trim + lowercase-kan)
//   - meng-watch `notesProvider` (ini nama hasil generate untuk provider
//     milik NotesNotifier — generator menghapus akhiran "Notifier" dari
//     nama class-nya)
//   - mengembalikan `notesAsync.whenData((notes) { ... })`, di mana
//     fungsi di dalamnya memfilter berdasarkan title/body yang
//     mengandung query (lewati filtering kalau query-nya kosong),
//     lalu mengurutkan note yang di-pin lebih dulu, kemudian
//     berdasarkan `createdAt` menurun
AsyncValue<List<Note>> filteredNotes(Ref ref) {
  throw UnimplementedError();
}
