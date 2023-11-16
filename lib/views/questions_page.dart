import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:final_project/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:final_project/models/ProfileInfo.dart';
import 'package:final_project/models/UserAccount.dart';
import 'package:final_project/service/service.dart';
import 'package:final_project/views/dashboard_page.dart';
import 'package:intl/intl.dart';

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
  Service _service = Service();
  DateTime selectedDate = DateTime.now();

  // Add the dateController
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${questions[currentQuestionIndex]}',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: _buildInputField(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Check if there are previous questions
                    if (currentQuestionIndex > 0) {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    }
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
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
    );
  }

  Widget _buildInputField() {
    if (currentQuestionIndex == 1) {
      // Show date picker
      return InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select date of birth',
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                dateController.text,
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      );
    } else if (currentQuestionIndex == 5) {
      // Show radio buttons for activity level
      return Column(
        children: [
          RadioListTile(
            title: Text('Little or no exercise.'),
            value: 'Little or no exercise.',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Light exercise or sports 1-3 days a week.'),
            value: 'Light exercise or sports 1-3 days a week.',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Moderate exercise or sports 3-5 days a week.'),
            value: 'Moderate exercise or sports 3-5 days a week.',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Hard exercise or sports 6-7 days a week.'),
            value: 'Hard exercise or sports 6-7 days a week.',
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
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          Text('Male'),
          SizedBox(width: 20),
          Radio(
            value: 'Female',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          Text('Female'),
        ],
      );
    } else if (currentQuestionIndex == 6) {
      // Show radio buttons for goal options
      return Column(
        children: [
          RadioListTile(
            title: Text('Weight Loss'),
            value: 'Weight Loss',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Weight Maintenance'),
            value: 'Weight Maintenance',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Muscle Gain'),
            value: 'Muscle Gain',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('General Health'),
            value: 'General Health',
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
            title: Text('Within 6 months'),
            value: 'Within 6 months',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Within 1 year'),
            value: 'Within 1 year',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Within 2 years'),
            value: 'Within 2 years',
            groupValue: answers[currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                answers[currentQuestionIndex] = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('2 years or more'),
            value: '2 years or more',
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
            if (double.tryParse(value) != null) {
              answers[currentQuestionIndex] = value;
            } else {
              print('Please enter a valid number for weight and height');
            }
          } else {
            answers[currentQuestionIndex] = value;
          }
        },
        keyboardType: (currentQuestionIndex == 2 || currentQuestionIndex == 3)
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Enter your answer',
          border: OutlineInputBorder(),
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

  void _submitAnswers() {
    // Check if all questions are answered
    if (answers.every((answer) => answer.isNotEmpty)) {
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
      );

      UserAccount userAccount = UserAccount(
        uid: currentUser!.uid,
        email: currentUser!.email,
        profileInfo: profileInfo,
      );

      _service.saveUserProfile(userAccount);

      // Navigate to the success screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DashboardPage(),
      //   ),
      // );
    } else {
      print('Please answer all questions');
    }
  }
}
