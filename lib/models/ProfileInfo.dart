import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileInfo {
  String? id;
  String name;
  String dob;
  int weight;
  int height;
  String gender;
  String activityLevel;
  String goal;
  String duration;

      ProfileInfo({
    this.id,
    required this.name,
    required this.dob,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.duration
  });
  /// Convert the `DiaryEntry` instance into a `Map<String, dynamic>`.

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'weight': weight,
      'height': height,
      'gender' : gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'duration': duration,

    };
  }

  static ProfileInfo fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ProfileInfo(
      id: doc.id,
      name: map['description'] ?? '',
      dob: map['dob'] ?? DateTime.now().year,
      weight: map['weight'] ?? '',
      height: map['height'] ?? '',
      gender: map['gender'] ?? '',
      activityLevel: map['activityLevel'] ?? '',
      goal: map['goal'] ?? '',
      duration: map['duration'] ?? '',

    );
  }
}
