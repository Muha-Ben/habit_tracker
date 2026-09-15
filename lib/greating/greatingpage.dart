import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/todohomepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Greatingpage extends StatelessWidget {
  Greatingpage({super.key});
  // reference the box
  final _myBox = Hive.box('myBox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 206, 244),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/welcome_habit_tracker_image.png'),
          SizedBox(height: 130),
          const Text(
            'Welcome to Habits Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 97, 174, 237),
              elevation: 0,
              side: BorderSide(color: Colors.black, width: 2),
            ),
            onPressed: () async {
              _myBox.put('isFirstTime', false);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (builder) => Homepage()),
              );
            },

            child: const Text(
              'Get Started',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
