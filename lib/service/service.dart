import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:flutter/cupertino.dart';

class Service {
  final CollectionReference userCollection;

  Service()
      : userCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('userAccount');

  Future<void> saveUserProfile(UserAccount user) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Save the user data to Firestore
      await userCollection.add(user.toMap());
    } catch (e) {
      // Handle any errors that occur during the save process
      debugPrint('Error saving user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserAccount user, String id) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Save the user data to Firestore
      await userCollection.doc(id).update(user.toMap());
    } catch (e) {
      // Handle any errors that occur during the save process
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<ProfileInfo?> getUserProfile() async {
    final snapshot = await userCollection.get();
    if (snapshot.docs.isNotEmpty) {
      // Retrieve profileInfo from the first entry
      Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
      if (data.containsKey('profileInfo')) {
        final info = data['profileInfo'];
        return ProfileInfo(
          name: info['name'],
          dob: info['dob'],
          weight: info['weight'],
          height: info['height'],
          gender: info['gender'],
          activityLevel: info['activityLevel'],
          goal: info['goal'],
          duration: info['duration'],
        );
      } else {
        debugPrint('Error: The entry does not contain profileInfo.');
        return null;
      }
    } else {
      debugPrint('Error: The collection is empty.');
      return null;
    }
  }

  // Checks if a profile for this user already existed, if yes, returns its entry id
  Future<String?> profileExists() async {
    final snapshot = await userCollection.get();
    if (snapshot.docs.isNotEmpty) { // check if collection is empty
      return snapshot.docs.first.id;
    }
    return null;
  }

  int calculateDailyCalorieIntake(ProfileInfo profileInfo) {
    double bmr;

    // Calculate BMR based on gender
    if (profileInfo.gender.toLowerCase() == 'male') {
      bmr = 88.362 +
          (13.397 * profileInfo.weight) +
          (4.799 * profileInfo.height) -
          (5.677 * calculateAgeFromString(profileInfo.dob));
    } else {
      bmr = 447.593 +
          (9.247 * profileInfo.weight) +
          (3.098 * profileInfo.height) -
          (4.330 * calculateAgeFromString(profileInfo.dob));
    }

    // Adjust for activity level
    double adjustedCalories;
    switch (profileInfo.activityLevel.toLowerCase()) {
      case 'sedentary':
        adjustedCalories = bmr * 1.2;
        break;
      case 'lightly active':
        adjustedCalories = bmr * 1.375;
        break;
      case 'moderately active':
        adjustedCalories = bmr * 1.55;
        break;
      case 'very active':
        adjustedCalories = bmr * 1.725;
        break;
      default:
        adjustedCalories = bmr;
    }

    // Adjust for goal
    switch (profileInfo.goal.toLowerCase()) {
      case 'weight loss':
        return (adjustedCalories - 500).round();
      case 'muscle gain':
        return (adjustedCalories + 500).round();
      default:
        return adjustedCalories.round();
    }
  }

  int calculateAgeFromString(String dobString) {
    final dob = DateTime.parse(dobString);
    final currentDate = DateTime.now();
    int age = currentDate.year - dob.year;

    // Check if the birthday has occurred this year
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age;
  }
}
