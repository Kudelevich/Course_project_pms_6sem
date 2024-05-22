
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoodModel{
  //String? gid;
  String? description;
  String? imageURL;
  String? title;
  String? amount;
  String? price;

  GoodModel({required this.description,required  this.imageURL,required this.title,  required this.amount,required  this.price,});

  factory GoodModel.fromMap(map) {
    return GoodModel(
      //gid: map['gid'],
      description: map['description'],
      imageURL: map['imageURL'],
      amount: map['amount'],
      title: map['title'],
      price: map['price'],
          );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      //'gid': gid,
      'description': description,
      'imageURL': imageURL,
      'title': title,
      'amount': amount,
      'price': price,
    };
  }
}

class CartModel{
  String? uid;
  String? gid;

  // receiving data
  CartModel({ this.uid, this.gid});

  factory CartModel.fromMap(map) {
    return CartModel(
      uid: map['uid'],
      gid: map['gid'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'gid': gid,
    };
  }
}
const String GOODS_COLLECTION_REF = "goods";
const String CART_COLLECTION_REF = "cart";

class DatabaseService{
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _goodRef;
  late final CollectionReference _cartRef;

  DatabaseService(){
    _goodRef = _firestore.collection(GOODS_COLLECTION_REF).withConverter<GoodModel>(
        fromFirestore: (snapshots, _)=> GoodModel.fromMap(snapshots.data()!,),
        toFirestore: (good, _) => good.toMap()
    );

    _cartRef = _firestore.collection(CART_COLLECTION_REF).withConverter<CartModel>(
        fromFirestore: (snapshots, _)=> CartModel.fromMap(snapshots.data()!,),
        toFirestore: (good, _) => good.toMap()
    );

  }


   void addGood(GoodModel good) async{
    _goodRef.add(good);
  }

  Future<List<String>> getCartGoodIds() async {
    final querySnapshot = await _cartRef.where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    return querySnapshot.docs.map((doc) => doc['gid'].toString()).toList();
  }

  Future<void> updateGood(String goodId, Map<String, dynamic> updates) async {
    await _goodRef.doc(goodId).update(updates);
  }

  void deleteGood(String goodId) async{
    final querySnapshot = await _cartRef.where('gid', isEqualTo: goodId).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    _goodRef.doc(goodId).delete();
  }


  Stream<QuerySnapshot> getGoodsCart() async* {
    final cartGoodIds = await getCartGoodIds();
    yield* _goodRef.where(FieldPath.documentId, whereIn: cartGoodIds).snapshots();
  }

  Future<void> addGoodCart(String goodId) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    QuerySnapshot querySnapshot = await _cartRef
        .where('uid', isEqualTo: uid)
        .where('gid', isEqualTo: goodId)
        .get();

   
      CartModel post = CartModel(
        uid: uid,
        gid: goodId,
      );

      await _cartRef.add(post);
    
  }

  void deleteGoodCart(String gid) async {
    final querySnapshot = await _cartRef.where('gid', isEqualTo: gid).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

}
