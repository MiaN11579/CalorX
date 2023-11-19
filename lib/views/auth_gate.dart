import 'package:final_project/models/profile_info.dart';
import 'package:final_project/views/questions_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:final_project/service/service.dart';

import 'main_page.dart';


class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  ProfileInfo? profileInfo;
  Service? service;

  Future<void> profileExists() async {
    service = Service();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      profileInfo = await service?.getUserProfile();
      if (mounted) {
        setState(() {
          profileInfo;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    profileExists();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Text('Welcome to CalorX!'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to CalorX, please sign in!')
                    : const Text('Welcome to CalorX, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      label: const Text('Sign In With Google'),
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                      }));
            },
          );
        }
        if (profileInfo != null)
          {
            return MainPage(profileInfo: profileInfo!);
          }
        return const QuestionsPage();
      },
    );
  }
}

