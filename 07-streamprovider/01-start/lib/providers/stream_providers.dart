import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LAB 07 — STREAMPROVIDER & STREAMNOTIFIER (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.

// TODO(1): Deklarasikan `clockProvider`, sebuah `StreamProvider<DateTime>`
// yang mengembalikan
// `Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now())`.

class TickerNotifier extends StreamNotifier<int> {
  final _controller = StreamController<int>.broadcast();
  Timer? _timer;
  int _count = 0;
  bool _paused = false;

  @override
  Stream<int> build() {
    // TODO(2): Mulai sebuah `Timer.periodic` (tiap detik) yang, kalau
    // tidak sedang paused, menambah `_count` dan menambahkannya ke
    // `_controller`.
    //
    // TODO(3): Daftarkan cleanup dengan `ref.onDispose(() { ... })` yang
    // membatalkan timer dan menutup controller. Lakukan ini SEBELUM
    // return di bawah — gampang terlupa begitu stream-nya sudah
    // dikembalikan.
    //
    // TODO(4): Kembalikan `_controller.stream`.
    throw UnimplementedError();
  }

  void pause() => _paused = true;

  void resume() => _paused = false;

  void reset() {
    _count = 0;
    _controller.add(_count);
  }
}

// TODO(5): Deklarasikan `tickerProvider`, sebuah
// `StreamNotifierProvider<TickerNotifier, int>` dibangun dari
// `TickerNotifier.new`.
