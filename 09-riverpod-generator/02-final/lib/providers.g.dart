// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// LAB 09 — RIVERPOD CODE GENERATION
///
/// Semua isi file ini adalah fungsi atau class Dart BIASA yang diberi
/// anotasi `@riverpod`. `build_runner` membaca anotasi ini dan menulis
/// `providers.g.dart`, yang berisi definisi
/// `Provider`/`FutureProvider`/`NotifierProvider`/dsb sesungguhnya — mesin
/// yang persis sama dari Lab 01-08, cuma di-generate alih-alih ditulis
/// tangan.
///
/// Jalankan ini sambil kamu mengedit:
///   dart run build_runner watch -d
/// (-d menghapus hasil yang konflik secara otomatis; pakai `build`
/// alih-alih `watch` untuk sekali jalan saja.)
/// Provider berbasis FUNGSI. `@riverpod` pada fungsi top-level yang
/// mengembalikan `T` menghasilkan setara `Provider<T>` — di sini, karena
/// tidak ada parameter tambahan selain `ref`, jadi yang biasa (bukan
/// family).
///
/// DEFAULT PENTING: provider hasil generate itu `autoDispose` SECARA
/// DEFAULT — kebalikan dari default API manual yang kamu pakai di
/// Lab 01-08! Ini `riverpod_generator` mengarahkanmu ke pilihan yang
/// lebih aman (Lab 08).

@ProviderFor(greeting)
final greetingProvider = GreetingProvider._();

/// LAB 09 — RIVERPOD CODE GENERATION
///
/// Semua isi file ini adalah fungsi atau class Dart BIASA yang diberi
/// anotasi `@riverpod`. `build_runner` membaca anotasi ini dan menulis
/// `providers.g.dart`, yang berisi definisi
/// `Provider`/`FutureProvider`/`NotifierProvider`/dsb sesungguhnya — mesin
/// yang persis sama dari Lab 01-08, cuma di-generate alih-alih ditulis
/// tangan.
///
/// Jalankan ini sambil kamu mengedit:
///   dart run build_runner watch -d
/// (-d menghapus hasil yang konflik secara otomatis; pakai `build`
/// alih-alih `watch` untuk sekali jalan saja.)
/// Provider berbasis FUNGSI. `@riverpod` pada fungsi top-level yang
/// mengembalikan `T` menghasilkan setara `Provider<T>` — di sini, karena
/// tidak ada parameter tambahan selain `ref`, jadi yang biasa (bukan
/// family).
///
/// DEFAULT PENTING: provider hasil generate itu `autoDispose` SECARA
/// DEFAULT — kebalikan dari default API manual yang kamu pakai di
/// Lab 01-08! Ini `riverpod_generator` mengarahkanmu ke pilihan yang
/// lebih aman (Lab 08).

final class GreetingProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// LAB 09 — RIVERPOD CODE GENERATION
  ///
  /// Semua isi file ini adalah fungsi atau class Dart BIASA yang diberi
  /// anotasi `@riverpod`. `build_runner` membaca anotasi ini dan menulis
  /// `providers.g.dart`, yang berisi definisi
  /// `Provider`/`FutureProvider`/`NotifierProvider`/dsb sesungguhnya — mesin
  /// yang persis sama dari Lab 01-08, cuma di-generate alih-alih ditulis
  /// tangan.
  ///
  /// Jalankan ini sambil kamu mengedit:
  ///   dart run build_runner watch -d
  /// (-d menghapus hasil yang konflik secara otomatis; pakai `build`
  /// alih-alih `watch` untuk sekali jalan saja.)
  /// Provider berbasis FUNGSI. `@riverpod` pada fungsi top-level yang
  /// mengembalikan `T` menghasilkan setara `Provider<T>` — di sini, karena
  /// tidak ada parameter tambahan selain `ref`, jadi yang biasa (bukan
  /// family).
  ///
  /// DEFAULT PENTING: provider hasil generate itu `autoDispose` SECARA
  /// DEFAULT — kebalikan dari default API manual yang kamu pakai di
  /// Lab 01-08! Ini `riverpod_generator` mengarahkanmu ke pilihan yang
  /// lebih aman (Lab 08).
  GreetingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'greetingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$greetingHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return greeting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$greetingHash() => r'61b47ab82cb8ae2edea3b35643a488f8656c19c2';

/// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
/// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
/// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
/// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
/// `FutureProvider.autoDispose.family<List<String>, String>`.

@ProviderFor(searchWords)
final searchWordsProvider = SearchWordsFamily._();

/// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
/// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
/// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
/// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
/// `FutureProvider.autoDispose.family<List<String>, String>`.

final class SearchWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
  /// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
  /// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
  /// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
  /// `FutureProvider.autoDispose.family<List<String>, String>`.
  SearchWordsProvider._({
    required SearchWordsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchWordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchWordsHash();

  @override
  String toString() {
    return r'searchWordsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return searchWords(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchWordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchWordsHash() => r'da6b071424ec90a862d20226e5f9ebdb5837efc7';

/// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
/// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
/// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
/// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
/// `FutureProvider.autoDispose.family<List<String>, String>`.

final class SearchWordsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  SearchWordsFamily._()
    : super(
        retry: null,
        name: r'searchWordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fungsi dengan parameter TAMBAHAN (selain `ref`) otomatis menjadi
  /// provider FAMILY — tanpa perlu sintaks `.family`, dan tidak seperti
  /// API manual, kamu bisa punya parameter banyak, bernama, atau opsional.
  /// Ini setara hasil generate dari gabungan Lab 06 + Lab 08:
  /// `FutureProvider.autoDispose.family<List<String>, String>`.

  SearchWordsProvider call(String query) =>
      SearchWordsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchWordsProvider';
}

/// Provider berbasis CLASS: `@riverpod` pada sebuah class yang meng-extend
/// mixin `_$ClassName` hasil generate menghasilkan setara `NotifierProvider`
/// (lab ini) — bentuk yang persis sama juga berlaku untuk `AsyncNotifier`,
/// cukup buat `build()` mengembalikan `Future<T>`.
///
/// `@Riverpod(keepAlive: true)` KELUAR dari default autoDispose — pakai
/// ini dengan sengaja, untuk state yang memang seharusnya bertahan
/// setelah layarnya ditutup (bandingkan dengan `ref.keepAlive()` di
/// Lab 08, yang melakukan hal sama tapi sementara/bersyarat dari dalam
/// isi provider).

@ProviderFor(Counter)
final counterProvider = CounterProvider._();

/// Provider berbasis CLASS: `@riverpod` pada sebuah class yang meng-extend
/// mixin `_$ClassName` hasil generate menghasilkan setara `NotifierProvider`
/// (lab ini) — bentuk yang persis sama juga berlaku untuk `AsyncNotifier`,
/// cukup buat `build()` mengembalikan `Future<T>`.
///
/// `@Riverpod(keepAlive: true)` KELUAR dari default autoDispose — pakai
/// ini dengan sengaja, untuk state yang memang seharusnya bertahan
/// setelah layarnya ditutup (bandingkan dengan `ref.keepAlive()` di
/// Lab 08, yang melakukan hal sama tapi sementara/bersyarat dari dalam
/// isi provider).
final class CounterProvider extends $NotifierProvider<Counter, int> {
  /// Provider berbasis CLASS: `@riverpod` pada sebuah class yang meng-extend
  /// mixin `_$ClassName` hasil generate menghasilkan setara `NotifierProvider`
  /// (lab ini) — bentuk yang persis sama juga berlaku untuk `AsyncNotifier`,
  /// cukup buat `build()` mengembalikan `Future<T>`.
  ///
  /// `@Riverpod(keepAlive: true)` KELUAR dari default autoDispose — pakai
  /// ini dengan sengaja, untuk state yang memang seharusnya bertahan
  /// setelah layarnya ditutup (bandingkan dengan `ref.keepAlive()` di
  /// Lab 08, yang melakukan hal sama tapi sementara/bersyarat dari dalam
  /// isi provider).
  CounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'counterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  @$internal
  @override
  Counter create() => Counter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$counterHash() => r'82ef752e987820d2bc7fa9b338620014979388a9';

/// Provider berbasis CLASS: `@riverpod` pada sebuah class yang meng-extend
/// mixin `_$ClassName` hasil generate menghasilkan setara `NotifierProvider`
/// (lab ini) — bentuk yang persis sama juga berlaku untuk `AsyncNotifier`,
/// cukup buat `build()` mengembalikan `Future<T>`.
///
/// `@Riverpod(keepAlive: true)` KELUAR dari default autoDispose — pakai
/// ini dengan sengaja, untuk state yang memang seharusnya bertahan
/// setelah layarnya ditutup (bandingkan dengan `ref.keepAlive()` di
/// Lab 08, yang melakukan hal sama tapi sementara/bersyarat dari dalam
/// isi provider).

abstract class _$Counter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
