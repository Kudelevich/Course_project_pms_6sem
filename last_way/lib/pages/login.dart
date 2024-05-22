import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_way/auth.dart';
import 'package:flutter/material.dart';
import 'package:last_way/pages/register_dart.dart';
import 'package:last_way/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscureText = true;



  Future<void> signInWithEmailAndPassword() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

    // Переход на главную страницу после успешной аутентификации
   

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
        );

  } on FirebaseAuthException catch (e) {
    print(e);
    setState(() {
      errorMessage = e.message;
    });
  }
}

 
 Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _entryFieldPass(String title, TextEditingController controller) {
    return TextField(
      obscureText: _obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: IconButton(
          icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
             _obscureText = !_obscureText;
              });
          },
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      child: const Text('Login'),
    );
  }

  Widget _registerInsteadButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const RegisterPage()),
        );
      },
      child: const Text('Register instead'),
    );
  }

  Widget _WithOutButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  const GuestPage()),
        );
      },
      child: const Text('Continue without logging in'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: 
      CustomPaint(
        painter: BackgroundSingIn(),
        child:Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryFieldPass('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _registerInsteadButton(),
            _WithOutButton()
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
    var paint =Paint(); 
    
    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    //Blue
    Path blueWave=Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh*0.5);
    blueWave.quadraticBezierTo(sw*0.5, sh*0.45, sw*0.2, 0);
    blueWave.close();
    paint.color = const Color.fromARGB(255, 144, 207, 241);
    canvas.drawPath(blueWave, paint); 

    //grey
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh*0.1);
    greyWave.cubicTo(sw*0.95, sh*0.15, sw*0.65, sh*0.15, sw*0.6, sh*0.38);
    greyWave.cubicTo(sw*0.52, sh*0.52, sw*0.05, sh*0.45, 0, sh*0.4);
    greyWave.close();
    paint.color=const Color.fromARGB(255, 93, 159, 194);
    canvas.drawPath(greyWave, paint); 

    //Yellow
    Path yellowWave = Path();
    yellowWave.lineTo(sw*0.7, 0);
    yellowWave.cubicTo(sw*0.6, sh*0.05, sw*0.27, sh*0.01, sw*0.18, sh*0.12);
    yellowWave.quadraticBezierTo(sw*0.12, sh*0.2, 0, sh*0.2);
    yellowWave.close();
    paint.color = const Color.fromARGB(255, 82, 121, 142);
    canvas.drawPath(yellowWave, paint);
    }


    

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate!=this;
  }
  
}