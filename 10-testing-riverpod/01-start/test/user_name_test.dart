import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_testing_app/providers/user_providers.dart';
import 'package:riverpod_testing_app/repository/user_repository.dart';

/// LAB 10 — TESTING RIVERPOD (starter, bagian 2: meng-override dependency
/// dengan mock)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // TODO(7): Tulis test bernama
  // "userNameProvider resolves with the repository's value" yang:
  //   - membuat `final mockRepository = MockUserRepository();`
  //   - meng-stub-nya: `when(() => mockRepository.fetchUserName()).thenAnswer((_) async => 'Grace Hopper');`
  //   - membuat `ProviderContainer.test(overrides: [userRepositoryProvider.overrideWithValue(mockRepository)])`
  //   - meng-await `container.read(userNameProvider.future)` dan meng-assert hasilnya sama dengan 'Grace Hopper'
  //   - meng-assert mock-nya benar-benar dipanggil sekali: `verify(() => mockRepository.fetchUserName()).called(1);`

  // TODO(8): Tulis test bernama
  // "userNameProvider surfaces a repository error as AsyncError" yang:
  //   - meng-stub mock-nya supaya gagal secara asinkron:
  //     `when(() => mockRepository.fetchUserName()).thenAnswer((_) async => throw Exception('network down'));`
  //     (BUKAN `thenThrow` — itu melempar error secara sinkron, yang
  //     tidak cocok dengan cara method async sungguhan gagal)
  //   - membuat container dengan override DAN `retry: (retryCount, error) => null`
  //     (Riverpod secara default otomatis me-retry provider yang gagal —
  //     nonaktifkan di sini supaya test-nya gagal dengan cepat dan
  //     deterministik)
  //   - meng-assert `container.read(userNameProvider.future)` ditolak,
  //     memakai `expectLater(..., throwsA(isA<Exception>()))`
  //   - meng-assert `container.read(userNameProvider)` adalah sebuah
  //     `AsyncError<String>`
}
