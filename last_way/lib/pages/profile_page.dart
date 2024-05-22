import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_way/auth.dart';
import 'package:last_way/pages/login.dart';
import 'good_model.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final bool isAdmin;
  final Auth auth;

  const ProfilePage({super.key, 
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.auth,
  });

  void _logout(BuildContext context) async {
    await auth.signOut(); // Вызов метода signOut() из класса Auth

    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8),
             Text(
              'Name: $name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
           
            const SizedBox(height: 16),
            if (isAdmin) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductPage()),
                  );
                },
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Product Form:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const AddProductForm(),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      )
       ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  void _addProduct() {
    final String title = _titleController.text;
    final double price = double.parse(_priceController.text);
    final int amount = int.parse(_amountController.text);
    final String imageURL = _imageURLController.text;
    final String description = _descriptionController.text;

      GoodModel good = GoodModel(
      description: _descriptionController.text,
      imageURL: _imageURLController.text,
      title: _titleController.text,
      amount:_amountController.text,
      price: _priceController.text,
        );


    // Saving product data to Firestore collection "goods"
    // FirebaseFirestore.instance.collection('goods').add({
    //   'title': title,
    //   'price': price,
    //   'amount': amount,
    //   'imageURL': imageURL,
    //   'description': description,
    // });
     _databaseService.addGood(good);

    // Clearing the text fields after adding the product
    _titleController.clear();
    _priceController.clear();
    _amountController.clear();
    _imageURLController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _imageURLController,
          decoration: const InputDecoration(labelText: 'Image URL'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addProduct,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddProductForm(),
      ),
    );
  }
}