import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_way/auth.dart';
import 'package:flutter/material.dart';
import 'package:last_way/pages/good_model.dart';
import 'package:last_way/pages/login.dart';
import 'package:last_way/pages/profile_page.dart';
import 'package:last_way/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String userEmail = '';
  bool isAdmin = false;
  String userName = '';

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userEmail = await getCurrentUserEmail();
    isAdmin = await getCurrentUserAdminStatus();
    userName = await getCurrentUsername();
  }
  
  Future<String> getCurrentUserEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }
  return '';
}
  Future<bool> getCurrentUserAdminStatus() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      String role = userData['role'];
      return role == 'admin';
    }
  }
  return false;
}
  
  Future<String> getCurrentUsername() async {  

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      String name = userData['name'];
      return name;
    }


  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? '';
  }
  return '';
}

  @override
Widget build(BuildContext context) {


  List<Widget> _pages = <Widget>[
    ProductsPage(isAdmin: isAdmin, isGuest: false,),
    CartPage(),
    ProfilePage(email: userEmail, isAdmin: isAdmin, name: userName, auth: Auth()), 
  ];

  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Профиль'),
  ];

  List<Widget> _pagesAdm = <Widget>[
    ProductsPage(isAdmin: isAdmin, isGuest: false),
    ProfilePage(email: userEmail, isAdmin: isAdmin, name: userName, auth: Auth()), 
  ];

  List<BottomNavigationBarItem> _itemsAdm = [
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Профиль'),
  ];

  
  if (isAdmin == true) {
    return Scaffold(
    body: _pagesAdm.elementAt(_currentIndex),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: _itemsAdm,
    ),
  );
  } else{
  return Scaffold(
    body: _pages.elementAt(_currentIndex),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: _items,
    ),
  );
  }

}

}


class GuestPage extends StatefulWidget {
  const GuestPage({Key? key}) : super(key: key);

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if(_currentIndex == 1){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }


  @override
Widget build(BuildContext context) {
  List<Widget> _pagesG = <Widget>[
    ProductsPage(isAdmin: false, isGuest: true,),
    SizedBox.shrink(),
  ];

  List<BottomNavigationBarItem> _itemsG = [
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Войти'),
  ];

    return Scaffold(
    body: _pagesG.elementAt(_currentIndex),
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: _itemsG,
    ),
  );
  }

}





class ProductsPage extends StatefulWidget {
  bool isAdmin;
  bool isGuest;
  ProductsPage({required this.isAdmin, required this.isGuest});

  @override
  _ProductsPageState createState() => _ProductsPageState(isAdmin: isAdmin, isGuest: isGuest);
}


class _ProductsPageState extends State<ProductsPage> {
  
  final DatabaseService _databaseService = DatabaseService();
   bool isAdmin;
   bool isGuest;
  _ProductsPageState({required this.isAdmin, required this.isGuest});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Товары'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('goods').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

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
                            data['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('Amount: ${data['amount']}, Price: ${data['price']}'),
                          SizedBox(height: 8.0),
                          Text(data['description']),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Image.network(data['imageURL'], width: 80, height: 80, fit: BoxFit.cover),
                    SizedBox(width: 16.0),

                    if(isAdmin == true)...[
                      IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        _databaseService.deleteGood(document.id);
                    
                      },
                    ),
                    ]else
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () async {

                        if(isGuest == true){
                          Navigator.pushAndRemoveUntil(
                            context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                        }else await _databaseService.addGoodCart(document.id);
                        
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

  Future<String> getCurrentUserId() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
  return '';
}

  void addToCart(Map<String, dynamic> product) async {
  String userId = await getCurrentUserId();

  if (userId.isNotEmpty) {
    CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');

    await cartCollection.add({
      'uid': userId,
      'gid': product['gid'],
    });
  }
}
}