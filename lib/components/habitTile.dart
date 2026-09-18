import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool isDone;
  final Function(bool?)? onChanged;
  final void Function()? deletePressed;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.isDone,
    required this.onChanged,
    required this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 118, 191, 251),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Checkbox(
              value: isDone,
              onChanged: onChanged,
              checkColor: Colors.white,
            ),
            Text(habitName, style: TextStyle(fontSize: 20)),
            Expanded(child: SizedBox(width: 200)),
            IconButton(
              onPressed: deletePressed,
              icon: Icon(
                Icons.delete,
                color: const Color.fromARGB(255, 117, 40, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
