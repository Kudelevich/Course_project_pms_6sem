import 'package:flutter/material.dart';

class GoodPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const GoodPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data['imageURL']), // Поле 'imageURL' содержит ссылку на изображение
            const SizedBox(height: 16.0),
            Text('Amount: ${data['amount']}'),
            Text('Price: ${data['price']}'),
            const SizedBox(height: 16.0),
            const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(data['description']),
          ],
        ),
      ),
    );
  }
}