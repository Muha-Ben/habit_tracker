import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habittile.dart';
import 'package:habit_tracker/database/habitdatabase.dart';
import 'package:hive/hive.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _myBox = Hive.box('myBox');
  Habitdatabase db = Habitdatabase();
  // habit Controller
  final formKey = GlobalKey<FormState>();
  // habit has checked
  void habitChecked(int index, bool val) {
    setState(() {
      db.habitsList[index][1] = val;
      db.saveDataToDatabase();
    });
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.habitsList.removeAt(index);
      db.saveDataToDatabase();
    });
  }

  // settings button pressed
  void settingsTapped(int index) {
    showDialog(
      context: context,
      builder: (builder) => _editHabitDialog(index: index),
    );
  }

  // floatingActionButton tapped
  void floatingActionTapped() {
    showDialog(context: context, builder: (builder) => _addHabitDialog());
  }

  // initStat
  @override
  void initState() {
    db.loadData().then((_) {
      setState(() {});
    });
    super.initState();
  }

  // Dispose
  @override
  void dispose() {
    formKey.currentState!.dispose();
    super.dispose();
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
          onPressed: () {
            _myBox.clear();
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
      body: db.habitsList.isEmpty ? _buildEmptyState() : _buildAndDisplay(),
    );
  }

  //Build And display items
  Widget _buildAndDisplay() {
    return ListView.builder(
      itemCount: db.habitsList.length,
      itemBuilder: (context, index) {
        return HabitTile(
          habitName: db.habitsList[index][0],
          isDone: db.habitsList[index][1],
          onChanged: (val) => habitChecked(index, val!),
          deletePressed: (context) => deleteHabit(index),
          settingsPressed: (context) => settingsTapped(index),
        );
      },
    );
  }

  // Build Empty state
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Center(
          child: Text(
            'No habit exists yet!',
            style: TextStyle(
              fontSize: 19,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text(
            'Please tap the button to add a habit',
            style: TextStyle(
              fontSize: 19,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Alert Dialog widget to add a new habit
  Widget _addHabitDialog() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 190, 222, 239),
        title: Text('Add a new habit'),
        content: TextFormField(
          onSaved: (newValue) {
            String habit = newValue![0].toUpperCase() + newValue.substring(1);
            setState(() {
              db.habitsList.add([habit, false]);
              db.saveDataToDatabase();
            });
          },
          validator: (habit) {
            if (habit == null || habit.trim().isEmpty) {
              return 'Please enter a habit';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Invalid habit name';
            }
            if (db.habitsList.any(
              (list) => list[0].toLowerCase() == habit.toLowerCase(),
            )) {
              return 'Habit already exists';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Habit Name',
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
  Widget _editHabitDialog({required int index}) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 190, 222, 239),
        title: Text('Edit a habit'),
        content: TextFormField(
          onSaved: (newValue) {
            String habit = newValue![0].toUpperCase() + newValue.substring(1);
            setState(() {
              db.habitsList[index][0] = habit;
              db.saveDataToDatabase();
            });
          },
          validator: (habit) {
            if (habit == null || habit.trim().isEmpty) {
              return 'Empty value 😊';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Invalid habit name';
            }
            if (db.habitsList.any(
              (list) => list[0].toLowerCase() == habit.toLowerCase(),
            )) {
              return 'Please type a new name';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Enter a new name',
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
}
