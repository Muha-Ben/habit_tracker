import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(value: true, onChanged: (val) {}),
            Text('Flutter'),
          ],
        ),
      ),
    );
  }
}
