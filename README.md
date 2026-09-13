# Riverpod Labs

Lab praktik untuk belajar [Riverpod](https://riverpod.dev), library state
management Flutter yang paling banyak dipakai. Sebelas lab progresif akan
membawamu dari "apa itu provider" sampai membuat aplikasi kecil yang
nyata, teruji, dan datanya tersimpan (persisted).

Terdiri dari `01-start` (kerangka kode dengan `TODO` bernomor yang harus kamu
lengkapi) dan `02-final` (solusi lengkap sebagai pembanding). **Materi
pembelajaran yang sesungguhnya ada di `README.md` setiap lab** — teori,
penjelasan konsep, pembahasan kode, pertanyaan pemahaman, dan jebakan
umum (common pitfalls). Folder lab itu untuk praktik, README itu untuk
belajar. Mulailah dari situ untuk setiap lab.

## Prasyarat

- Sudah nyaman dengan Dart dan widget dasar Flutter (`StatelessWidget`,
  `StatefulWidget`, `setState`).
- Flutter SDK sudah terpasang (`flutter --version`). Lab ini dibuat dan
  diverifikasi dengan **Flutter 3.35+ / Dart 3.13+** menggunakan
  **Riverpod 3.4.x** (`flutter_riverpod: ^3.4.3`). Riverpod 3.x mengubah
  beberapa perilaku default dibanding versi 2.x — setiap lab akan
  menjelaskan hal ini di bagian yang relevan (lihat terutama Lab 02 dan
  Lab 08).
- Tidak perlu pengalaman state management sebelumnya. `setState` adalah
  satu-satunya bekal dasar yang diasumsikan.

## Cara memakai tiap lab

```bash
cd 0N-nama-lab/01-start
flutter pub get
flutter run
```

1. Baca `README.md` lab tersebut sampai selesai sebelum membuka kode
   apa pun.
2. Kerjakan `TODO` bernomor di `01-start` secara berurutan — antar TODO
   dalam satu lab saling berkaitan.
3. Bandingkan hasilmu dengan `02-final` (perintah sama:
   `flutter pub get` && `flutter run`).
4. Jawab sendiri "Checkpoint questions" di akhir setiap README sebelum
   lanjut ke lab berikutnya — pertanyaan ini dirancang untuk menangkap
   kalau kamu cuma baca sekilas tanpa benar-benar paham.

Lab 09 dan 11 juga butuh menjalankan code generator:

```bash
dart run build_runner build -d
```

(`-d` menghapus hasil generate lama yang bisa bentrok dengan yang baru —
pakai `dart run build_runner watch -d` saat sedang aktif coding, supaya
otomatis re-generate setiap kali file disimpan.)

## Kurikulum

| # | Lab | Konsep inti | API baru |
|---|---|---|---|
| 01 | [Provider Basics](01-provider-basics/README.md) | Dependency injection, `ref.watch` vs `ref.read` | `Provider`, `ConsumerWidget` |
| 02 | [StateProvider Counter](02-stateprovider-counter/README.md) | State sederhana yang bisa berubah, side effect | `StateProvider`, `ref.listen` |
| 03 | [Notifier](03-notifier-todo/README.md) | State berbasis class + logika bisnis, immutability | `Notifier`, `NotifierProvider` |
| 04 | [Computed Providers](04-computed-providers/README.md) | Provider yang bergantung pada provider lain, rebuild selektif | `.select` |
| 05 | [Family Providers](05-family-provider/README.md) | Provider berparameter, cache per argumen | `.family` |
| 06 | [FutureProvider & AsyncValue](06-futureprovider-async/README.md) | Data asinkron, penanganan loading/error | `FutureProvider`, `AsyncValue.when` |
| 07 | [StreamProvider](07-streamprovider/README.md) | Data live/berkelanjutan, cleanup | `StreamProvider`, `StreamNotifier` |
| 08 | [autoDispose & Caching](08-autodispose-caching/README.md) | Siklus hidup provider, memori | `.autoDispose`, `ref.keepAlive()` |
| 09 | [Riverpod Code Generation](09-riverpod-generator/README.md) | Provider hasil generate, autoDispose sebagai default | `@riverpod`, `build_runner` |
| 10 | [Testing Riverpod](10-testing-riverpod/README.md) | Unit test provider secara terisolasi | `ProviderContainer`, `overrideWithValue` |
| 11 | [Capstone: Notes App](11-capstone-notes-app/README.md) | Semua konsep di atas digabung, plus persistence | — |

Kerjakan berurutan untuk yang pertama kali — lab-lab berikutnya
mengasumsikan kamu sudah paham konsep sebelumnya dan tidak akan
menjelaskan ulang. Lab 01-08 sengaja memakai sintaks provider manual
(ditulis tangan) supaya kamu benar-benar paham apa yang sebenarnya
terjadi sebelum Lab 09 menunjukkan versi generate otomatis yang lebih
ringkas.

## Ciri-ciri "jago" setelah menyelesaikan semua lab

Setelah menyelesaikan Lab 11, kamu seharusnya bisa, tanpa perlu mencari
referensi lagi:

- Memilih tipe provider yang tepat untuk suatu state (sync vs async,
  bisa diubah vs turunan/derived, tunggal vs berparameter)
- Menjelaskan perbedaan `ref.watch`, `ref.read`, dan `ref.listen`, serta
  tahu kapan masing-masing dipakai
- Menulis `Notifier`/`AsyncNotifier` dengan update state yang immutable
- Memutuskan kapan sebuah provider sebaiknya `autoDispose` dan kapan
  tidak
- Menulis dan menjalankan unit test untuk logika bisnis di provider,
  dengan dependency yang di-mock
- Membaca dan menulis sintaks manual maupun sintaks hasil generate
  (`@riverpod`)

## Setelah lab ini selesai

Riverpod adalah library yang besar; 11 lab ini mencakup 90% kebutuhan
sehari-hari. Setelah nyaman dengan semua ini, langkah selanjutnya yang
paling bernilai ada di bagian "Next lab" masing-masing README, dan
dirangkum di akhir
[Lab 11](11-capstone-notes-app/README.md#kemana-selanjutnya) — intinya:
baca dokumentasi resmi di [riverpod.dev](https://riverpod.dev) untuk
resep-resep siap pakai (pagination, persistence offline, digabung dengan
routing) yang lebih mudah dicari saat dibutuhkan daripada dipelajari
ulang dari nol.
