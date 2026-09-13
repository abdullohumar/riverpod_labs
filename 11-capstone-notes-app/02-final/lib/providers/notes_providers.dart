import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../repository/notes_repository.dart';

part 'notes_providers.g.dart';

/// CAPSTONE — semua dari Lab 01-10, digabungkan:
///  - Lab 09 (codegen)     -> @riverpod / @Riverpod(keepAlive: true)
///  - Lab 06 (async)       -> `build()` berbentuk AsyncNotifier yang mengembalikan Future
///  - Lab 03 (Notifier)    -> method bernama (add/delete/togglePin), update immutable
///  - Lab 04 (computed)    -> `filteredNotesProvider` diturunkan dari dua provider
///  - persistence          -> NotesRepository dibungkus SharedPreferences
///  - Lab 10 (testing)     -> lihat test/notes_notifier_test.dart

/// Sengaja dibuat keepAlive: notes tidak seharusnya hilang cuma karena
/// layar notes sempat tidak terlihat sebentar (bandingkan dengan
/// keputusan autoDispose di Lab 08 — ini keputusan sebaliknya, dibuat
/// dengan sengaja).
@Riverpod(keepAlive: true)
NotesRepository notesRepository(Ref ref) => NotesRepository();

@Riverpod(keepAlive: true)
class NotesNotifier extends _$NotesNotifier {
  @override
  Future<List<Note>> build() {
    return ref.watch(notesRepositoryProvider).loadNotes();
  }

  Future<void> addNote({required String title, required String body}) async {
    if (title.trim().isEmpty) return;
    final current = await future; // state yang sedang resolved saat ini
    final note = Note(id: const Uuid().v4(), title: title.trim(), body: body.trim(), createdAt: DateTime.now());
    final updated = [...current, note];
    state = AsyncData(updated);
    await ref.read(notesRepositoryProvider).saveNotes(updated);
  }

  Future<void> deleteNote(String id) async {
    final current = await future;
    final updated = current.where((n) => n.id != id).toList();
    state = AsyncData(updated);
    await ref.read(notesRepositoryProvider).saveNotes(updated);
  }

  Future<void> togglePin(String id) async {
    final current = await future;
    final updated = [
      for (final n in current)
        if (n.id == id) n.copyWith(pinned: !n.pinned) else n,
    ];
    state = AsyncData(updated);
    await ref.read(notesRepositoryProvider).saveNotes(updated);
  }
}

/// StateProvider biasa, persis seperti filterProvider di Lab 04.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider turunan yang menggabungkan `notesProvider` (async) dengan
/// `searchQueryProvider` (sync). Perhatikan tipe kembaliannya adalah
/// `AsyncValue<List<Note>>`, bukan `List<Note>` — `AsyncValue.whenData`
/// memungkinkan kita mentransformasi kondisi DATA sambil meneruskan
/// kondisi loading dan error apa adanya, jadi UI bisa tetap memakai satu
/// `.when(...)` saja pada provider ini alih-alih menyulap dua AsyncValue.
@riverpod
AsyncValue<List<Note>> filteredNotes(Ref ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final notesAsync = ref.watch(notesProvider);

  return notesAsync.whenData((notes) {
    final filtered = query.isEmpty
        ? notes
        : notes
            .where((n) => n.title.toLowerCase().contains(query) || n.body.toLowerCase().contains(query))
            .toList();

    filtered.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return filtered;
  });
}
