import 'package:flutter/material.dart';

class Alertdialog extends StatefulWidget {
  @override
  // State<Alertdialog>createState()=>Alertdialog();
  final String hintText;
  final GlobalKey<FormState> formKey;
  final void Function()? saveTapped;
  final void Function()? cancelTapped;

  const Alertdialog({
    super.key,
    required this.hintText,
    required this.formKey,
    required this.cancelTapped,
    required this.saveTapped,
  });
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 190, 222, 239),
        content: TextFormField(
          onSaved: (newValue) {},
          validator: (habit) {
            if (habit == null || habit.isEmpty) {
              return 'Nothing to add';
            }
            if (RegExp(r'\d').hasMatch(habit)) {
              return 'Please remove digits';
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
            onPressed: () {},
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}

// AlertDialog alertDialog({
//   required TextEditingController habitController,
//   required String hintText,

// }) {
//   return AlertDialog(
//

//
//
//   );
// }
