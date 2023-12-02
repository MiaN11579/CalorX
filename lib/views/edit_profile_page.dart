import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/controller/user_account_service.dart';
import 'package:intl/intl.dart';
import '../models/profile_info.dart';
import '../models/user_account.dart';
import 'profile_page.dart';

class EditProfileScreen extends StatefulWidget {
  final UserAccountService userAccountService;
  final String fieldLabel;
  final String initialValue;

  const EditProfileScreen({
    super.key,
    required this.userAccountService,
    required this.fieldLabel,
    required this.initialValue,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController valueController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final UserAccountService _userAccountService = UserAccountService();
  final currentUser = FirebaseAuth.instance.currentUser;

  String selectedGender = '';
  String selectedActivityLevel = '';
  String selectedGoal = '';
  String selectedDuration = '';
  DateTime selectedDate = DateTime.now();

  Future<ProfileInfo> _loadProfile() async {
    return (await _userAccountService.getUserProfile())!;
  }

  @override
  void initState() {
    super.initState();
    valueController.text = widget.initialValue;
    selectedGender = widget.initialValue;
    selectedActivityLevel = widget.initialValue;
    selectedGoal = widget.initialValue;
    selectedDuration = widget.initialValue;
    dobController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit',style: TextStyle(color: Color(0xffF4668F)),),
        backgroundColor: const Color(0xffFFC5C0).withOpacity(0.6),
        iconTheme: const IconThemeData(color: Color(0xffF4668F)),
      ),
      body: Container(
        color: const Color(0xffFFC5C0).withOpacity(0.6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit ${widget.fieldLabel}'),
                    if (widget.fieldLabel == 'Gender:') ...{
                      // Show radio buttons for gender selection
                      RadioListTile(
                        title: const Text('Male'),
                        value: 'Male',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Female'),
                        value: 'Female',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                    } else if (widget.fieldLabel == 'Activity Level:') ...{
                      // Show radio buttons for activity level selection
                      RadioListTile(
                        title: const Text('Little or no exercise'),
                        value: 'Little or no exercise',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedActivityLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedActivityLevel = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Light exercise or sports 1-3 days a week'),
                        value: 'Light exercise or sports 1-3 days a week',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedActivityLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedActivityLevel = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Moderate exercise or sports 3-5 days a week'),
                        value: 'Moderate exercise or sports 3-5 days a week',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedActivityLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedActivityLevel = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Hard exercise or sports 6-7 days a week'),
                        value: 'Hard exercise or sports 6-7 days a week',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedActivityLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedActivityLevel = value.toString();
                          });
                        },
                      ),
                    } else if (widget.fieldLabel == 'Goal:') ...{
                      // Show radio buttons for goal selection
                      RadioListTile(
                        title: const Text('Weight Loss'),
                        value: 'Weight Loss',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGoal,
                        onChanged: (value) {
                          setState(() {
                            selectedGoal = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Weight Maintenance'),
                        value: 'Weight Maintenance',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGoal,
                        onChanged: (value) {
                          setState(() {
                            selectedGoal = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Muscle Gain'),
                        value: 'Muscle Gain',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGoal,
                        onChanged: (value) {
                          setState(() {
                            selectedGoal = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('General Health'),
                        value: 'General Health',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedGoal,
                        onChanged: (value) {
                          setState(() {
                            selectedGoal = value.toString();
                          });
                        },
                      ),
                    } else if (widget.fieldLabel == 'Duration:') ...{
                      // Show radio buttons for duration selection
                      RadioListTile(
                        title: const Text('Within 6 months'),
                        value: 'Within 6 months',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedDuration,
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Within 1 year'),
                        value: 'Within 1 year',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedDuration,
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Within 2 years'),
                        value: 'Within 2 years',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedDuration,
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('2 years or more'),
                        value: '2 years or more',
                        activeColor: const Color(0xffF4668F),
                        groupValue: selectedDuration,
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value.toString();
                          });
                        },
                      ),
                    } else if(widget.fieldLabel == 'Date of Birth:')...{

                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                dobController.text,
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      )
                    }
                    else ...{
                      // Show regular text field for other fields
                      TextField(
                        controller: valueController,
                        keyboardType: widget.fieldLabel == 'Name:' ? TextInputType.text : TextInputType.number,
                      ),
                    },
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var profileInfoFetched = await _loadProfile();
                        if (widget.fieldLabel == 'Weight:') {
                          profileInfoFetched.weight = int.parse(valueController.text);
                        } else if (widget.fieldLabel == 'Height:') {
                          profileInfoFetched.height = int.parse(valueController.text);
                        } else if (widget.fieldLabel == 'Gender:') {
                          profileInfoFetched.gender = selectedGender;
                        } else if (widget.fieldLabel == 'Name:') {
                          profileInfoFetched.name = valueController.text;
                        } else if (widget.fieldLabel == 'Activity Level:') {
                          profileInfoFetched.activityLevel = selectedActivityLevel;
                        } else if (widget.fieldLabel == 'Goal:') {
                          profileInfoFetched.goal = selectedGoal;
                        } else if (widget.fieldLabel == 'Duration:') {
                          profileInfoFetched.duration = selectedDuration;
                        } else if (widget.fieldLabel == 'Date of Birth:') {
                          profileInfoFetched.dob = dobController.text;
                        }
                        else if (widget.fieldLabel == 'Name:') {
                          profileInfoFetched.name = valueController.text;
                        }

                        var calories = await _userAccountService.calculateDailyCalorieIntake(profileInfoFetched);
                        profileInfoFetched.calorieIntake = calories;

                        var id = await _userAccountService.profileExists();
                        UserAccount user = UserAccount(
                          id: id,
                          uid: currentUser!.uid,
                          profileInfo: profileInfoFetched,
                          email: currentUser!.email,
                        );
                        await _userAccountService.updateUserProfile(user);

                        // Update the specific field using updateUserProfileField
                        if (widget.fieldLabel != 'Name:') {
                          await _userAccountService.updateUserProfileField(widget.fieldLabel, selectedGender);
                        }

                        // Return the updated value to the calling widget
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(profileInfo: profileInfoFetched),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF4668F)),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text =
            DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate);

      });
    }
  }
}
