import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repository/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) => SearchRepository());

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, query) async {
  final repository = ref.watch(searchRepositoryProvider);
  final results = await repository.search(query);

  if (results.isNotEmpty) {
    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 30), link.close);
    ref.onDispose(timer.cancel);
  }

  return results;
});
