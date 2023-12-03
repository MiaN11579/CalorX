import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/controller/user_account_service.dart';
import 'package:intl/intl.dart';
import '../models/profile_info.dart';
import '../models/user_account.dart';
import 'components/gradient_background.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit'),
      ),
      body: Container(
        decoration: getGradientBackground(context),
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
                    Text('Edit ${widget.fieldLabel}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    if (widget.fieldLabel == 'Gender:') ...{
                      // Show radio buttons for gender selection
                      getRadioListTile('Male', selectedGender),
                      getRadioListTile('Female', selectedGender),
                    } else if (widget.fieldLabel == 'Activity Level:') ...{
                      // Show radio buttons for activity level selection
                      getRadioListTile(
                          'Little or no exercise', selectedActivityLevel),
                      getRadioListTile(
                          'Light exercise or sports 1-3 days a week',
                          selectedActivityLevel),
                      getRadioListTile(
                          'Moderate exercise or sports 3-5 days a week',
                          selectedActivityLevel),
                      getRadioListTile(
                          'Hard exercise or sports 6-7 days a week',
                          selectedActivityLevel),
                    } else if (widget.fieldLabel == 'Goal:') ...{
                      // Show radio buttons for goal selection
                      getRadioListTile('Weight Loss', selectedGoal),
                      getRadioListTile('Weight Maintenance', selectedGoal),
                      getRadioListTile('Muscle Gain', selectedGoal),
                      getRadioListTile('General Health', selectedGoal),
                    } else if (widget.fieldLabel == 'Duration:') ...{
                      // Show radio buttons for duration selection
                      getRadioListTile('Within 6 months', selectedDuration),
                      getRadioListTile('Within 1 year', selectedDuration),
                      getRadioListTile('Within 2 years', selectedDuration),
                      getRadioListTile('2 years or more', selectedDuration),
                    } else if (widget.fieldLabel == 'Date of Birth:') ...{
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
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              Icon(Icons.calendar_today,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary // Set icon color to white
                                  ),
                            ],
                          ),
                        ),
                      )
                    } else ...{
                      TextField(
                        controller: valueController,
                        keyboardType: widget.fieldLabel == 'Name:'
                            ? TextInputType.text
                            : TextInputType.number,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var profileInfoFetched = await _loadProfile();
                        if (widget.fieldLabel == 'Weight:') {
                          profileInfoFetched.weight =
                              int.parse(valueController.text);
                        } else if (widget.fieldLabel == 'Height:') {
                          profileInfoFetched.height =
                              int.parse(valueController.text);
                        } else if (widget.fieldLabel == 'Gender:') {
                          profileInfoFetched.gender = selectedGender;
                        } else if (widget.fieldLabel == 'Name:') {
                          profileInfoFetched.name = valueController.text;
                        } else if (widget.fieldLabel == 'Activity Level:') {
                          profileInfoFetched.activityLevel =
                              selectedActivityLevel;
                        } else if (widget.fieldLabel == 'Goal:') {
                          profileInfoFetched.goal = selectedGoal;
                        } else if (widget.fieldLabel == 'Duration:') {
                          profileInfoFetched.duration = selectedDuration;
                        } else if (widget.fieldLabel == 'Date of Birth:') {
                          profileInfoFetched.dob = dobController.text;
                        } else if (widget.fieldLabel == 'Name:') {
                          profileInfoFetched.name = valueController.text;
                        }

                        var calories = await _userAccountService
                            .calculateDailyCalorieIntake(profileInfoFetched);
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
                          await _userAccountService.updateUserProfileField(
                              widget.fieldLabel, selectedGender);
                        }

                        // Return the updated value to the calling widget
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(profileInfo: profileInfoFetched),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                        ),
                      ),
                      child: Text(
                        'Save Changes'.toUpperCase(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
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

  RadioListTile getRadioListTile(String title, String groupValue) {
    return RadioListTile(
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 18)),
      value: title,
      groupValue: groupValue,
      onChanged: (value) {
        setState(() {
          groupValue = value.toString();
        });
      },
      activeColor: const Color(0xffF4668F),
      tileColor: Colors.transparent,
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
