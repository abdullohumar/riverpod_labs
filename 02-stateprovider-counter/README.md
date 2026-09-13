# Lab 02 — StateProvider

> Level: pemula · Prasyarat: [Lab 01 — Provider Basics](../01-provider-basics/README.md)

## Yang akan kamu pelajari

- `StateProvider<T>`: provider yang menyimpan state yang bisa berubah
- Membaca state (`ref.watch(provider)`) vs mengubahnya
  (`ref.read(provider.notifier).state = ...`)
- `ref.listen`: bereaksi terhadap perubahan state dengan side effect
  (SnackBar, dialog, navigasi) tanpa me-rebuild widget
- Memecah widget supaya hanya bagian yang perlu saja yang di-rebuild

## `StateProvider` secara ringkas

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// baca + berlangganan (di dalam build):
final count = ref.watch(counterProvider);

// ubah (di dalam callback):
ref.read(counterProvider.notifier).state++;
ref.read(counterProvider.notifier).state = 0;
```

Setiap `StateProvider` punya **notifier** terkait — objek yang tugasnya
cuma menyimpan `.state` dan memberi tahu listener saat nilainya diganti.
Kamu hampir tidak pernah `ref.watch(provider.notifier)`; kamu `ref.read`
untuk mengubahnya, dan `ref.watch` provider itu sendiri untuk menampilkan
nilainya.

> **Catatan soal "legacy"**: sejak Riverpod 3.0, `StateProvider` masuk
> kategori API "legacy" di library ini. Ini bukan berarti deprecated atau
> akan dihapus — hanya sudah bukan pilihan default yang direkomendasikan
> untuk kebutuhan di luar state sederhana satu field, karena `Notifier`
> (Lab 03) memberi kemampuan yang sama plus ruang untuk berkembang
> (banyak field, validasi, kerja async) tanpa perlu menulis ulang. Untuk
> counter biasa, `StateProvider` tetap pilihan yang sangat wajar dan
> paling sederhana.

## `ref.listen`: perubahan state vs side effect

`ref.watch` untuk *apa yang di-render widget*. Sebagian reaksi terhadap
perubahan state bukan soal render — misalnya menampilkan SnackBar, yang
merupakan aksi sekali jalan. Untuk itu, pakai `ref.listen` langsung di
dalam `build()`:

```dart
ref.listen<int>(counterProvider, (previous, next) {
  if (next % 10 == 0) showSnackBar(...);
});
```

Ini menjalankan callback sekali setiap kali ada perubahan, tanpa membuat
`build()` dipanggil ulang dengan sendirinya.

## Aplikasi yang akan kamu buat

Counter dengan:
- Tombol increment / decrement / reset
- **Pemilih step** (1/2/5/10) — `StateProvider` kedua yang independen,
  dibaca dari dalam callback increment/decrement
- SnackBar yang muncul setiap kali counter melewati kelipatan 10, lewat
  `ref.listen`

## Instruksi

1. Buka `01-start/lib/main.dart` dan kerjakan 9 TODO secara berurutan.
2. Sering-sering dijalankan — lab ini cukup kecil untuk melihat efek tiap
   TODO secara langsung.
3. Bandingkan dengan `02-final/lib/main.dart` kalau sudah selesai.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Kenapa `_CounterDisplay` dibuat jadi widget terpisah, bukan langsung
  `Text('$count', ...)` di dalam `CounterPage`? Apa yang akan kamu lihat
  (pakai Flutter inspector "highlight repaints") kalau kamu inline-kan
  saja?
- Apa yang rusak kalau kamu menulis
  `ref.watch(counterProvider.notifier).state++` di dalam `onPressed`,
  bukan `ref.read`? (Coba sendiri.)
- Kenapa `ref.listen` dipanggil langsung di `build()`, bukan di
  `initState` atau di dalam `onPressed`?

## Jebakan umum

- **Meng-watch `.notifier` alih-alih provider itu sendiri** di dalam
  `build()` — kamu tidak akan mendapat rebuild saat nilainya berubah.
- **Membaca (bukan meng-watch) nilai yang kamu tampilkan** — UI akan
  menampilkan nilai basi (stale) sampai ada hal lain yang memicu rebuild.
- **Memanggil `ref.listen` di luar `build()`** (misalnya di dalam
  callback) — akan error; `ref.listen` hanya valid langsung di dalam
  `build` sebuah widget.

## Lab berikutnya

[Lab 03 — Notifier & logika bisnis](../03-notifier-todo/README.md): saat
satu field mutable saja tidak cukup, pindah ke `Notifier` berbasis class
dengan state yang benar-benar tidak sepele — sebuah daftar todo.
