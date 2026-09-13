# Lab 10 — Testing Riverpod

> Level: mahir · Prasyarat: [Lab 09 — Riverpod Code Generation](../09-riverpod-generator/README.md)

## Yang akan kamu pelajari

- `ProviderContainer`: `ProviderScope` "tanpa kepala" untuk testing —
  tidak ada widget, tidak ada `pumpWidget`, cuma provider
- `ProviderContainer.test()`: container yang auto-dispose untuk testing
- `overrideWithValue`: mengganti dependency asli (repository yang
  memukul network) dengan mock, memakai `package:mocktail`
- `container.listen`: padanan `ref.listen` di luar widget, berguna untuk
  menghitung berapa kali sesuatu berubah
- Perilaku Riverpod 3.x yang wajib diketahui setiap penguji:
  **provider otomatis retry saat error**, yang harus kamu nonaktifkan
  untuk test yang cepat dan deterministik

Materi sesungguhnya di lab ini ada di `test/`, bukan `lib/` — kode
aplikasinya (`TodoNotifier`, `UserRepository`) sudah diberikan lengkap,
tidak seperti lab-lab sebelumnya.

## Kenapa `ProviderContainer` alih-alih pumping widget?

Kamu BISA menguji logika Riverpod lewat widget (`WidgetTester.pumpWidget`
+ `ProviderScope`), tapi itu lambat dan menyeret seluruh rendering
pipeline Flutter hanya untuk menguji sesuatu yang seringnya cuma logika
Dart murni. `ProviderContainer` memberimu provider graph tanpa semua itu:

```dart
test('addTodo appends a new todo', () {
  final container = ProviderContainer.test();

  container.read(todosProvider.notifier).addTodo('Buy milk');

  expect(container.read(todosProvider), hasLength(1));
});
```

`container.read(provider)` dan `container.read(provider.notifier)`
bekerja persis seperti `ref.read` — karena memang benar-benar itulah
mereka di baliknya.

`ProviderContainer.test()` (baru di Riverpod 3.x) adalah kemudahan
kecil: dia mendaftarkan pembongkarannya sendiri dengan `addTearDown`,
jadi kamu tidak perlu menulis `addTearDown(container.dispose)` sendiri di
setiap test. Kedua bentuk bekerja sama persis selain itu.

## Meng-override dependency: `overrideWithValue` + mocktail

Inilah kenapa `UserRepository` di Lab 10 adalah **class abstract** dengan
implementasi asli (`UserApiRepository`) — ini memungkinkan sebuah test
mengganti dengan implementasi palsu tanpa menyentuh kode
`userNameProvider` sama sekali:

```dart
class MockUserRepository extends Mock implements UserRepository {}

test('resolves with the repository value', () async {
  final mock = MockUserRepository();
  when(() => mock.fetchUserName()).thenAnswer((_) async => 'Grace Hopper');

  final container = ProviderContainer.test(
    overrides: [userRepositoryProvider.overrideWithValue(mock)],
  );

  expect(await container.read(userNameProvider.future), 'Grace Hopper');
});
```

Setiap `ref.watch(userRepositoryProvider)` di mana pun di provider graph
sekarang mengembalikan `mock`, bukan membuat `UserApiRepository` asli —
termasuk di dalam `userNameProvider`, yang tidak pernah tahu dirinya
sedang diuji.

**Jebakan mocktail**: untuk method async, stub kegagalannya dengan
`thenAnswer((_) async => throw Exception(...))`, BUKAN `thenThrow(...)`.
`thenThrow` membuat stub-nya melempar error secara SINKRON begitu
dipanggil, yang tidak cocok dengan cara method `Future` sungguhan gagal
(dia mengembalikan `Future` yang *baru menolak* belakangan).

## Jebakan retry

Riverpod 3.x otomatis meng-retry provider yang error — beberapa kali
percobaan dengan delay yang makin lama, dimaksudkan untuk meredam
gangguan network sesaat di dunia nyata. Di dalam test, ini justru yang
tidak kamu inginkan: itu membuat test jalur error jadi lambat (atau,
kalau timeout milik test-mu lebih pendek dari seluruh urutan retry-nya,
itu membuat test gagal dengan timeout yang membingungkan, bukan dengan
assertion sungguhanmu). Nonaktifkan secara eksplisit untuk test yang
deterministik:

```dart
final container = ProviderContainer.test(
  overrides: [...],
  retry: (retryCount, error) => null, // jangan pernah retry
);
```

## Instruksi

1. Baca `lib/models/todo.dart`, `lib/providers/todo_notifier.dart`,
   `lib/repository/user_repository.dart`, dan
   `lib/providers/user_providers.dart` — semuanya lengkap, tidak ada yang
   perlu diubah.
2. `01-start/test/todo_notifier_test.dart` — TODO 1-6.
3. `01-start/test/user_name_test.dart` — TODO 7-8.
4. Jalankan test-mu sambil mengerjakan:

```bash
cd 01-start
flutter pub get
flutter test
```

5. Bandingkan dengan `02-final/test/` kalau buntu.

## Checkpoint questions

- Kenapa `UserRepository` adalah class abstract, bukan langsung memakai
  `UserApiRepository` di mana-mana? Apa yang akan rusak di test kalau
  `userNameProvider` memanggil `UserApiRepository()` langsung, bukan
  lewat `userRepositoryProvider`?
- Apa bedanya yang dibuktikan `container.listen` di test terakhir
  `todo_notifier_test.dart`, dibanding test-test sebelumnya (yang hanya
  mengecek nilai akhir `container.read(todosProvider)`)?
- Kenapa menonaktifkan retry lebih penting untuk test ERROR
  dibandingkan test SUKSES di `user_name_test.dart`?

## Jebakan umum

- **Lupa men-dispose container** — `ProviderContainer.test()` menangani
  ini untukmu; `ProviderContainer()` biasa butuh
  `addTearDown(container.dispose)` secara eksplisit, kalau tidak state
  bisa bocor antar test.
- **`thenThrow` pada method async** (lihat di atas) — menghasilkan
  kegagalan yang membingungkan yang terlihat seperti bug Riverpod
  padahal sebenarnya kesalahan stubbing.
- **Menguji lewat widget padahal tidak perlu** — kalau yang kamu
  verifikasi adalah logika bisnis (method sebuah Notifier, hasil hitungan
  provider turunan), `ProviderContainer` lebih cepat dan sederhana
  dibanding `pumpWidget`. Simpan widget test untuk memverifikasi UI itu
  sendiri.

## Lab berikutnya

[Lab 11 — Capstone: Notes App](../11-capstone-notes-app/README.md):
gabungkan semua dari Lab 01-10 — Notifier, AsyncNotifier, family,
provider turunan, persistence, dan testing — menjadi satu aplikasi
nyata, meski kecil.
