import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool isDone;
  final Function(bool?)? onChanged;
  final void Function(BuildContext)? deletePressed;
  final void Function(BuildContext)? settingsPressed;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.isDone,
    required this.onChanged,
    required this.deletePressed,
    required this.settingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          // settings button
          SlidableAction(
            onPressed: settingsPressed,
            backgroundColor: const Color.fromARGB(255, 84, 76, 76),
            icon: Icons.settings,

            borderRadius: BorderRadius.circular(10),
          ),

          // delete button
          SlidableAction(
            onPressed: deletePressed,
            backgroundColor: const Color.fromARGB(255, 248, 125, 125),
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: Card(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        color: const Color.fromARGB(255, 118, 191, 251),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Checkbox(
                side: BorderSide(color: Colors.black, width: 2),
                value: isDone,
                onChanged: onChanged,
                checkColor: Colors.white,
              ),
              Text(
                habitName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Flexible(child: SizedBox(width: 1000)),
              Icon(Icons.arrow_back_ios_new),
            ],
          ),
        ),
      ),
    );
  }
}
