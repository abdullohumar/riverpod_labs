import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

/// LAB 05 — FAMILY PROVIDERS (starter)
///
/// Ikuti TODO bernomor. Penjelasan lengkap ada di ../README.md.

// TODO(1): Deklarasikan `productProvider`, sebuah
// `Provider.family<Product, String>` yang mencari produk berdasarkan id
// di `catalog` (`catalog.firstWhere((p) => p.id == id)`).

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

// TODO(2): Deklarasikan `cartQuantityProvider`, sebuah
// `NotifierProvider.family<CartQuantityNotifier, int, String>` yang
// dibangun dari `CartQuantityNotifier.new`.

// TODO(3): Deklarasikan `cartTotalProvider`, sebuah `Provider<double>`
// yang mengulang setiap `product` di `catalog`, meng-watch
// `cartQuantityProvider(product.id)` untuk masing-masing, dan
// menjumlahkan `quantity * product.price`.
