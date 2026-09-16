import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String habitName;
  final bool isDone;
  final Function(bool?)? onChanged;

  const HabitCard({
    super.key,
    required this.habitName,
    required this.isDone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(),
      contentPadding: const EdgeInsets.all(8.0),
      tileColor: Colors.blue,
      leading: Checkbox(value: isDone, onChanged: onChanged),
      title: Text(habitName, style: TextStyle(fontSize: 20)),
    );
  }
}
