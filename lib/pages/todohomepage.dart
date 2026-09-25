import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habittile.dart';
import 'package:habit_tracker/database/habitdatabase.dart';
import 'package:hive/hive.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

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
      db.habitsList[index]["isDone"] = val; // ✅ غيرنا من [1] إلى ["isDone"]

      // إذا اكتملت العادة، سجل التاريخ
      if (val) {
        String todayDate = DateTime.now().toString().split(' ')[0];
        if (!db.habitsList[index]["completedDates"].contains(todayDate)) {
          db.habitsList[index]["completedDates"].add(todayDate);
        }
      }

      db.updateData();
    });
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.habitsList.removeAt(index);
      db.updateData();
    });
    displaySnackBar('Habit was deleted successfully!');
  }

  // SnackBar
  void displaySnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade200,

        elevation: 0,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
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
      body: db.habitsList.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildHeatmap(), // ✅ الـ Heatmap الجديد
                Expanded(
                  child: _buildAndDisplay(), // ✅ قائمة العادات
                ),
              ],
            ),
    );
  }

  // دالة الـ Heatmap
  Widget _buildHeatmap() {
    // تحويل البيانات من String إلى DateTime
    Map<DateTime, int> heatmapData = {};

    for (var habit in db.habitsList) {
      for (String dateStr in habit["completedDates"]) {
        // تحويل "2026-09-12" إلى DateTime
        DateTime date = DateTime.parse(dateStr);
        heatmapData[date] = (heatmapData[date] ?? 0) + 1;
      }
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: HeatMapCalendar(
        datasets: heatmapData,
        colorsets: {
          0: Colors.grey[300]!, // ⬜ لا عادات اكتملت
          1: Colors.green[300]!, // 🟩 عادة واحدة
          2: Colors.green[500]!, // 🟩 عادتان
          3: Colors.green[700]!, // 🟩 ثلاث عادات أو أكتر
        },
        textColor: Colors.black,
        size: 30,
        borderRadius: 4,
        margin: EdgeInsets.all(4),
      ),
    );
  }

  //Build And display items
  Widget _buildAndDisplay() {
    return ListView.builder(
      itemCount: db.habitsList.length,
      itemBuilder: (context, index) {
        return HabitTile(
          habitName: db.habitsList[index]["name"], // ✅
          isDone: db.habitsList[index]["isDone"],
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
              db.habitsList.add({
                "name": habit,
                "isDone": false,
                "completedDates": [],
              });
              db.updateData();
            });
            displaySnackBar('Habit added successfully');
          },
          validator: (habit) {
            if (habit == null || habit.trim().isEmpty) {
              return 'Please enter a habit';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Invalid habit name';
            }
            if (db.habitsList.any(
              (h) => h["name"].toLowerCase() == habit.toLowerCase(), // ✅
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
              db.habitsList[index]["name"] = habit;
              db.updateData();
            });
            displaySnackBar('Habit\'s name changed successfully!');
          },
          validator: (habit) {
            if (habit == null || habit.trim().isEmpty) {
              return 'Empty value 😊';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Invalid habit name';
            }
            if (db.habitsList.any(
              (h) => h["name"].toLowerCase() == habit.toLowerCase(), // ✅
            )) {
              return 'Please type a different name';
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
