import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/product.dart';
import 'providers/catalog_providers.dart';

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

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
