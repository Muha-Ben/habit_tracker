import 'package:flutter/material.dart';

AlertDialog alertDialog({
  required TextEditingController habitController,
  required String hintText,
  required void Function()? saveTapped,
  required void Function()? cancelTapped,
}) {
  return AlertDialog(
    backgroundColor: const Color.fromARGB(255, 190, 222, 239),

    content: TextField(
      controller: habitController,

      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        onPressed: cancelTapped,
        child: Text('Cancel'),
      ),
      MaterialButton(
        elevation: 0,

        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        color: Colors.blue,
        onPressed: saveTapped,
        child: Text('Save'),
      ),
    ],
  );
}
