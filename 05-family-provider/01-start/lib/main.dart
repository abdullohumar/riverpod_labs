import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/product.dart';
import 'providers/catalog_providers.dart';

/// LAB 05 — FAMILY PROVIDERS (starter)
///
/// Mulai dari providers/catalog_providers.dart (TODO 1-3), baru kembali
/// ke sini untuk TODO 4-6.

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
    // TODO(4): Watch cartTotalProvider ke dalam `total`.
    const total = 0.0;

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

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(5): Watch `productProvider(productId)` ke dalam `product`, dan
    // `cartQuantityProvider(productId)` ke dalam `quantity`.
    // TODO(6): Read `cartQuantityProvider(productId).notifier` ke dalam
    // `notifier` supaya tombol di bawah bisa memanggil
    // `.increment()`/`.decrement()`.
    const product = Product(id: '', name: 'TODO', price: 0);
    const quantity = 0;

    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {}),
          Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
        ],
      ),
    );
  }
}
