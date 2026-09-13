class SearchRepository {
  static const _words = [
    'provider', 'consumer', 'notifier', 'family', 'autoDispose', 'keepAlive',
    'future', 'stream', 'riverpod', 'widget', 'state', 'ref', 'watch', 'read',
    'listen', 'select', 'async', 'generator', 'codegen', 'testing',
  ];

  Future<List<String>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return const [];
    return _words.where((w) => w.contains(query.toLowerCase())).toList();
  }
}
