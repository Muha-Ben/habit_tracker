import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habittile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // list of habits
  List habitsList = [
    ['flutter', false],
    ['English', false],
  ];

  // habit has checked
  void habitChecked(int index, bool val) {
    setState(() {
      habitsList[index][1] = val;
    });
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      habitsList.removeAt(index);
    });
  }

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
          return HabitTile(
            habitName: habitsList[index][0],
            isDone: habitsList[index][1],
            onChanged: (val) => habitChecked(index, val!),
            deletePressed: () => deleteHabit(index),
          );
        },
      ),
    );
  }
}
