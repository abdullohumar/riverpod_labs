import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_capstone_app/providers/notes_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sintesis berskala capstone dari teknik testing di Lab 10: tidak perlu
/// mock di sini (SharedPreferences sudah menyediakan fake in-memory
/// resminya sendiri untuk testing), cukup `ProviderContainer` + provider
/// async + provider turunan, semuanya digabung.
void main() {
  setUp(() {
    // Tanpa ini, panggilan SharedPreferences.getInstance() asli milik
    // NotesRepository tidak punya platform channel untuk diajak bicara
    // saat menjalankan `flutter test` biasa, dan akan error. Ini
    // menyiapkan implementasi in-memory yang kosong.
    SharedPreferences.setMockInitialValues({});
  });

  test('starts empty, then supports add / pin / delete', () async {
    final container = ProviderContainer.test();

    // notesProvider bersifat async (berbentuk AsyncNotifier) — tunggu
    // pemuatan awalnya selesai sebelum meng-assert atasnya.
    await container.read(notesProvider.future);
    expect(container.read(notesProvider).value, isEmpty);

    await container.read(notesProvider.notifier).addNote(title: 'Groceries', body: 'Milk, eggs');
    var notes = container.read(notesProvider).value!;
    expect(notes, hasLength(1));

    final id = notes.single.id;
    await container.read(notesProvider.notifier).togglePin(id);
    notes = container.read(notesProvider).value!;
    expect(notes.single.pinned, isTrue);

    await container.read(notesProvider.notifier).deleteNote(id);
    expect(container.read(notesProvider).value, isEmpty);
  });

  test('filteredNotesProvider sorts pinned first and filters by query', () async {
    final container = ProviderContainer.test();
    await container.read(notesProvider.future);
    final notifier = container.read(notesProvider.notifier);

    await notifier.addNote(title: 'Groceries', body: 'Milk, eggs');
    await notifier.addNote(title: 'Workout plan', body: 'Legs day');
    final groceriesId = container.read(notesProvider).value!.firstWhere((n) => n.title == 'Groceries').id;
    await notifier.togglePin(groceriesId);

    // Tanpa query pencarian: catatan yang di-pin harus urut paling atas
    // terlepas dari urutan pembuatannya.
    var filtered = container.read(filteredNotesProvider).value!;
    expect(filtered.first.title, 'Groceries');

    // Mengetik sebuah query mempersempit list-nya — filteredNotesProvider
    // menghitung ulang karena dia meng-watch notesProvider DAN
    // searchQueryProvider.
    container.read(searchQueryProvider.notifier).state = 'workout';
    filtered = container.read(filteredNotesProvider).value!;
    expect(filtered.single.title, 'Workout plan');
  });
}
