import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'components/gradient_background.dart';

class ProfilePage extends StatelessWidget {
  final ProfileInfo profileInfo;

  const ProfilePage({Key? key, required this.profileInfo}) : super(key: key);

  Widget _buildRichTextWithBox(
      String label, String value, BuildContext context) {
    if (label == 'Date of Birth:') {
      DateTime dob = DateTime.parse(value);
      String formattedDate = DateFormat('MMM d, y').format(dob);
      value = formattedDate;
    }
    return Container(
      width: 410,
      height: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
            Radius.circular(12)), // Adjust the radius for rounded corners
      ),
      padding: const EdgeInsets.all(19),
      // Adjust the padding for a larger box
      child: _buildRichText(label, value, context),
    );
  }

  Widget _buildRichText(String label, String value, BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.secondary,
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
        ],
      ),
    );
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
                      title: const Text('User Profile'),
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
              _buildRichTextWithBox('Name: ', profileInfo.name, context),
              const SizedBox(height: 8), // Add space between lines
              _buildRichTextWithBox('Date of Birth:', profileInfo.dob, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Height:', '${profileInfo.height} cm', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Weight:', '${profileInfo.weight} kg', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Gender:', profileInfo.gender, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Activity Level:', profileInfo.activityLevel, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Goal:', profileInfo.goal, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Duration:', profileInfo.duration, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Daily Calorie Intake:',
                  '${profileInfo.calorieIntake} Calories', context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
