import 'package:flutter/material.dart';
import 'package:habit_tracker/greating/greatingpage.dart';
import 'package:habit_tracker/pages/todohomepage.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive
  await Hive.initFlutter();
  // open box
  await Hive.openBox('myBox');
  final myBox = Hive.box('myBox');
  bool isFirstTime = myBox.get('isFirstTime') ?? false;
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstTime ? Greatingpage() : Homepage(),
    );
  }
}
