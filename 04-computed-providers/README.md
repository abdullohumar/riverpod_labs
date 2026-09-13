# Lab 04 — Computed / Derived Providers

> Level: menengah · Prasyarat: [Lab 03 — Notifier](../03-notifier-todo/README.md)

## Yang akan kamu pelajari

- Sebuah `Provider` bisa melakukan `ref.watch` ke provider lain di dalam
  builder-nya sendiri — begitulah cara membangun dependency graph, bukan
  sekadar potongan state yang terisolasi
- Menggabungkan dua provider independen (sebuah list + sebuah filter)
  menjadi satu nilai turunan, supaya UI tidak perlu tahu logika filtering
  itu ada
- `provider.select(...)`: berlangganan hanya ke *sepotong* nilai sebuah
  provider untuk menghindari rebuild yang tidak perlu
- Switch **expression** (`return switch (x) { ... => ... }`) sebagai cara
  bersih menangani percabangan berbasis enum

## Pola: provider yang bergantung pada provider lain

```dart
final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);   // dependency #1
  final todos = ref.watch(todosProvider);      // dependency #2
  return switch (filter) { ... };
});
```

Bayangkan ini seperti spreadsheet: `filteredTodosProvider` adalah sel
formula. Ubah salah satu sel input (`filterProvider` atau
`todosProvider`) dan formulanya dihitung ulang, lalu setiap widget yang
menampilkan hasil formula itu ikut ter-update. Tidak ada widget yang
perlu menulis ulang logika filtering, dan tidak ada widget yang perlu
meng-watch kedua provider sendiri — mereka cukup meng-watch satu provider
turunan yang sudah menggabungkan keduanya.

Inilah kebiasaan paling penting untuk menjaga aplikasi Riverpod tetap
gampang dirawat: **dorong komputasi ke dalam provider, biarkan widget
tetap "bodoh".**

## `.select`: rebuild lebih sedikit

Secara default, `ref.watch(someProvider)` me-rebuild widgetmu setiap kali
nilai `someProvider` berubah SAMA SEKALI (dicek dengan `==`). Kalau
widgetmu cuma peduli pada *sebagian* dari nilai itu, `.select`
mempersempit subscription-nya:

```dart
// Rebuild setiap kali todos berubah APA SAJA (tambah/hapus/toggle):
final todos = ref.watch(todosProvider);

// Rebuild HANYA saat hasil hitungannya sendiri berubah:
final completedCount = ref.watch(
  todosProvider.select((todos) => todos.where((t) => t.completed).length),
);
```

Widget `_CompletedBadge` di lab ini punya penghitung "rebuilt Nx" yang
terlihat, supaya kamu bisa benar-benar melihat optimisasi ini bekerja
(atau belum, selama masih berupa TODO).

## Aplikasi yang akan kamu buat

Aplikasi todo dari Lab 03, ditambah:
- Filter segmented All / Active / Completed (`filterProvider` +
  `filteredTodosProvider`)
- Badge jumlah selesai di app bar yang dibuat dengan `.select`

## Instruksi

1. `01-start/lib/providers/todo_providers.dart` — TODO 1-2.
2. `01-start/lib/main.dart` — TODO 3-5.
3. Verifikasi optimisasinya: perhatikan penghitung "(rebuilt Nx)" di
   badge saat menambah todo baru (yang belum selesai) — angkanya TIDAK
   boleh bertambah. Meng-toggle todo HARUS membuatnya bertambah.
4. Bandingkan dengan `02-final`.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Kalau `_CompletedBadge` meng-watch `todosProvider` langsung (tanpa
  `.select`), apa yang akan kamu amati pada penghitung rebuild-nya saat
  menambah todo baru yang belum selesai?
- Kenapa `filteredTodosProvider` cukup jadi `Provider` biasa, bukan
  `NotifierProvider` — apa yang sebenarnya diberikan `Notifier` di sini
  yang tidak dimiliki `Provider`?
- Apa yang terjadi pada nilai cache `filteredTodosProvider` tepat saat
  `filterProvider` berubah — apakah langsung dihitung ulang, atau baru
  saat ada yang membacanya lagi?

## Jebakan umum

- **Menduplikasi logika filtering di widget** alih-alih di provider
  turunan — begitu dua layar butuh "list yang sudah difilter", kamu akan
  punya dua salinan logika yang sama yang harus disinkronkan manual.
- **`.select` yang selalu menghasilkan objek/list baru** (misalnya
  `.select((s) => SomeWrapper(s))`) — hasil dari selector harus bisa
  dibandingkan dengan `==` antar pemanggilan, kalau tidak `.select` tidak
  memberi keuntungan apa-apa karena wrapper baru tidak pernah sama dengan
  yang sebelumnya.
- **Memilih `Notifier`** padahal `Provider` biasa sudah cukup — kalau
  sebuah nilai 100% hasil komputasi dari provider lain dan tidak pernah
  dimutasi langsung, dia tidak butuh notifier sendiri.

## Lab berikutnya

[Lab 05 — Family providers](../05-family-provider/README.md): provider
yang diparameterisasi dengan argumen, misalnya "berikan todo dengan id
tertentu" atau "berikan user dengan id tertentu."
