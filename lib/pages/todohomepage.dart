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
  // habit Controller
  final formKey = GlobalKey<FormState>();
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

  // floatingActionButton tapped
  void floatingActionTapped() {
    showDialog(
      context: context,
      builder: (builder) => _addHabitDialog(hintText: 'Habit Name'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floating actionbutton
      floatingActionButton: FloatingActionButton(
        onPressed: floatingActionTapped,
        backgroundColor: Colors.blue,
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 30, color: Colors.black),
      ),
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

  // Alert Dialog widget to add a new habit
  Widget _addHabitDialog({required String hintText}) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 190, 222, 239),
        content: TextFormField(
          onSaved: (newValue) {
            String habit = newValue![0].toUpperCase() + newValue.substring(1);
            setState(() {
              habitsList.add([habit, false]);
            });
          },
          validator: (habit) {
            if (habit == null || habit.trim().isEmpty) {
              return 'Please enter a habit';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Invalid habit name';
            }
            if (habitsList.any(
              (list) => list[0].toLowerCase() == habit.toLowerCase(),
            )) {
              return 'Habit already exists';
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
          ),
        ),
        actions: [
          MaterialButton(
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          MaterialButton(
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            color: Colors.blue,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
  // Alert Dialog widget to edit an existed habit
}
