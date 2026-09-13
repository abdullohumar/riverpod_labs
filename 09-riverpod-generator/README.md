# Lab 09 — Riverpod Code Generation

> Level: mahir · Prasyarat: [Lab 08 — autoDispose & Caching](../08-autodispose-caching/README.md)

## Yang akan kamu pelajari

- Kenapa `riverpod_generator` ada: satu sintaks (`@riverpod`) alih-alih
  harus memilih sendiri antara `Provider`/`FutureProvider`/
  `StreamProvider`/`NotifierProvider`/...
- Alur kerja `build_runner`: `build` (sekali jalan) vs `watch` (generate
  ulang otomatis tiap disimpan)
- Bahwa family otomatis dikenali dari parameter tambahan fungsi — tanpa
  sintaks `.family`, dan kamu dapat parameter bernama/opsional secara
  gratis
- Perubahan default: provider hasil generate **autoDispose secara
  default**, kebalikan dari default API manual — dan cara keluar dari
  itu dengan `@Riverpod(keepAlive: true)`

## Kenapa repot-repot, kalau sudah tahu API manualnya?

Semua yang kamu pelajari di Lab 01-08 tetap berlaku — `@riverpod` cuma
cara BERBEDA untuk MENULIS provider, bukan model mental yang berbeda.
Generator ini bernilai karena menghilangkan boilerplate dan jebakan:

- Tidak perlu lagi memilih sendiri class provider yang "tepat" — fungsi
  biasa menjadi `Provider`, fungsi `async` menjadi `FutureProvider`,
  fungsi yang mengembalikan `Stream` menjadi `StreamProvider`, dan class
  menjadi `NotifierProvider`/`AsyncNotifierProvider` — generator membaca
  signature fungsi/class-mu dan memilihkan untukmu.
- Argumen family cukup jadi parameter fungsi biasa — termasuk banyak
  parameter, bernama, dan opsional, yang tidak bisa dilakukan API
  `.family` manual (dia hanya menerima tepat satu argumen).
- autoDispose-sebagai-default mendorongmu ke arah default yang lebih
  aman dari Lab 08 tanpa perlu ingat mengetik `.autoDispose` di
  mana-mana.

## Provider berbasis fungsi

```dart
part 'providers.g.dart'; // wajib di setiap file yang memakai @riverpod

@riverpod
String greeting(Ref ref) => 'Hello world';           // -> Provider<String>, autoDispose

@riverpod
Future<List<String>> searchWords(Ref ref, String query) async { ... } // -> FutureProvider.autoDispose.family
```

## Provider berbasis class

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;          // state awal, ide yang sama seperti Notifier di Lab 03

  void increment() => state++;
}
```

`_$Counter` di-generate otomatis oleh `build_runner` — dia belum ada
sampai kamu menjalankan generator, itulah kenapa editor-mu akan
menampilkan error sebelum itu. Ini normal, bukan kesalahan.

## Keluar dari autoDispose: `@Riverpod(keepAlive: true)`

```dart
@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build() => 0;
  ...
}
```

Pakai ini untuk state yang memang seharusnya bertahan lebih lama dari
layarnya — persis keputusan yang sama seperti memilih TIDAK menambahkan
`.autoDispose` secara manual di Lab 08, cuma dieja berbeda.

## Alur kerja build_runner

```bash
# build sekali jalan (pakai setelah selesai satu batch perubahan):
dart run build_runner build -d

# generate ulang otomatis di setiap save (pakai saat aktif coding):
dart run build_runner watch -d
```

`-d` (`--delete-conflicting-outputs`) menghindari error umum di mana
file hasil generate yang basi menghalangi file baru untuk ditulis.

## Aplikasi yang akan kamu buat

Trio konsep greeting/counter/search-words yang sama dari lab-lab
sebelumnya, semuanya didefinisikan dengan `@riverpod` dalam satu
`providers.dart`, bukan tersebar di beberapa deklarasi provider yang
ditulis tangan.

## Instruksi

1. Buka `01-start/lib/providers.dart` dan baca ketiga TODO-nya dulu —
   mereka tidak saling bergantung, tapi file ini tidak akan bisa
   di-compile sampai ketiganya selesai DAN kamu menjalankan generator-nya.
2. Kerjakan ketiga TODO-nya.
3. Dari dalam `01-start/`, jalankan:
   ```bash
   flutter pub get
   dart run build_runner build -d
   ```
4. `providers.g.dart` seharusnya muncul di samping `providers.dart`.
   Kalau editor masih menampilkan error, jalankan ulang perintah di
   atas (atau cek output terminal untuk error generator sebenarnya —
   biasanya typo di anotasi atau nama class).
5. `flutter run` — `main.dart` tidak perlu diubah.
6. Bandingkan dengan `02-final` (yang sudah punya `providers.g.dart`
   ter-generate, jadi langsung bisa dijalankan).

## Checkpoint questions

- Kenapa `searchWordsProvider` harus dipanggil sebagai
  `searchWordsProvider(_query)` dari widget, persis seperti
  `.family` manual di Lab 05/06, padahal kamu tidak pernah menulis
  `.family` di mana pun?
- Apa sebenarnya yang salah (compile error) kalau kamu lupa baris
  `part 'providers.g.dart';`?
- Kalau `Counter` memakai `@riverpod` biasa alih-alih
  `@Riverpod(keepAlive: true)`, apa yang akan kamu amati pada nilai
  counter kalau kamu berpindah dari `HomePage` lalu kembali lagi?

## Jebakan umum

- **Lupa menjalankan generator setelah setiap perubahan anotasi** —
  file `.g.dart` adalah hasil build, bukan sesuatu yang kamu edit
  manual atau yang meng-update dirinya sendiri; kalau perubahanmu tidak
  terlihat, kemungkinan besar kamu lupa menjalankan ulang
  `build_runner`.
- **Mengedit file `.g.dart` hasil generate secara langsung** — file ini
  ditulis ulang sepenuhnya di setiap build, jadi edit manual apa pun
  akan hilang begitu saja.
- **Mencampur sintaks `@riverpod` dan manual secara tidak konsisten**
  di satu project nyata tanpa alasan jelas — pilih satu gaya per
  codebase (atau per batasan yang jelas) supaya rekan timmu tidak
  perlu menebak pola mana yang berlaku di mana.

## Lab berikutnya

[Lab 10 — Testing Riverpod](../10-testing-riverpod/README.md): unit-test
provider secara terisolasi memakai `ProviderContainer` dan override — ini
berlaku sama saja baik providernya ditulis tangan maupun hasil generate.
