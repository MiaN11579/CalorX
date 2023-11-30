import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/controller/user_account_service.dart';
import '../models/profile_info.dart';
import '../models/user_account.dart';
import 'profile_page.dart'; // Import the profile page

class EditProfileScreen extends StatefulWidget {
  final UserAccountService userAccountService;
  final String fieldLabel;
  final String initialValue;

  EditProfileScreen({
    required this.userAccountService,
    required this.fieldLabel,
    required this.initialValue,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final UserAccountService _userAccountService = UserAccountService();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<ProfileInfo> _loadProfile() async {
    return (await _userAccountService.getUserProfile())!;
  }

  @override
  void initState() {
    super.initState();
    weightController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fieldLabel}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit ${widget.fieldLabel}'),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var profileInfoFetched = await _loadProfile();
                if (widget.fieldLabel == 'Weight:') {
                  profileInfoFetched.weight = int.parse(weightController.text);
                }

                var id = await _userAccountService.profileExists();
                UserAccount user = UserAccount(
                  id: id,
                  uid: currentUser!.uid,
                  profileInfo: profileInfoFetched,
                  email: currentUser!.email,
                );

                await _userAccountService.updateUserProfile(user);

                // Return the updated value to the calling widget
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(profileInfo: profileInfoFetched),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
