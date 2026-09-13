import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/product.dart';
import 'providers/catalog_providers.dart';

/// LAB 05 — FAMILY PROVIDERS
///
/// Lihat providers/catalog_providers.dart untuk konsep intinya. File ini
/// menunjukkan cara family provider DIBACA dari sebuah widget: kamu
/// memanggilnya dengan sebuah argumen,
/// `ref.watch(cartQuantityProvider(product.id))`, dan mendapat kembali
/// provider biasa yang khusus untuk argumen itu.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Providers',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown)),
      home: const CatalogPage(),
    );
  }
}

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Coffee Shop')),
      body: ListView.builder(
        itemCount: catalog.length,
        itemBuilder: (context, index) => _ProductTile(productId: catalog[index].id),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget ini hanya butuh `id` sebuah produk — dia mengambil semua yang
/// lain (produknya sendiri, dan jumlah di keranjangnya) lewat family
/// provider yang diparameterisasi dengan id itu. Ini membuat parent-nya
/// (`CatalogPage`) tidak perlu meneruskan objek utuh ke bawah, dan
/// artinya tiap tile hanya rebuild saat produk/jumlahnya SENDIRI berubah,
/// bukan saat milik sibling-nya berubah.
class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memanggil family provider dengan sebuah argumen mengembalikan
    // provider biasa — watch/read seperti provider lain pada umumnya.
    final product = ref.watch(productProvider(productId));
    final quantity = ref.watch(cartQuantityProvider(productId));
    final notifier = ref.read(cartQuantityProvider(productId).notifier);

    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: notifier.decrement),
          Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: notifier.increment),
        ],
      ),
    );
  }
}
