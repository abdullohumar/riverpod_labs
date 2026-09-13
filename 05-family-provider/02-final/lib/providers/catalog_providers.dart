import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

/// LAB 05 — FAMILY PROVIDERS
///
/// `.family` mengubah sebuah provider menjadi FUNGSI yang mengembalikan
/// provider untuk argumen tertentu. Setiap argumen yang berbeda mendapat
/// instance-nya SENDIRI, independen, dan ter-cache — `productProvider('p1')`
/// dan `productProvider('p2')` adalah dua provider yang benar-benar
/// terpisah di baliknya, masing-masing punya entry cache dan lifecycle
/// sendiri.
///
/// Pakai `.family` setiap kali "data/state yang aku butuhkan bergantung
/// pada id/key yang ditentukan saat runtime" — misalnya "user dengan id
/// ini," "hasil pencarian untuk query ini" (Lab 06), "jumlah di keranjang
/// untuk produk ini."

/// Family read-only: diberi id produk, cari di katalog. Nilainya tidak
/// pernah berubah setelah dihitung, jadi `Provider.family` biasa adalah
/// alat yang tepat (bandingkan dengan `Provider` biasa di Lab 01).
final productProvider = Provider.family<Product, String>((ref, id) {
  return catalog.firstWhere((p) => p.id == id);
});

/// Family yang STATEFUL: setiap id produk mendapat counter independennya
/// sendiri. Perhatikan class notifier-nya menerima argumen family sebagai
/// parameter constructor — sudah tidak ada lagi base class khusus "family
/// notifier", ini cuma `Notifier` biasa yang kebetulan dibuat dengan
/// sebuah argumen.
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

/// Provider biasa (bukan family) yang mengagregasi SEMUA instance family
/// untuk id katalog yang sudah diketahui. Ini pola "provider turunan"
/// yang sama dari Lab 04 — cuma kebetulan sebagian dependency-nya adalah
/// family provider yang dipanggil dengan argumen tertentu.
final cartTotalProvider = Provider<double>((ref) {
  var total = 0.0;
  for (final product in catalog) {
    final quantity = ref.watch(cartQuantityProvider(product.id));
    total += quantity * product.price;
  }
  return total;
});
