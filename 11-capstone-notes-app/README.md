# Lab 11 — Capstone: Notes App

> Level: capstone · Prasyarat: semua Lab 01-10

## Tentang lab ini

Tidak ada konsep baru — di sinilah semua yang dipelajari dari Lab 01-10
digabungkan menjadi satu aplikasi kecil tapi nyata: daftar catatan dengan
pencarian, pin, dan penyimpanan data di perangkat. Kalau kamu bisa
menyelesaikan lab ini tanpa terlalu sering membuka ulang README
sebelumnya, kamu sudah benar-benar menguasai Riverpod.

| Konsep | Dari | Muncul di mana di sini |
|---|---|---|
| Code generation (`@riverpod`) | Lab 09 | Setiap provider di `notes_providers.dart` |
| State berbentuk `AsyncNotifier` | Lab 06 + Lab 03 | `NotesNotifier.build()` mengembalikan `Future<List<Note>>` |
| Method bernama, update yang immutable | Lab 03 | `addNote` / `deleteNote` / `togglePin` |
| Provider turunan/komputasi | Lab 04 | `filteredNotesProvider` menggabungkan pencarian + notes |
| `AsyncValue.whenData` | Lab 06 | mentransformasi data async tanpa kehilangan loading/error |
| `keepAlive` | Lab 08 / Lab 09 | notes sengaja dibuat bertahan setelah layarnya ditutup |
| Testing dengan `ProviderContainer` | Lab 10 | `test/notes_notifier_test.dart` |
| Pola repository | Lab 01, 06, 10 | `NotesRepository` membungkus `SharedPreferences` |

## Satu ide yang benar-benar baru: `AsyncValue.whenData`

`filteredNotesProvider` perlu memfilter dan mengurutkan sebuah list yang
ada di dalam `AsyncValue` (karena memuatnya bersifat async). Membongkarnya
dengan `.when` lalu membungkusnya lagi akan merepotkan. `whenData`
melakukan tepat pekerjaan "transformasi-kalau-data,
teruskan-apa-adanya-selain-itu":

```dart
AsyncValue<List<Note>> filteredNotes(Ref ref) {
  final notesAsync = ref.watch(notesProvider); // AsyncValue<List<Note>>

  return notesAsync.whenData((notes) {
    // hanya berjalan saat notesAsync adalah AsyncData; loading/error
    // otomatis diteruskan apa adanya sebagai
    // AsyncLoading<List<Note>> / AsyncError<List<Note>>
    return notes.where(...).toList();
  });
}
```

Artinya UI tetap hanya perlu SATU pemanggilan `.when(...)`, pada
`filteredNotesProvider`, untuk menangani setiap kondisi.

## Aplikasi yang akan kamu buat

- Daftar catatan, tersimpan dengan `shared_preferences` (bertahan
  setelah aplikasi ditutup dan dibuka lagi)
- Kolom pencarian di app bar yang memfilter berdasarkan judul/isi
- Pin/unpin (catatan yang di-pin urut paling atas)
- Tambah lewat dialog, hapus lewat swipe-to-dismiss

## Instruksi

Lab ini bekerja sedikit berbeda dari lab-lab sebelumnya:
`test/notes_notifier_test.dart` di `01-start` **sudah lengkap** —
perlakukan sebagai spesifikasi. Tugasmu adalah membuat
`lib/providers/notes_providers.dart` memenuhi spesifikasi itu.

1. Baca `test/notes_notifier_test.dart` lebih dulu. Pahami perilaku apa
   yang diharapkan sebelum menulis kode apa pun.
2. Kerjakan 7 TODO di `01-start/lib/providers/notes_providers.dart`.
3. Setelah tiap TODO (atau kelompok kecil TODO), generate ulang dan test:

```bash
cd 01-start
flutter pub get
dart run build_runner build -d
flutter test
```

4. Begitu semua test lulus, jalankan aplikasinya sungguhan:

```bash
flutter run
```

5. Bandingkan dengan `02-final` kalau buntu, atau setelah selesai.

## Checkpoint questions

- Kenapa `NotesRepository` diberikan lengkap, tidak seperti semua isi
  `notes_providers.dart`? Apa bedanya kode repository dengan kode
  provider dalam hal apa yang layak dipraktikkan di sini?
- `addNote`/`deleteNote`/`togglePin` semuanya memanggil
  `ref.read(notesRepositoryProvider).saveNotes(updated)` SETELAH
  meng-update `state`. Apa yang akan sempat dilihat pengguna kalau
  urutan itu ditukar (simpan dulu, baru update `state`)? Apa yang akan
  mereka lihat kalau `saveNotes` tidak dipanggil sama sekali?
- `filteredNotesProvider` adalah fungsi `@riverpod` biasa, bukan class.
  Kenapa logika filtering/sorting tidak perlu jadi `Notifier`?

## Kemana Selanjutnya

Kamu sudah melewati keseluruhan alurnya: `Provider` → `StateProvider` →
`Notifier` → provider turunan → `family` → `FutureProvider` →
`StreamProvider` → `autoDispose`/`keepAlive` → code generation →
testing → sebuah aplikasi nyata kecil. Dari sini, langkah selanjutnya
yang paling bernilai adalah:

- **Baca dokumentasi resmi** di https://riverpod.dev — khususnya bagian
  "Case studies" dan "Cookbooks", yang membahas skenario nyata
  (pagination, pull-to-refresh dengan cache, menggabungkan Riverpod
  dengan package navigasi seperti `go_router`) yang tidak bisa
  sepenuhnya tergantikan oleh sejumlah lab tetap.
- **Bangun ulang salah satu project kecilmu yang sudah ada** memakai
  Riverpod, dari awal sampai akhir. Menerapkannya pada sesuatu yang
  sudah kamu pahami kebutuhannya jauh lebih bernilai dibanding tutorial
  lain.
- **Baca codebase Riverpod yang sungguhan** (repository Riverpod itu
  sendiri, atau aplikasi Flutter open-source populer yang memakainya)
  untuk melihat bagaimana pola-pola ini tersusun dalam skala yang lebih
  besar dari yang bisa ditunjukkan satu lab layar tunggal — struktur
  folder lintas puluhan fitur, bagaimana tim mengorganisir
  repository/provider mereka, dan di mana mereka menarik garis antara
  provider yang ditulis tangan dan yang di-generate.
