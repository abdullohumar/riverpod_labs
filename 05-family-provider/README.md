# Lab 05 — Family Providers

> Level: menengah · Prasyarat: [Lab 04 — Computed Providers](../04-computed-providers/README.md)

## Yang akan kamu pelajari

- `.family`: mengubah provider menjadi fungsi dari sebuah argumen
- Bahwa setiap argumen yang berbeda mendapat instance provider-nya
  sendiri, ter-cache dan independen — dengan state sendiri, lifecycle
  sendiri
- Bahwa family provider bisa dipakai dengan SEMUA tipe provider yang
  sudah kamu pelajari: `Provider.family`, `NotifierProvider.family`, dan
  nanti `FutureProvider.family` / `StreamProvider.family`
- Menggabungkan (agregasi) banyak instance family menjadi satu provider
  turunan

## Masalah yang diselesaikan family

Bayangkan katalog produk di mana tiap produk butuh counter "jumlah di
keranjang" sendiri-sendiri. Tanpa `.family`, kamu harus:
- membuat satu `cartQuantityProvider` per produk secara manual (tidak
  scalable, dan katalognya mungkin bahkan belum diketahui saat compile
  time), atau
- menyimpan `Map<String, int>` di satu provider besar dan meng-update-nya
  secara immutable tiap kali berubah (bisa berfungsi, tapi sekarang
  setiap widget yang meng-watch "keranjang" untuk produk A ikut rebuild
  saat jumlah produk B berubah)

`.family` memberi opsi ketiga yang bersih dan scalable: satu *definisi*
provider, dipanggil dengan argumen berbeda-beda, masing-masing argumen
punya state-nya sendiri yang terisolasi.

```dart
final cartQuantityProvider = NotifierProvider.family<CartQuantityNotifier, int, String>(
  CartQuantityNotifier.new,
);

// Di dalam widget:
final qty = ref.watch(cartQuantityProvider(product.id));
```

`cartQuantityProvider('p1')` dan `cartQuantityProvider('p2')` adalah dua
provider yang benar-benar terpisah di baliknya — menambah salah satu
tidak pernah me-rebuild widget yang meng-watch yang lain.

## Family + Notifier: bagaimana argumen sampai ke class-mu

Tidak ada class "family notifier" khusus di Riverpod modern — argumennya
cukup diteruskan ke constructor notifier-mu:

```dart
class CartQuantityNotifier extends Notifier<int> {
  CartQuantityNotifier(this.productId);
  final String productId;

  @override
  int build() => 0;

  void increment() => state++;
}

final cartQuantityProvider = NotifierProvider.family<CartQuantityNotifier, int, String>(
  CartQuantityNotifier.new, // String -> CartQuantityNotifier
);
```

## Menggabungkan (agregasi) antar instance family

Kalau kamu sudah tahu semua argumen sejak awal (di sini: setiap id
produk dalam katalog), kamu bisa meng-watch beberapa instance family
sekaligus di dalam satu `Provider` biasa — persis seperti provider
turunan di Lab 04:

```dart
final cartTotalProvider = Provider<double>((ref) {
  var total = 0.0;
  for (final product in catalog) {
    total += ref.watch(cartQuantityProvider(product.id)) * product.price;
  }
  return total;
});
```

## Aplikasi yang akan kamu buat

Katalog kedai kopi kecil: tiap baris menampilkan produk (lewat
`productProvider.family`) dengan stepper jumlah sendiri (lewat
`cartQuantityProvider.family`), dan total berjalan di bagian bawah (lewat
`cartTotalProvider`, mengagregasi instance family setiap produk).

## Instruksi

1. `01-start/lib/providers/catalog_providers.dart` — TODO 1-3.
2. `01-start/lib/main.dart` — TODO 4-6.
3. Jalankan, tambahkan beberapa item ke beberapa produk berbeda, dan
   pastikan total ter-update dengan benar dan stepper tiap baris
   independen.
4. Bandingkan dengan `02-final`.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Kalau kamu memanggil `ref.watch(cartQuantityProvider('p1'))` dari dua
  widget berbeda, apakah mereka berbagi state, atau mendapat dua counter
  independen? Kenapa?
- Kenapa `_ProductTile` menerima `productId` (sebuah `String`) sebagai
  parameter constructor-nya, bukan seluruh objek `Product`?
- Apa risikonya kalau `.family` dipakai dengan tipe argumen yang tidak
  punya `==`/`hashCode` yang benar (misalnya class mutable, atau
  `List`)?

## Jebakan umum

- **Memakai objek mutable atau yang tidak bisa dibandingkan dengan
  `const`** sebagai argumen family (`List`, class tanpa override `==`) —
  Riverpod memakai argumen untuk memutuskan instance cache mana yang
  dikembalikan; kalau argumen yang terlihat sama ternyata dianggap tidak
  sama, kamu diam-diam mendapat instance (dan provider!) baru setiap
  saat.
- **Lupa bahwa instance family tidak pernah di-dispose secara default** —
  setiap argumen berbeda yang pernah kamu pakai untuk memanggil family
  provider akan menyimpan state-nya selama `ProviderScope` masih hidup,
  kecuali kamu menambahkan `.autoDispose` (Lab 08). Untuk katalog tetap
  ini tidak masalah; untuk id buatan pengguna (misalnya query pencarian)
  ini bisa menyebabkan kebocoran memori.

## Lab berikutnya

[Lab 06 — FutureProvider & async](../06-futureprovider-async/README.md):
provider yang menyimpan data yang perlu *diambil* — awal dari state
asinkron dengan `AsyncValue`.
