import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserAccountService {
  final CollectionReference userCollection;
  final currentUser = FirebaseAuth.instance.currentUser;


  UserAccountService()
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

  Future<void> updateUserProfile(UserAccount user) async {
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    try {
      // Save the user data to Firestore
      await userCollection.doc(await profileExists()).update(user.toMap());
    } catch (e) {
      // Handle any errors that occur during the save process
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }
  Future<void> updateUserProfileField(String fieldLabel, String updatedValue) async {
    try {
      // Get the current user's profile
      var userProfile = await getUserProfile();

      // Update the specific field in the profile
      if (userProfile != null) {
        switch (fieldLabel.toLowerCase()) {
          case 'weight':
            userProfile.weight = int.parse(updatedValue);
            break;
          case 'height':
            userProfile.height = int.parse(updatedValue);
            break;
        }

        // Save the updated profile back to Firestore
        await userCollection.doc(await profileExists()).update({
          'profileInfo': userProfile.toMap(),
        });
      }
    } catch (e) {
      debugPrint('Error updating user profile field: $e');
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
          calorieIntake: info['calorieIntake'],
          imageUrl: info['imageUrl'],
        );
      } else {
        debugPrint('Error: The entry does not contain profileInfo.');
        return null;
      }
    } else {
      return null;
    }
  }

  Future<int?> getUserCalorie() async {
    final snapshot = await userCollection.get();
    if (snapshot.docs.isNotEmpty) {
      // Retrieve profileInfo from the first entry
      Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
      if (data.containsKey('profileInfo')) {
        final info = data['profileInfo'];
        return info['calorieIntake'];
      } else {
        debugPrint('Error: The entry does not contain profileInfo.');
        return null;
      }
    } else {
      return null;
    }
  }
  //for the image in profile_page
  Future<String> uploadImageToStorage(File imageFile, String userId) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String imagePath = 'users/${currentUser!.uid}/images';
      String imageName = '${currentUser!.uid}';

      // Check if the user already has an image
      bool userHasImage = await storage.ref('$imagePath/$imageName').listAll().then((result) => result.items.isNotEmpty);

      Reference storageReference = storage.ref().child('$imagePath/$imageName');

      if (userHasImage) {
        // If the user already has an image, update the existing image
        await storageReference.putFile(imageFile);
      } else {
        // If the user doesn't have an image, upload a new image
        UploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() {});
      }

      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<String> getImageFromGallery() async {
    var user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    String imageUrl = "";
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File? _imageFile;
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      try {
        imageUrl = await uploadImageToStorage(_imageFile!, user!.uid);
      } catch (e) {
        // Handle upload error, if any.
        print('Error uploading image: $e');
      }
    }
    return imageUrl;
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
