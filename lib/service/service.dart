import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/UserAccount.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adjust the import path based on your project structure

class Service {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection;

  Service()
      : userCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userAccount');

  Future<void> saveUserProfile(UserAccount user) async {
    print(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Convert the user object to a Map
      Map<String, dynamic> userData = user.toMap();

      // Save the user data to Firestore
      await userCollection.add(user.toMap());

    } catch (e) {
      // Handle any errors that occur during the save process
      print('Error saving user profile: $e');
      rethrow;
    }
  }
}
