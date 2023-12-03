import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/models/profile_info.dart';
import 'package:final_project/models/user_account.dart';
import 'package:final_project/controller/user_account_service.dart';
import '../controller/meal_service.dart';
import 'main_page.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentQuestionIndex = 0;
  List<String> questions = [
    'Your name:',
    'Your date of birth:',
    'Your weight (kg):',
    'Your height (cm):',
    'Your gender:',
    'How active are you usually?',
    'Tell us about your goal:',
    'When do you want to achieve this goal?',
  ];
  List<String> answers = List.filled(8, ''); // Initialize with empty strings
  List<TextEditingController> controllers =
      List.generate(8, (index) => TextEditingController());
  final currentUser = FirebaseAuth.instance.currentUser;
  final UserAccountService _userAccountService = UserAccountService();
  DateTime selectedDate = DateTime.now();

  final MealService mealService = MealService();

  // Add the dateController
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
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
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: const Color(0xffFFC5C0).withOpacity(0.6),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xffF4668F),
                      onPressed: () {
                        if (currentQuestionIndex > 0) {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  questions[currentQuestionIndex],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: _buildInputField(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF4668F)),
                      onPressed: () {
                        FocusScope.of(context)
                            .unfocus(); // Dismiss the keyboard
                        if (answers[currentQuestionIndex].isNotEmpty) {
                          // controllers[currentQuestionIndex].clear();

                          if (currentQuestionIndex < questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                            });
                          } else {
                            // If it's the last question, change the button text to "Submit"
                            // and navigate to the success screen
                            setState(() {
                              ProfileInfo profileInfo = ProfileInfo(
                                name: answers[0],
                                dob: answers[1],
                                weight: int.tryParse(answers[2]) ?? 0,
                                height: int.tryParse(answers[3]) ?? 0,
                                gender: answers[4],
                                activityLevel: answers[5],
                                goal: answers[6],
                                duration: answers[7],
                                calorieIntake: 0,
                                imageUrl: "",
                              );

                              profileInfo.calorieIntake = _userAccountService
                                  .calculateDailyCalorieIntake(profileInfo);
                              _submitAnswers();
                            });
                          }
                        } else {
                          print('Please answer the question');
                        }
                      },
                      child: Text(
                        currentQuestionIndex < questions.length - 1
                            ? 'Next'
                            : 'Submit',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInputField() {
    if (currentQuestionIndex == 1) {
      // Show date picker
      return InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Select date of birth',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                dateController.text,
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      );
    } else if (currentQuestionIndex == 5) {
      // Show radio buttons for activity level
      return Column(
        children: [
          RadioListTile(
            title: const Text('Little or no exercise.'),
            value: 'Little or no exercise.',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Light exercise or sports 1-3 days a week.'),
            value: 'Light exercise or sports 1-3 days a week.',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Moderate exercise or sports 3-5 days a week.'),
            value: 'Moderate exercise or sports 3-5 days a week.',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Hard exercise or sports 6-7 days a week.'),
            value: 'Hard exercise or sports 6-7 days a week.',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
        ],
      );
    } else if (currentQuestionIndex == 4) {
      // Show radio buttons for gender
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: 'Male',
            groupValue: answers[currentQuestionIndex],
            activeColor: const Color(0xffF4668F),
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          const Text('Male'),
          const SizedBox(width: 20),
          Radio(
            value: 'Female',
            groupValue: answers[currentQuestionIndex],
            activeColor: const Color(0xffF4668F),
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          const Text('Female'),
        ],
      );
    } else if (currentQuestionIndex == 6) {
      // Show radio buttons for goal options
      return Column(
        children: [
          RadioListTile(
            title: const Text('Weight Loss'),
            value: 'Weight Loss',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Weight Maintenance'),
            value: 'Weight Maintenance',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Muscle Gain'),
            value: 'Muscle Gain',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('General Health'),
            value: 'General Health',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
        ],
      );
    } else if (currentQuestionIndex == 7) {
      // Show radio buttons for goal deadline
      return Column(
        children: [
          RadioListTile(
            title: const Text('Within 6 months'),
            value: 'Within 6 months',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Within 1 year'),
            value: 'Within 1 year',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Within 2 years'),
            value: 'Within 2 years',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('2 years or more'),
            value: '2 years or more',
            activeColor: const Color(0xffF4668F),
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
        ],
      );
    } else {
      // Show text field for other questions
      return TextField(
        controller: controllers[currentQuestionIndex],
        onChanged: (value) {
          if (currentQuestionIndex == 2 || currentQuestionIndex == 3) {
            // Validate input as double for weight and height
            if (value.isNotEmpty && double.tryParse(value) != null) {
              answers[currentQuestionIndex] = value;
            } else {
              print('Please enter a valid number for weight and height');
            }
          } else {
            answers[currentQuestionIndex] = value;
          }
        },
        keyboardType: (currentQuestionIndex == 2 || currentQuestionIndex == 3)
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: const InputDecoration(
          hintText: 'Enter your answer',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      );
    }
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
        dateController.text =
            DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate);
        answers[currentQuestionIndex] = dateController.text;
      });
    }
  }

  Future<void> _submitAnswers() async {
    // Check if all questions are answered
    if (answers.every((answer) => answer.isNotEmpty)) {
      // Show loading indicator with a message
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false, // Set to false to have a transparent background
          pageBuilder: (BuildContext context, _, __) {
            return Container(
              color: Colors.white, // Set the background color to white
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffF4668F)),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      alignment: Alignment.center,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Calculating your daily calorie intake...',
                            textAlign: TextAlign.center,
                            textStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Color(0xffF4668F),
                                fontSize: 14,
                                backgroundColor: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                            speed: const Duration(milliseconds: 80),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        stopPauseOnTap: false,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      try {
        // Simulate a delay
        await Future.delayed(const Duration(seconds: 5));

        // Save the user's inputs to the ProfileInfo model
        ProfileInfo profileInfo = ProfileInfo(
          name: answers[0],
          dob: answers[1],
          weight: int.tryParse(answers[2]) ?? 0,
          height: int.tryParse(answers[3]) ?? 0,
          gender: answers[4],
          activityLevel: answers[5],
          goal: answers[6],
          duration: answers[7],
          calorieIntake: 0,
          imageUrl: "",
        );

        profileInfo.calorieIntake =
            _userAccountService.calculateDailyCalorieIntake(profileInfo);

        UserAccount userAccount = UserAccount(
          uid: currentUser!.uid,
          email: currentUser!.email,
          profileInfo: profileInfo,
        );

        if (currentUser != null) {
          String? id = await _userAccountService.profileExists();
          if (id != null) {
            _userAccountService.updateUserProfile(userAccount);
          } else {
            _userAccountService.saveUserProfile(userAccount);
          }
        }

        // Close the loading indicator
        Navigator.pop(context);

        //Navigate to the success screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(profileInfo: profileInfo)),
        );

        setState(() {
          // Clear the content of the page
          answers = List.filled(questions.length, ''); // Reset answers
        });
      } catch (e) {
        print('Error during processing: $e');
        // Handle errors as needed
      }
    } else {
      print('Please answer all questions');
    }
  }
}
