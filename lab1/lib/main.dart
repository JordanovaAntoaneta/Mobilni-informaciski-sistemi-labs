import 'package:flutter/material.dart';

void main() => runApp(const ClothesApp());

class ClothesApp extends StatelessWidget {
  const ClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '211081',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ClothesList(),
    );
  }
}

class ClothesList extends StatelessWidget {
  final List<Map<String, dynamic>> clothes = [
    {
      'name': 'Блуза',
      'image': 'https://static.sinsay.com/media/catalog/product/7/0/7025F-99X-001-1-846306.jpg',
      'description': 'Црна ролка без ракави',
      'price': 299,
    },
    {
      'name': 'Здолниште-панталони',
      'image': 'https://static.sinsay.com/media/catalog/product/Y/Q/YQ106-09P-002-1-845359.jpg',
      'description': 'Сиви шорцеви од вискоза и еластин',
      'price': 499,
    },
    {
      'name': 'Миди фустан',
      'image': 'https://static.sinsay.com/media/catalog/product/cache/1200/a4e40ebdc3e371adff845072e1c73f37/5/8/581CE-59X-005-1-898223_1.jpg',
      'description': 'Тесен миди фустан во сина боја со ¾ ракави',
      'price': 599,
    },
    {
      'name': 'Палто',
      'image': 'https://static.sinsay.com/media/catalog/product/6/9/692AS-09M-010-1-919096_2.jpg',
      'description': 'Волнено сиво палто на риги со двојно закопчување',
      'price': 1199,
    },
    {
      'name': 'Џемпер',
      'image': 'https://static.sinsay.com/media/catalog/product/0/1/013AU-65X-009-1-861613.jpg',
      'description': 'Волнен џемпер со плави риги',
      'price': 799,
    },
    {
      'name': 'Панталони',
      'image': 'https://static.sinsay.com/media/catalog/product/9/2/926AW-09M-001-1-909564_2.jpg',
      'description': 'Зимски панталони со широка ногавица',
      'price': 799,
    },
    {
      'name': 'Фармерки',
      'image': 'https://static.sinsay.com/media/catalog/product/7/2/7223F-59J-010-1-854473_1.jpg',
      'description': 'Светло сини фармерки со мом-џинс крој',
      'price': 599,
    },
    {
      'name': 'Костим за капење',
      'image': 'https://static.sinsay.com/media/catalog/product/1/2/120EP-70X-008-1-912210.jpg',
      'description': 'Зелен костим за капење со карнери',
      'price': 799,
    },
  ];

  ClothesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('211081'),
        backgroundColor: Colors.brown,
        titleTextStyle: const TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.5,
          fontFamily: 'Copperplate',
        ),
      ),
      body: ListView.builder(
        itemCount: clothes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    product: clothes[index],
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Image.network(
                      clothes[index]['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      clothes[index]['name'],
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${clothes[index]['price']} денари'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name']), backgroundColor: Colors.brown),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product['image']),
            const SizedBox(height: 16),
            Text(
              product['name'],
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(product['description']),
            const SizedBox(height: 16),
            Text('Цена: ${product['price']} денари',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green)
            ),
          ],
        ),
      ),
    );
  }
}
