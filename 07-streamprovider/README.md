# Lab 07 — StreamProvider & StreamNotifier

> Level: menengah · Prasyarat: [Lab 06 — FutureProvider](../06-futureprovider-async/README.md)

## Yang akan kamu pelajari

- `StreamProvider<T>`: menyediakan nilai-nilai dari sebuah `Stream`
  sebagai `AsyncValue<T>`, versi berkelanjutan dari `FutureProvider`
- `StreamNotifier<T>`: seperti `Notifier` untuk `StateProvider`, ini
  adalah versi "stream + method yang bisa dikontrol" — pakai kalau kamu
  perlu pause/resume/mengubah konfigurasi stream dari UI
- `ref.onDispose(...)`: mendaftarkan cleanup (membatalkan timer, menutup
  controller) yang berjalan saat provider dihapus (dispose)

## `StreamProvider`: kasus sederhana

```dart
final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
```

Meng-watch-nya berlaku persis seperti `AsyncValue` milik `FutureProvider`
— `.when(data:, loading:, error:)` — kecuali `data` terpicu setiap kali
ada event baru, bukan sekali total. `loading` hanya muncul sebelum event
pertama datang.

## `StreamNotifier`: kalau kamu butuh kontrol, bukan cuma data

`StreamProvider` biasa tidak punya cara untuk menyediakan "pause" atau
"reset" — fungsinya hanya mengembalikan `Stream`, tidak ada tempat untuk
menggantungkan method tambahan. `StreamNotifier` memperbaiki ini dengan
cara yang sama seperti `Notifier` memperbaiki keterbatasan
`StateProvider` di Lab 03: dia adalah class, jadi kamu bisa menambahkan
method.

```dart
class TickerNotifier extends StreamNotifier<int> {
  @override
  Stream<int> build() {
    // siapkan controller/timer, daftarkan ref.onDispose untuk
    // membersihkan, kembalikan stream-nya
  }

  void pause() { ... }
  void resume() { ... }
}

final tickerProvider = StreamNotifierProvider<TickerNotifier, int>(TickerNotifier.new);
```

Di dalam class-nya, `ref` tersedia langsung (tidak perlu diteruskan lewat
parameter) — sama seperti `Notifier` dan `AsyncNotifier`.

## Cleanup itu penting: `ref.onDispose`

Apa pun yang kamu mulai secara manual (`Timer`, `StreamController`,
subscription) perlu dihentikan secara manual juga, kalau tidak dia bocor
— tetap berjalan dan menghabiskan memori bahkan setelah tidak ada lagi
yang meng-watch provider-nya.

```dart
@override
Stream<int> build() {
  final timer = Timer.periodic(...);
  ref.onDispose(() => timer.cancel()); // <-- selalu pasangkan dengan setup
  return controller.stream;
}
```

Ini makin penting lagi begitu kamu menambahkan `.autoDispose` (Lab 08),
di mana provider bisa dibuat dan dihancurkan jauh lebih sering.

## Aplikasi yang akan kamu buat

Layar dengan dua nilai live:
1. Jam yang ter-update tiap detik (`clockProvider`, `StreamProvider`
   biasa)
2. Ticker (`tickerProvider`, `StreamNotifier`) dengan tombol Pause /
   Resume / Reset yang memanggil method di notifier

## Instruksi

1. `01-start/lib/providers/stream_providers.dart` — TODO 1-5.
2. `01-start/lib/main.dart` — TODO 6-9.
3. Jalankan, dan pastikan Pause benar-benar menghentikan ticker (jam di
   atasnya tetap berdetak — mereka stream yang independen).
4. Bandingkan dengan `02-final`.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Apa yang terjadi pada aplikasi kalau `TickerNotifier.build()` lupa
  memanggil `ref.onDispose`, dan provider-nya dibuat ulang berkali-kali
  (misalnya dengan `ref.invalidate`)?
- Kenapa `_controller` adalah `StreamController.broadcast()`, bukan yang
  biasa (single-subscription)? Error apa yang akan kamu dapat kalau
  pakai yang biasa dan dua widget meng-watch `tickerProvider`?
- `clockProvider` tidak pernah memanggil `ref.onDispose`. Kenapa ini aman
  di sini, tapi belum tentu aman untuk `TickerNotifier`? (Hint: apa yang
  dipegang `Stream.periodic` dibanding apa yang dipegang
  `TickerNotifier`.)

## Jebakan umum

- **Lupa `ref.onDispose`** untuk apa pun yang punya `Timer`,
  `StreamController`, atau subscription — sumber kebocoran nomor satu di
  provider berbasis Stream.
- **Memakai `StreamController` single-subscription** padahal mungkin
  lebih dari satu widget akan meng-watch provider-nya — Riverpod sendiri
  hanya berlangganan sekali secara internal dan menyiarkan ke widget,
  tapi kalau kamu perlu memeriksa/tee stream-nya di tempat lain juga,
  broadcast menghindari error "Stream has already been listened to".
- **Melakukan kerja async setup langsung di `build()` tanpa `await`** —
  seperti `FutureProvider`/`Notifier`, `StreamNotifier.build()` berjalan
  secara sinkron; dia mengembalikan `Stream`, bukan meng-`await` satu.

## Lab berikutnya

[Lab 08 — autoDispose & caching](../08-autodispose-caching/README.md):
mengontrol kapan tepatnya state sebuah provider dibuang — penting begitu
aplikasimu punya layar yang datang dan pergi.
