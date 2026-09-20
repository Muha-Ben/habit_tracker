import 'package:flutter/material.dart';
import 'package:habit_tracker/greating/greatingpage.dart';
import 'package:habit_tracker/pages/todohomepage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive
  await Hive.initFlutter();
  // open hive box
  await Hive.openBox('myBox');
  final prefer = await SharedPreferences.getInstance();

  bool isFirstTime = prefer.getBool('isFirstTime') ?? true;
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
