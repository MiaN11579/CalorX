import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_info.dart';

class UserAccount {
  final String? id;
  String uid;
  String? email;

  // Nested ProfileInfo
  ProfileInfo profileInfo;

  UserAccount({
    this.id,
    required this.uid,
    this.email,
    required this.profileInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'profileInfo': profileInfo.toMap(),
    };
  }

  static UserAccount fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserAccount(
      id: doc.id,
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      profileInfo: ProfileInfo.fromMap(map['profileInfo'] ?? {}),
    );
  }
}