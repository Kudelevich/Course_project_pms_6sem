import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'good_model.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User? user = FirebaseAuth.instance.currentUser;

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
          title: Text("Корзина"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _databaseService.getGoodsCart(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text("Корзина пустая("),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text("Корзина пустая"),
              ),
            );
          }
          
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot good = snapshot.data!.docs[index];
          //GoodModel good = GoodModel.fromMap(documentSnapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  good['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text('Amount: ${good['amount']}, Price: ${good['price']}'), // Исправлено здесь
                SizedBox(height: 8.0),
                Text(good['description']), // И здесь
              ],
            ),
          ),
          SizedBox(width: 16.0),
          Image.network(good['imageURL'], width: 80, height: 80, fit: BoxFit.cover),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.shopping_cart_checkout),
            onPressed: () {
              _databaseService.deleteGoodCart(good.id);
              setState(() {});
            },
          ),
        ],
      ),
    );
  },
);
},
      ),
    );
  }
}
