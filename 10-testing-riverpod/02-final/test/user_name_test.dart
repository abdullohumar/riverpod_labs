import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_testing_app/providers/user_providers.dart';
import 'package:riverpod_testing_app/repository/user_repository.dart';

/// LAB 10 — TESTING RIVERPOD (bagian 2: meng-override dependency dengan mock)
///
/// `userNameProvider` bergantung pada `userRepositoryProvider`, yang
/// biasanya menghasilkan `UserApiRepository` — panggilan network asli
/// (di sini: disimulasikan). Di dalam test kita tidak mau itu: lambat,
/// dan bukan itu yang sedang kita uji. Kita ganti dengan mock memakai
/// `overrideWithValue`.
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  test('userNameProvider resolves with the repository\'s value', () async {
    final mockRepository = MockUserRepository();
    when(() => mockRepository.fetchUserName()).thenAnswer((_) async => 'Grace Hopper');

    final container = ProviderContainer.test(
      overrides: [
        // Setiap ref.watch(userRepositoryProvider) di dalam container ini
        // sekarang mengembalikan mock kita, bukan membuat
        // UserApiRepository asli.
        userRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );

    // `provider.future` pada sebuah FutureProvider meng-await nilainya
    // langsung — berguna di test kalau kamu tidak mau meng-poll
    // AsyncValue secara manual.
    final name = await container.read(userNameProvider.future);

    expect(name, 'Grace Hopper');
    verify(() => mockRepository.fetchUserName()).called(1);
  });

  test('userNameProvider surfaces a repository error as AsyncError', () async {
    final mockRepository = MockUserRepository();
    // Pakai `thenAnswer` (bukan `thenThrow`) untuk method async:
    // `thenThrow` membuat stub-nya melempar error SECARA SINKRON begitu
    // dipanggil, yang tidak cocok dengan cara method pengembali `Future`
    // sungguhan gagal (dia mengembalikan Future yang baru selesai dengan
    // error belakangan).
    when(() => mockRepository.fetchUserName()).thenAnswer((_) async => throw Exception('network down'));

    final container = ProviderContainer.test(
      overrides: [userRepositoryProvider.overrideWithValue(mockRepository)],
      // Riverpod 3.x otomatis me-retry provider yang gagal (exponential
      // backoff, beberapa kali percobaan) SEBELUM akhirnya masuk ke
      // AsyncError — bagus untuk gangguan network sungguhan, buruk untuk
      // test yang cepat dan deterministik. Menonaktifkannya di sini
      // membuat provider gagal di percobaan pertama.
      retry: (retryCount, error) => null,
    );

    await expectLater(
      container.read(userNameProvider.future),
      throwsA(isA<Exception>()),
    );

    // Setelah Future-nya ditolak, AsyncValue milik provider itu sendiri
    // seharusnya juga sudah masuk ke kondisi error (bukan masih loading).
    expect(container.read(userNameProvider), isA<AsyncError<String>>());
  });
}
