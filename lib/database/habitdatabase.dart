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

  // دالة جديدة: إعادة تعيين العادات كل يوم
  void resetHabitsIfNewDay() {
    // الحصول على اليوم المخزن من قبل
    String? lastDate = _myBox.get('lastDate');

    // اليوم الحالي (مثلاً: 23-09-2024)
    String todayDate = DateTime.now().toString().split(' ')[0];

    // إذا كان اليوم جديد (مختلف عن اليوم السابق)
    if (lastDate != todayDate) {
      // أعد تعيين جميع العادات
      for (var habit in habitsList) {
        habit["isDone"] = false; // ✅ العادة لم تكتمل اليوم
      }

      // احفظ اليوم الجديد
      _myBox.put('lastDate', todayDate);
      updateData();
    }
  }

  // دالة جديدة: إضافة عادة جديدة بصيغة جديدة
  void addNewHabit(String habitName) {
    habitsList.add({
      "name": habitName,
      "isDone": false,
      "completedDates": [], // قائمة فارغة في البداية
    });
    updateData();
  }
}
