import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_way/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassord = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassord.text,
        );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
        name: _controllerName.text,
        email: _controllerEmail.text,
        password: _controllerPassord.text,
        );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return const Text('Firebase auth');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    ) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title
        ),
      );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword, 
      child:  Text(isLogin ? 'Login':'Register'),
      );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed: (){
        setState(() {
          isLogin= !isLogin;
        });
      }, 
      child: Text(isLogin ? 'Register insted':'Login insted'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body:Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('name', _controllerName),
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassord),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      )
    );
  }
}