import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
String greeting(Ref ref) => 'Hello from a generated provider';

@riverpod
Future<List<String>> searchWords(Ref ref, String query) async {
  const words = [
    'provider', 'consumer', 'notifier', 'family', 'autoDispose', 'keepAlive',
    'future', 'stream', 'riverpod', 'widget', 'state', 'generator', 'codegen',
  ];
  await Future.delayed(const Duration(milliseconds: 400));
  if (query.isEmpty) return const [];
  return words.where((w) => w.contains(query.toLowerCase())).toList();
}

@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;

  void decrement() => state--;
}
