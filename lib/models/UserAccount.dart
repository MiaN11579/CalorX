import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileInfo.dart';

class UserAccount {
  String uid;
  String? email;
  // Add other user-related fields here

  // Nested ProfileInfo
  ProfileInfo profileInfo;

  UserAccount({
    required this.uid,
     this.email,
    required this.profileInfo,
    // Add other parameters here
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'profileInfo': profileInfo.toMap(),
      // Add other fields as needed
    };
  }

  static UserAccount fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserAccount(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      profileInfo: ProfileInfo.fromMap(map['profileInfo'] ?? {}),
      // Add other fields as needed
    );
  }
}