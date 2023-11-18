import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/UserAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/ProfileInfo.dart';


class Service {
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
