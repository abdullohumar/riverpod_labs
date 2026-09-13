# Lab 08 — autoDispose & Caching

> Level: mahir · Prasyarat: [Lab 07 — StreamProvider](../07-streamprovider/README.md)
> (kunjungi ulang juga [Lab 05 — Family Providers](../05-family-provider/README.md))

## Yang akan kamu pelajari

- `.autoDispose`: menghancurkan state sebuah provider begitu tidak ada
  yang meng-watch-nya lagi
- Kenapa ini penting TERUTAMA saat digabung dengan `.family` (Lab 05
  sudah mengingatkan ini: pemakaian family tanpa batas tanpa autoDispose
  membocorkan memori)
- `ref.keepAlive()`: mengecualikan satu instance autoDispose tertentu
  dari pembuangan otomatis, dengan syaratmu sendiri
- `ref.onDispose(...)`: cleanup, dibahas ulang dari Lab 07 dalam konteks
  baru
- Melakukan debounce pada input pengguna sebelum dimasukkan ke provider

## Kenapa provider tidak dispose secara default

Sebuah `Provider`/`Notifier`/dll tanpa `.autoDispose` hidup selama
`ProviderScope`-nya masih ada — bahkan setelah widget terakhir yang
meng-watch-nya sudah hilang. Ini default yang disengaja: banyak provider
(konfigurasi aplikasi, state auth, keranjang belanja global) SEHARUSNYA
hidup lebih lama dari satu layar mana pun. Tapi ini default yang salah
untuk state yang secara alami terikat pada satu layar atau satu query
pencarian.

## Masalahnya, secara konkret

Dari Lab 05: `cartQuantityProvider('p1')`, `cartQuantityProvider('p2')`,
dst masing-masing mendapat entry cache permanen. Baik-baik saja untuk
katalog kecil yang tetap. Sekarang bayangkan argumen family-nya adalah
input bebas dari pengguna — kotak pencarian. Setiap keystroke ("r", "ri",
"riv", "rive"...) membuat instance provider BARU yang di-cache secara
permanen. Ketik satu kata 10 huruf dan kamu sudah membocorkan 10 instance
provider yang tidak akan pernah dibaca lagi.

## Solusinya: `.autoDispose`

```dart
final searchResultsProvider = FutureProvider.autoDispose.family<List<String>, String>(
  (ref, query) async => repository.search(query),
);
```

Sekarang, begitu tidak ada yang meng-watch
`searchResultsProvider('riv')` lagi (misalnya pengguna mengetik satu
huruf lagi, atau widget-nya di-dispose), state instance itu dibuang
setelah jeda singkat (untuk bertahan dari hal-hal seperti widget rebuild
cepat yang unsubscribe lalu langsung subscribe lagi).

## Mengecualikan nilai tertentu: `ref.keepAlive()`

Kadang kamu MEMANG ingin sebuah nilai autoDispose bertahan sedikit lebih
lama — hasil pencarian yang sukses layak di-cache sebentar kalau-kalau
pengguna mengetik ulang query yang sama, tapi kamu tetap tidak mau
di-cache selamanya.

```dart
final searchResultsProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, query) async {
  final results = await repository.search(query);
  if (results.isNotEmpty) {
    final link = ref.keepAlive();               // hentikan autoDispose sementara
    final timer = Timer(const Duration(seconds: 30), link.close); // ...selama 30 detik
    ref.onDispose(timer.cancel);                 // jangan sampai timer-nya sendiri bocor
  }
  return results;
});
```

Ini pola yang umum dan disengaja: **autoDispose sebagai default, keepAlive
dengan sengaja, untuk waktu terbatas, dengan cleanup milikmu sendiri.**

## Debouncing

Tidak ada yang spesifik Riverpod di sini, tapi ini pasangan alami dari
`.autoDispose.family` untuk kotak pencarian: tunggu sampai pengguna
berhenti mengetik sebelum membuat instance provider baru, supaya kamu
tidak membuat (lalu langsung membuang) satu instance per keystroke.

## Aplikasi yang akan kamu buat

Kotak pencarian di atas daftar kata kecil. Hasil pencarian diambil lewat
`searchResultsProvider.autoDispose.family`, di-debounce 300ms, dengan
hasil sukses di-keep-alive selama 30 detik lewat `ref.keepAlive()`.

## Instruksi

1. `01-start/lib/providers/search_providers.dart` — TODO 1.
2. `01-start/lib/main.dart` — TODO 2-5. Untuk TODO 5, ini pola yang harus
   dicocokkan dengan `resultsAsync` (sebuah `AsyncValue<List<String>>?`):

```dart
switch (resultsAsync) {
  null => const Text('Type to search'),
  AsyncData(value: final results) when results.isEmpty => const Text('No matches'),
  AsyncData(value: final results) => ListView(children: [for (final r in results) ListTile(title: Text(r))]),
  AsyncError(:final error) => Text('Error: $error'),
  _ => const CircularProgressIndicator(),
}
```

3. Jalankan, cari sesuatu, kosongkan kotaknya, cari lagi hal yang sama
   dalam 30 detik — perhatikan pencarian kedua langsung selesai karena
   hasilnya sudah di-`keepAlive`, bukan diambil ulang.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Tanpa `.autoDispose`, apa yang akan terjadi pada pemakaian memori
  `searchResultsProvider` selama sesi mengetik yang panjang, dan kenapa?
- Kenapa timer 30 detiknya dimulai DI DALAM fungsi builder milik provider
  itu sendiri, bukan misalnya di widget?
- Apa bedanya `ref.invalidate(provider)` (Lab 06) dengan sebuah provider
  yang dibuang begitu saja oleh `.autoDispose`? Apakah keduanya berakhir
  melakukan hal yang sama terhadap state cache provider tersebut?

## Jebakan umum

- **Menambahkan `.autoDispose` pada state yang seharusnya memang
  berlaku di seluruh aplikasi** (sesi auth, pengaturan aplikasi) — ini
  menyebabkan reset yang mengejutkan setiap kali satu layar yang
  kebetulan meng-watch-nya sempat ter-unmount.
- **Memanggil `ref.keepAlive()` tanpa syarat** — kalau setiap hasil
  (sukses atau gagal, berguna atau tidak) di-keep-alive selamanya, kamu
  baru saja menciptakan ulang kebocoran aslinya dengan langkah ekstra.
- **Memulai `Timer`/subscription tanpa `ref.onDispose` pasangannya** —
  pelajaran yang sama dari Lab 07, tapi sekarang dua kali lebih penting:
  provider autoDispose dibuat dan dihancurkan jauh lebih sering
  dibanding provider permanen.

## Lab berikutnya

[Lab 09 — Riverpod code generation](../09-riverpod-generator/README.md):
tulis ulang apa yang sudah kamu pelajari memakai anotasi `@riverpod`,
yang menghasilkan boilerplate provider (termasuk default autoDispose
yang tepat) secara otomatis untukmu.
