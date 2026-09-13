class Product {
  const Product({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;
}

const catalog = [
  Product(id: 'p1', name: 'Coffee Beans 250g', price: 8.5),
  Product(id: 'p2', name: 'Ceramic Mug', price: 6.0),
  Product(id: 'p3', name: 'Pour-over Dripper', price: 14.0),
  Product(id: 'p4', name: 'Filter Papers (100)', price: 3.5),
];
