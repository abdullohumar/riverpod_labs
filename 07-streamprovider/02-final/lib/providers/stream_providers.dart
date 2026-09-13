import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

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

    ref.onDispose(() {
      _timer?.cancel();
      _controller.close();
    });

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
