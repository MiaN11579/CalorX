import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'components/gradient_background.dart';
import 'package:final_project/service/service.dart';

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
  final Service service = Service();

  Widget _buildRichTextWithBox(
      String label, String value, BuildContext context) {
    if (label == 'Date of Birth:') {
      DateTime dob = DateTime.parse(value);
      String formattedDate = DateFormat('MMM d, y').format(dob);
      value = formattedDate;
    }

    double boxHeight = (label == 'Activity Level:' || label == 'Recommended Daily Calorie Intake:') ? 90 : 65;

    return Container(
      width: 410,
      height: boxHeight,
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
        // decoration: getGradientBackground(context),
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
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          widget.profileInfo.imageUrl =
                          await service.getImageFromGallery();
                          setState(() {});
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              _buildRichTextWithBox(
                  'Date of Birth:', widget.profileInfo.dob, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Height:', '${widget.profileInfo.height} cm', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Weight:', '${widget.profileInfo.weight} kg', context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Gender:', widget.profileInfo.gender, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Activity Level:', widget.profileInfo.activityLevel, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox('Goal:', widget.profileInfo.goal, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Duration:', widget.profileInfo.duration, context),
              const SizedBox(height: 8),
              _buildRichTextWithBox(
                  'Recommended Daily Calorie Intake:',
                  '${widget.profileInfo.calorieIntake} Calories',
                  context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
