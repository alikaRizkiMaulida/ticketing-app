// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  final String productName;
  final String type;
  final int price;
  int quantity;

  ProductModel({
    required this.productName,
    required this.type,
    required this.price,
    this.quantity = 1,
  });
}

final products = [
    ProductModel(
      productName: 'JonggolLand',
      type: 'Waterboom',
      price: 50000,
    ),
    ProductModel(
      productName: 'Bamboozle',
      type: 'Sushi',
      price: 40000,
    ),
    ProductModel(
      productName: 'Taro',
      type: 'Sashimi',
      price: 30000,
    ),
  ];