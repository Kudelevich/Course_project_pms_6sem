import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_way/auth.dart';
import 'package:flutter/material.dart';
import 'package:last_way/pages/home_page.dart';
import 'package:last_way/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _obscureText = true;
  String? errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        name: _controllerName.text,
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
       // Получите текущего пользователя из Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Добавьте информацию о пользователе в коллекцию "users"
    await _firestore.collection('users').doc(user!.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': _controllerName.text,
      'role': 'client', // Установите роль по умолчанию или добавьте логику для выбора роли
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
        );

    // Дополнительный код после успешной регистрации
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

 Widget _entryFieldPass(String title, TextEditingController controller) {
  return TextField(
    obscureText: _obscureText,
    controller: controller,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: title,
      labelStyle: TextStyle(color: Colors.white),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _obscureText =!_obscureText;
          });
        },
      ), 
    ),
  );
}



  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: createUserWithEmailAndPassword,
      child: const Text('Register'),
    );
  }

  Widget _loginInsteadButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text('Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: CustomPaint(
        painter: BackgroundSingIn(),
        child:Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('name', _controllerName),
            _entryField('email', _controllerEmail),
            _entryFieldPass('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginInsteadButton(),
          ],
        ),
      ),
      ),
    );
  }
}

class BackgroundSingIn extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = const Color.fromARGB(255, 144, 207, 241);
    canvas.drawPath(mainBackground, paint);

    // Blue
    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.5, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = const Color.fromARGB(255, 101, 164, 197);
    canvas.drawPath(blueWave, paint);

    // Grey
    Path greyPath = Path();
    greyPath.lineTo(sw, 0);
    greyPath.lineTo(sw, sh * 0.3);
    greyPath.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyPath.close();
    paint.color = const Color.fromARGB(255, 78, 113, 133);
    canvas.drawPath(greyPath, paint);
  }

    

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate!=this;
  }
  
}