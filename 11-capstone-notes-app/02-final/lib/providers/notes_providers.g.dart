// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// CAPSTONE — semua dari Lab 01-10, digabungkan:
///  - Lab 09 (codegen)     -> @riverpod / @Riverpod(keepAlive: true)
///  - Lab 06 (async)       -> `build()` berbentuk AsyncNotifier yang mengembalikan Future
///  - Lab 03 (Notifier)    -> method bernama (add/delete/togglePin), update immutable
///  - Lab 04 (computed)    -> `filteredNotesProvider` diturunkan dari dua provider
///  - persistence          -> NotesRepository dibungkus SharedPreferences
///  - Lab 10 (testing)     -> lihat test/notes_notifier_test.dart
/// Sengaja dibuat keepAlive: notes tidak seharusnya hilang cuma karena
/// layar notes sempat tidak terlihat sebentar (bandingkan dengan
/// keputusan autoDispose di Lab 08 — ini keputusan sebaliknya, dibuat
/// dengan sengaja).

@ProviderFor(notesRepository)
final notesRepositoryProvider = NotesRepositoryProvider._();

/// CAPSTONE — semua dari Lab 01-10, digabungkan:
///  - Lab 09 (codegen)     -> @riverpod / @Riverpod(keepAlive: true)
///  - Lab 06 (async)       -> `build()` berbentuk AsyncNotifier yang mengembalikan Future
///  - Lab 03 (Notifier)    -> method bernama (add/delete/togglePin), update immutable
///  - Lab 04 (computed)    -> `filteredNotesProvider` diturunkan dari dua provider
///  - persistence          -> NotesRepository dibungkus SharedPreferences
///  - Lab 10 (testing)     -> lihat test/notes_notifier_test.dart
/// Sengaja dibuat keepAlive: notes tidak seharusnya hilang cuma karena
/// layar notes sempat tidak terlihat sebentar (bandingkan dengan
/// keputusan autoDispose di Lab 08 — ini keputusan sebaliknya, dibuat
/// dengan sengaja).

final class NotesRepositoryProvider
    extends
        $FunctionalProvider<NotesRepository, NotesRepository, NotesRepository>
    with $Provider<NotesRepository> {
  /// CAPSTONE — semua dari Lab 01-10, digabungkan:
  ///  - Lab 09 (codegen)     -> @riverpod / @Riverpod(keepAlive: true)
  ///  - Lab 06 (async)       -> `build()` berbentuk AsyncNotifier yang mengembalikan Future
  ///  - Lab 03 (Notifier)    -> method bernama (add/delete/togglePin), update immutable
  ///  - Lab 04 (computed)    -> `filteredNotesProvider` diturunkan dari dua provider
  ///  - persistence          -> NotesRepository dibungkus SharedPreferences
  ///  - Lab 10 (testing)     -> lihat test/notes_notifier_test.dart
  /// Sengaja dibuat keepAlive: notes tidak seharusnya hilang cuma karena
  /// layar notes sempat tidak terlihat sebentar (bandingkan dengan
  /// keputusan autoDispose di Lab 08 — ini keputusan sebaliknya, dibuat
  /// dengan sengaja).
  NotesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesRepository create(Ref ref) {
    return notesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesRepository>(value),
    );
  }
}

String _$notesRepositoryHash() => r'd17433e33560ab2e8acb923aca49b5845ac8143b';

@ProviderFor(NotesNotifier)
final notesProvider = NotesNotifierProvider._();

final class NotesNotifierProvider
    extends $AsyncNotifierProvider<NotesNotifier, List<Note>> {
  NotesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesNotifierHash();

  @$internal
  @override
  NotesNotifier create() => NotesNotifier();
}

String _$notesNotifierHash() => r'8c1cba0311e299b545f2432cc5b21434bdfa6806';

abstract class _$NotesNotifier extends $AsyncNotifier<List<Note>> {
  FutureOr<List<Note>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Note>>, List<Note>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Note>>, List<Note>>,
              AsyncValue<List<Note>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider turunan yang menggabungkan `notesProvider` (async) dengan
/// `searchQueryProvider` (sync). Perhatikan tipe kembaliannya adalah
/// `AsyncValue<List<Note>>`, bukan `List<Note>` — `AsyncValue.whenData`
/// memungkinkan kita mentransformasi kondisi DATA sambil meneruskan
/// kondisi loading dan error apa adanya, jadi UI bisa tetap memakai satu
/// `.when(...)` saja pada provider ini alih-alih menyulap dua AsyncValue.

@ProviderFor(filteredNotes)
final filteredNotesProvider = FilteredNotesProvider._();

/// Provider turunan yang menggabungkan `notesProvider` (async) dengan
/// `searchQueryProvider` (sync). Perhatikan tipe kembaliannya adalah
/// `AsyncValue<List<Note>>`, bukan `List<Note>` — `AsyncValue.whenData`
/// memungkinkan kita mentransformasi kondisi DATA sambil meneruskan
/// kondisi loading dan error apa adanya, jadi UI bisa tetap memakai satu
/// `.when(...)` saja pada provider ini alih-alih menyulap dua AsyncValue.

final class FilteredNotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          AsyncValue<List<Note>>,
          AsyncValue<List<Note>>
        >
    with $Provider<AsyncValue<List<Note>>> {
  /// Provider turunan yang menggabungkan `notesProvider` (async) dengan
  /// `searchQueryProvider` (sync). Perhatikan tipe kembaliannya adalah
  /// `AsyncValue<List<Note>>`, bukan `List<Note>` — `AsyncValue.whenData`
  /// memungkinkan kita mentransformasi kondisi DATA sambil meneruskan
  /// kondisi loading dan error apa adanya, jadi UI bisa tetap memakai satu
  /// `.when(...)` saja pada provider ini alih-alih menyulap dua AsyncValue.
  FilteredNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredNotesHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Note>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Note>> create(Ref ref) {
    return filteredNotes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Note>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Note>>>(value),
    );
  }
}

String _$filteredNotesHash() => r'07a826ead24787bae587cace98a9883e5aba0c91';
