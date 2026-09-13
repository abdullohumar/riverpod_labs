# Lab 01 — Provider Basics

> Level: pemula · Prasyarat: dasar widget Flutter (`StatelessWidget`, `StatefulWidget`)

## Yang akan kamu pelajari

- Kenapa library state management itu ada, dan masalah apa yang
  diselesaikan Riverpod
- `ProviderScope`: tempat state provider sebenarnya disimpan
- `Provider<T>`: provider paling sederhana, untuk nilai yang tidak berubah
- `ConsumerWidget` / `ConsumerStatefulWidget`: cara widget membaca provider
- Perbedaan `ref.watch` dan `ref.read`, dan kapan masing-masing dipakai

## Kenapa tidak pakai `setState` / singleton / `InheritedWidget` saja?

- `setState` mengikat state ke lifetime satu widget saja — untuk berbagi
  state ke widget sibling, kamu harus "mengangkat" (lift up) state itu,
  yang makin merepotkan seiring tree makin besar.
- Singleton global (`AppRepository.instance`) memang berfungsi, tapi
  mustahil diganti (di-swap) saat testing, dan tidak punya lifecycle sama
  sekali (tidak pernah di-dispose).
- `InheritedWidget` menyelesaikan masalah berbagi state, tapi menulisnya
  sendiri untuk setiap potongan state itu banyak boilerplate, dan tidak
  punya caching, laziness, atau dependency graph bawaan.

Riverpod memberi cara deklaratif, aman secara compile-time, dan mudah
di-test untuk mendeklarasikan "potongan-potongan state" (disebut
**provider**) dan membacanya dari mana saja di widget tree tanpa perlu
diteruskan manual ke bawah.

## Konsep inti: `Provider<T>`

```dart
final appInfoProvider = Provider<AppInfo>((ref) {
  return const AppInfo(name: 'My App', version: '1.0.0');
});
```

Sebuah `Provider`:
- menjalankan fungsinya secara **lazy** — hanya saat pertama kali dibaca
- **meng-cache** hasilnya — setiap pembacaan berikutnya mengembalikan
  nilai yang sama
- **tidak punya API untuk mengubah nilainya sendiri** di kemudian hari

Poin terakhir itu yang penting untuk lab ini: `Provider` dipakai untuk
konstanta, nilai turunan/hasil komputasi, dan dependency injection
(service, repository, konfigurasi). Kalau kamu merasa ingin meng-assign
ulang nilai `Provider` sebagai reaksi dari sebuah tombol yang ditekan,
sebenarnya yang kamu butuhkan adalah `StateProvider` (Lab 02) atau
`Notifier` (Lab 03).

## `ref.watch` vs `ref.read`

| | `ref.watch(provider)` | `ref.read(provider)` |
|---|---|---|
| Kapan dipakai | Di dalam `build()`, untuk nilai yang harus direaksi widget | Di dalam callback (`onPressed`, `initState`, dll) untuk pembacaan sekali pakai |
| Berlangganan perubahan? | Ya — widget rebuild saat nilainya berubah | Tidak |
| Kesalahan umum | — | Memanggil `ref.watch` di dalam callback (error/perilaku aneh) atau `ref.read` di dalam `build` (widget tidak ter-update) |

Aturan praktis: **watch di build, read di callback.**

## Aplikasi yang akan kamu buat

Layar "dashboard" kecil yang menampilkan:
1. Nama/versi aplikasi dari `Provider<AppInfo>`
2. Sapaan berdasarkan waktu dari `Provider<String>` (nilai *turunan* —
   berupa logika, bukan sekadar konstanta)
3. Tombol "New quote" yang didukung `QuoteRepository`, diinjeksikan lewat
   `Provider<QuoteRepository>`, diambil dengan `ref.read` di dalam
   `onPressed` tombol

## Instruksi

1. Buka `01-start/lib/main.dart`.
2. Kerjakan 8 `TODO` bernomor dari atas ke bawah. Setiap TODO adalah
   perubahan kecil — jangan tergoda untuk melompat ke depan.
3. Jalankan aplikasinya setelah tiap TODO kalau mau (`flutter run`) untuk
   melihat progresnya sedikit demi sedikit.
4. Buntu? Bandingkan dengan `02-final/lib/main.dart`, yang berisi solusi
   lengkap dengan komentar.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

Jawab sendiri sebelum lanjut ke Lab 02 — kalau tidak bisa jawab, baca
ulang bagian di atas:

- Kenapa `_QuoteCard` tetap harus jadi `StatefulWidget`, padahal aplikasi
  ini sudah pakai Riverpod?
- Apa yang terjadi kalau kamu pakai `ref.watch` (bukan `ref.read`) di
  dalam `_newQuote()`? (Coba sendiri dan lihat error/perilakunya.)
- Apa yang terjadi kalau callback `appInfoProvider` ada `print()` di
  dalamnya — berapa kali dia akan tercetak kalau ada tiga widget berbeda
  yang meng-watch provider itu?

## Jebakan umum (common pitfalls)

- **Lupa memasang `ProviderScope`** di root — setiap pemanggilan
  `ref.watch`/`ref.read` akan error `Bad state: No ProviderScope found`.
- **Memakai `ref.watch` di dalam callback** — memang "jalan" sekali, tapi
  itu alat yang salah: tidak me-rebuild apa-apa (tidak ada `build()` yang
  di-rebuild) dan diam-diam membuat subscription yang tidak perlu.
- **Berharap `Provider` bisa berubah** — kalau sebuah nilai perlu berubah
  seiring waktu, `Provider` bukan alat yang tepat. Itulah topik lab
  berikutnya.

## Lab berikutnya

[Lab 02 — StateProvider](../02-stateprovider-counter/README.md): provider
paling sederhana yang *bisa* berubah, dan contoh counter klasik yang
dibangun ulang dengan cara Riverpod.
