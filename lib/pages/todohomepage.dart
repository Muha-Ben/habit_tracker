import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habitcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  // list of habits
  List habitsList = [HabitCard(), HabitCard()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 223, 251),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            final prefer = await SharedPreferences.getInstance();
            prefer.clear();
          },
          icon: Icon(Icons.delete),
        ),
        backgroundColor: const Color.fromARGB(255, 97, 174, 237),
        title: Text(
          'Habit Tracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: habitsList.length,
        itemBuilder: (context, index) {
          return habitsList[index];
        },
      ),
    );
  }
}
