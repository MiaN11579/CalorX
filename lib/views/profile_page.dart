import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:final_project/models/user_account.dart';
import 'package:final_project/theme.dart';
import 'package:provider/provider.dart';
import '../models/user_account.dart';
import '../theme.dart';
import 'components/gradient_background.dart';
import 'package:final_project/controller/user_account_service.dart';
import 'components/gradient_background.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final ProfileInfo profileInfo;

  const ProfilePage({
    Key? key,
    required this.profileInfo,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserAccountService _userAccountService = UserAccountService();
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isEditing = false;

  Future<void> _loadProfile() async {
    ProfileInfo profileInfoFetched = (await _userAccountService.getUserProfile())!;
    setState(() {
      widget.profileInfo.imageUrl = profileInfoFetched.imageUrl;
      widget.profileInfo.weight = profileInfoFetched.weight;
      widget.profileInfo.height = profileInfoFetched.height;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Widget _buildRichTextWithBox(String label, String value, String label2,  BuildContext context) {
    if (label == 'Date of Birth:') {
      DateTime dob = DateTime.parse(value);
      String formattedDate = DateFormat('MMM d, y').format(dob);
      value = formattedDate;
    }

    double boxHeight = (label == 'Activity Level:' || label == 'Recommended Daily Calorie Intake:') ? 90 : 65;

    return GestureDetector(
      onDoubleTap: () {
        if ((label) != 'Recommended Daily Calorie Intake:') {
          _editProfileField(label, value);
        }
      },
      child: Container(
        width: 410,
        height: boxHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(19),
        child: _buildRichText(label, value, label2, context),
      ),

    );
  }

  Widget _buildRichText(String label, String value, String label2, BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: label2,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _editProfileField(String label, String currentValue) async {
    var updatedValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userAccountService: _userAccountService,
          fieldLabel: label,
          initialValue: currentValue,
        ),
      ),
    );

    // Check if the user saved changes and update the UI
    if (updatedValue != null) {
      setState(() {
        if (label.toLowerCase() == 'weight') {
          widget.profileInfo.weight = int.parse(updatedValue);
        } else if (label.toLowerCase() == 'height') {
          widget.profileInfo.height = int.parse(updatedValue);
        } else if (label.toLowerCase() == 'name:') {
          widget.profileInfo.name = updatedValue;
        }
        // Add similar handling for other fields
        _loadProfile(); // Fetch updated profile information
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDark ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text(
                        'User Profile',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      leading: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: const [
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: getGradientBackground(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Theme.of(context).cardColor,
                      backgroundImage: widget.profileInfo.imageUrl.isNotEmpty
                          ? NetworkImage(widget.profileInfo.imageUrl)
                          : null,
                      child: widget.profileInfo.imageUrl.isEmpty
                          ? Text(
                        widget.profileInfo.name.isNotEmpty
                            ? widget.profileInfo.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 100,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          widget.profileInfo.imageUrl =
                          await _userAccountService.getImageFromGallery();
                          setState(() {
                            UserAccount user = UserAccount(
                                uid: currentUser!.uid,
                                email: currentUser!.email,
                                profileInfo: widget.profileInfo);
                            _userAccountService.updateUserProfile(user);
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Hey ${widget.profileInfo.name}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              _buildRichTextWithBox(
                  'Name:', widget.profileInfo.name,'', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Date of Birth:', widget.profileInfo.dob,'', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Height:', '${widget.profileInfo.height}' , ' cm', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Weight:', '${widget.profileInfo.weight}', ' kg', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Gender:', widget.profileInfo.gender, '', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Activity Level:', widget.profileInfo.activityLevel, '', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Goal:', widget.profileInfo.goal, '', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Duration:', widget.profileInfo.duration, '', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Recommended Daily Calorie Intake:',
                  '${widget.profileInfo.calorieIntake} Calories','',
                  context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
