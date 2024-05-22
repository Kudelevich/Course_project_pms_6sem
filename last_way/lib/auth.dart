

import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaswAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaswAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaswAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async{
    await _firebaswAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );
  }

  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  })async{
    await _firebaswAuth.createUserWithEmailAndPassword(
      //name: name,
      email: email, 
      password: password,
      );
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}

