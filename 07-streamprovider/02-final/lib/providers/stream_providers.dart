import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LAB 07 — STREAMPROVIDER & STREAMNOTIFIER
///
/// `StreamProvider<T>` adalah "saudara" `FutureProvider` untuk data
/// BERKELANJUTAN: alih-alih selesai sekali, dia menyediakan setiap nilai
/// yang dipancarkan sebuah Stream, tetap dibungkus dalam `AsyncValue<T>`
/// (loading sampai event pertama, lalu data di setiap event berikutnya,
/// atau error kalau stream-nya error).

/// StreamProvider paling sederhana yang mungkin: memancarkan ulang waktu
/// saat ini setiap detik. Tanpa family, tanpa side effect, cuma "watch
/// stream ini."
final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

/// `StreamNotifier<T>` bagi `StreamProvider` adalah seperti `Notifier`
/// bagi `StateProvider`: pakai ini kalau kamu butuh method di samping
/// stream-nya (di sini: pause/resume/reset), bukan cuma stream tanpa cara
/// mengontrolnya.
///
/// Perhatikan bentuknya: `build()` mengembalikan `Stream<T>` (seperti
/// callback milik `StreamProvider`), tapi karena ini class, `ref`
/// tersedia sebagai `this.ref` di setiap method — tidak perlu diteruskan
/// lewat parameter.
class TickerNotifier extends StreamNotifier<int> {
  final _controller = StreamController<int>.broadcast();
  Timer? _timer;
  int _count = 0;
  bool _paused = false;

  @override
  Stream<int> build() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_paused) {
        _count++;
        _controller.add(_count);
      }
    });

    // Cleanup berjalan saat provider di-dispose (ProviderScope
    // dibongkar, atau — dengan autoDispose, Lab 08 — saat sudah tidak
    // ada yang meng-watch-nya lagi). Lupa melakukan ini adalah sumber
    // klasik Timer yang bocor.
    ref.onDispose(() {
      _timer?.cancel();
      _controller.close();
    });

    // Pancarkan hitungan saat ini segera supaya listener yang terlambat
    // tidak perlu menunggu satu detik penuh untuk nilai pertamanya.
    return _controller.stream;
  }

  void pause() => _paused = true;

  void resume() => _paused = false;

  void reset() {
    _count = 0;
    _controller.add(_count);
  }
}

final tickerProvider = StreamNotifierProvider<TickerNotifier, int>(TickerNotifier.new);
