import 'package:hive/hive.dart';

final _myBox = Hive.box('myBox');

class Habitdatabase {
  List habitsList = [];
  // loading data
  Future<void> loadData() async {
    habitsList = await _myBox.get('habitsList') ?? [];
  }

  // save data
  void updateData() {
    _myBox.put('habitsList', habitsList);
  }
}
