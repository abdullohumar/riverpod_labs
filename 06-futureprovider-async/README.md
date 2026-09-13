# Lab 06 — FutureProvider & AsyncValue

> Level: menengah · Prasyarat: [Lab 05 — Family Providers](../05-family-provider/README.md)

## Yang akan kamu pelajari

- `FutureProvider<T>`: menjalankan fungsi asinkron dan menyediakan
  hasilnya
- `AsyncValue<T>`: tipe yang merepresentasikan "data ATAU loading ATAU
  error," dan method `.when(data:, loading:, error:)`-nya
- `ref.invalidate(provider)`: memaksa provider dihitung ulang (retry
  setelah error, atau refresh sesuai kebutuhan)
- `ref.refresh(provider.future)`: versi yang juga memungkinkanmu
  `await` nilai barunya (dipakai untuk pull-to-refresh)
- Menggabungkan `.family` (Lab 05) dengan data asinkron — bentuk yang
  sangat umum: "layar detail untuk id X, diambil dari network"

## Kenapa `AsyncValue` alih-alih `Future` + `FutureBuilder` biasa?

`FutureBuilder` mengharuskanmu mengecek `snapshot.connectionState` dan
`snapshot.hasError` secara manual — gampang lupa satu cabang, dan gampang
tidak sengaja membuat ulang Future itu di setiap rebuild kalau tidak
hati-hati. `FutureProvider` menyelesaikan keduanya:

- Future-nya dibuat **sekali saja** di dalam provider (bukan setiap
  widget rebuild)
- hasilnya disediakan sebagai `AsyncValue<T>`, tipe dengan tepat tiga
  kemungkinan, dan `.when` mengharuskanmu menangani ketiganya:

```dart
final articlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.watch(articleRepositoryProvider).fetchArticles();
});

// di dalam widget:
ref.watch(articlesProvider).when(
  data: (articles) => ListView(...),
  loading: () => const CircularProgressIndicator(),
  error: (error, stackTrace) => Text('Oops: $error'),
);
```

## Retry dan refresh

- **`ref.invalidate(provider)`** — menandai provider sebagai basi
  (stale). Pembacaan berikutnya akan menghitungnya ulang dari nol.
  Sempurna untuk tombol "Retry" setelah error.
- **`ref.refresh(provider.future)`** — melakukan hal yang sama, tapi juga
  mengembalikan `Future` hasilnya, jadi kamu bisa `await`. Ini persis
  yang dibutuhkan `RefreshIndicator.onRefresh`:

```dart
RefreshIndicator(
  onRefresh: () => ref.refresh(articlesProvider.future),
  child: ...,
)
```

## `.family` + async

Tidak ada yang baru secara sintaks — ini persis `.family` dari Lab 05,
cuma providernya kebetulan builder-nya `async`:

```dart
final articleProvider = FutureProvider.family<Article, String>((ref, id) {
  return ref.watch(articleRepositoryProvider).fetchArticle(id);
});
```

## Aplikasi yang akan kamu buat

Daftar artikel (`articlesProvider`, sekitar 20% kemungkinan error network
simulasi setiap kali dimuat, jadi kamu AKAN melihat kondisi error) dengan
pull-to-refresh, dan layar detail per artikel (`articleProvider.family`)
dengan tombol retry-saat-error sendiri.

## Instruksi

1. `01-start/lib/providers/article_providers.dart` — TODO 1-2.
2. `01-start/lib/main.dart` — TODO 3-6.
3. Jalankan aplikasinya beberapa kali — karena tingkat kegagalan simulasi
   ~20%, kamu seharusnya melihat baik jalur sukses maupun jalur
   error + retry.
4. Bandingkan dengan `02-final`.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Apa bedanya `ref.invalidate(provider)` dan `ref.refresh(provider)` —
  kapan kamu pakai yang satu dibanding yang lain? (Hint: lihat apa yang
  dikembalikan masing-masing.)
- Kenapa `articleRepositoryProvider` ada sebagai `Provider`-nya sendiri,
  bukan langsung memanggil `ArticleRepository()` di dalam
  `articlesProvider` dan `articleProvider`?
- Apa yang terjadi pada `AsyncValue` milik `articlesProvider` tepat saat
  kamu memanggil `ref.refresh` — apakah langsung kembali ke `AsyncLoading`,
  atau tetap menampilkan data lama sambil mengambil ulang? Coba amati
  sendiri (hint: yang terjadi adalah yang kedua kecuali kamu
  mengonfigurasinya sebaliknya — ini layak dibaca lebih lanjut di
  dokumentasi resmi bagian "AsyncValue.when(skipLoadingOnRefresh)").

## Heads up: Riverpod otomatis retry provider yang gagal

Kamu mungkin memperhatikan kondisi error tidak selalu muncul walaupun
repository-nya punya kemungkinan ~20% gagal setiap kali dimuat: Riverpod
3.x melakukan retry beberapa kali dengan delay yang makin lama sebelum
akhirnya menyerah dan masuk ke `AsyncError`. Ini adalah default yang
sengaja dibuat, dan bisa dikonfigurasi, untuk meredam gangguan network
sesaat di dunia nyata — artinya kamu mungkin perlu reload beberapa kali
(atau kebetulan gagal beberapa kali berturut-turut) untuk benar-benar
melihat UI error-nya, dan sebuah kegagalan bisa butuh waktu lebih lama
untuk muncul dibanding delay 1 detik yang kamu duga. Lab 10 menunjukkan
cara mengontrol (atau menonaktifkan) perilaku ini, yang sangat penting
begitu kamu mulai menulis test deterministik untuk jalur error.

## Jebakan umum

- **Membuat Future di dalam widget** (misalnya memanggil
  `repository.fetchArticles()` langsung di `build()`) alih-alih di dalam
  `FutureProvider` — ini mengambil ulang data di setiap rebuild, yang
  hampir tidak pernah kamu inginkan.
- **Lupa cabang `error` di `.when`** — `.when` mengharuskan ketiga cabang
  saat compile time justru untuk mencegah ini, tapi gampang saja
  di-stub dengan sesuatu yang tidak berguna seperti
  `error: (_, __) => Container()` yang diam-diam menyembunyikan kegagalan
  sungguhan dari pengguna.
- **Bingung antara `ref.watch(provider)` (mengembalikan `AsyncValue<T>`)
  dengan `ref.watch(provider.future)`** (mengembalikan `Future<T>`, dan
  melempar ulang error) — pakai yang pertama untuk membangun UI, yang
  kedua terutama untuk `await` di dalam konteks async lain (seperti
  `onRefresh` di atas).

## Lab berikutnya

[Lab 07 — StreamProvider](../07-streamprovider/README.md): model
`AsyncValue` yang sama, tapi untuk data berkelanjutan alih-alih
pengambilan satu kali.
