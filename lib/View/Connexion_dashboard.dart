import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../Utils.dart';


class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 60),
        FlutterLogo(size: 120),
        SizedBox(height: 20),
        Text(
          'Bienvenu sur, \n StatsStade',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 4),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Mot de passe'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.lock_open, size: 32),
          label: Text(
            'Sign in',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: signIn,
        ),
        SizedBox(height: 24),
        RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 20),
              text: 'Pas de compte ? ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                  text: 'Inscris toi',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                  )
                )
              ]
            )
        ),
      ],
    ),

  );


  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
