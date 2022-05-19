import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;

  String getUserId(){
    return _firebaseAuth.currentUser!.uid;
  }
   final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("products");
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");
}




