import 'package:cloud_firestore/cloud_firestore.dart';

// Constructeur de la classe utilisateur via Firebase

class Utilisateur {
  //Attributs
  late String id;
  late String nom;
  late String prenom;
  late String mail;
  late String pseudo;
  String? avatar;

  Utilisateur(DocumentSnapshot snapshot) {
    String? provisoire;
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    nom = map["Nom"];
    prenom = map["Prénom"];
    mail = map["Mail"];
    pseudo = map["Pseudo"];
    provisoire = map["Avatar"];
    if (provisoire == null) {
      // Une image spécifique que je vais luis donner
      avatar =
      "https://firebasestorage.googleapis.com/v0/b/statstade.appspot.com/o/icon.png?alt=media&token=c3d7cb1c-1d44-4bca-aeb8-63f08d559926";
    }
    else {
      avatar = provisoire;
    }

  }

  //Deuxième constructeur qui affecter les valeurs à vide
  Utilisateur.empty(){
    id = "";
    nom ="";
    prenom="";
    mail ="";
    pseudo ="";
    avatar ="";

  }

}