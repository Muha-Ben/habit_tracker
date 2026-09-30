import 'package:hive/hive.dart';

final _myBox = Hive.box('myBox');

class Habitdatabase {
  List habitsList = [];

  Future<void> loadData() async {
    habitsList = await _myBox.get('habitsList') ?? [];
  }

  void updateData() {
    _myBox.put('habitsList', habitsList);
  }

  void resetHabitsIfNewDay() {
    // الحصول على اليوم المخزن من قبل
    String? lastDate = _myBox.get('lastDate');

    String todayDate = DateTime.now().toString().split(' ')[0];

    // إذا كان اليوم جديد (مختلف عن اليوم السابق)
    if (lastDate != todayDate) {
      // أعد تعيين جميع العادات
      for (var habit in habitsList) {
        habit["isDone"] = false;
      }

      _myBox.put('lastDate', todayDate);
      updateData();
    }
  }

  void addNewHabit(String habitName) {
    habitsList.add({"name": habitName, "isDone": false, "completedDates": []});
    updateData();
  }
}
