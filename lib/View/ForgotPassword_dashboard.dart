import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Réinitialiser le mdp'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recevoir un email pour \n reset le mdp',
                textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                email != null && !EmailValidator.validate(email)
                  ? 'Entrer un mail valide'
                  : null,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.email_outlined),
                label: Text(
                  'Reset MDP'
                ),
                onPressed: resetPassword,
            ),
          ],
        ),
      ),
    ),
  );

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Mot de passe réinitialisé, Vous avez reçu un email');
      Navigator.of(context).popUntil((route) => route.isFirst);

    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }

  }

}