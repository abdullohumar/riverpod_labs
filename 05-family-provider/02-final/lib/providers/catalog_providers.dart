import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

final productProvider = Provider.family<Product, String>((ref, id) {
  return catalog.firstWhere((p) => p.id == id);
});

class CartQuantityNotifier extends Notifier<int> {
  CartQuantityNotifier(this.productId);

  final String productId;

  @override
  int build() => 0;

  void increment() => state++;

  void decrement() {
    if (state > 0) state--;
  }
}

final cartQuantityProvider = NotifierProvider.family<CartQuantityNotifier, int, String>(
  CartQuantityNotifier.new,
);

final cartTotalProvider = Provider<double>((ref) {
  var total = 0.0;
  for (final product in catalog) {
    final quantity = ref.watch(cartQuantityProvider(product.id));
    total += quantity * product.price;
  }
  return total;
});
