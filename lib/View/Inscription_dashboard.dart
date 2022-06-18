import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';
import '../main.dart';


class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirm = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirm.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Form(
      key: formKey,
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
        TextFormField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Email'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) =>
              email != null && !EmailValidator.validate(email)
              ? 'Entrer un email valide'
              : null,
        ),
        SizedBox(height: 4),
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Mot de passe'),
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
          value != null && value.length < 6
              ? 'Entrer un mdp valide (6 caractères max)'
              : null,
        ),
        SizedBox(height: 4),
        TextFormField(
          controller: passwordConfirm,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Confirmer le Mot de passe'),
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
          value != null && value.length < 6
              ? 'Entrer un mdp valide (6 caractères max)'
              : null,
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.lock_open, size: 32),
          label: Text(
            "S'inscrire",
            style: TextStyle(fontSize: 24),
          ),
          onPressed: signUp,
        ),
        SizedBox(height: 20),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 20),
                text: 'Déjà inscrit ? ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Connecte toi',
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
    )
  );


  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    if(passwordController.text == passwordConfirm.text){

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }on FirebaseAuthException catch (e) {
        print(e);

        Utils.showSnackBar(e.message);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);

    } else {
      Utils.showSnackBar('Les mot de passe ne sont pas identique');
      navigatorKey.currentState!.popUntil((route) => route.isCurrent);
    }


  }
}
