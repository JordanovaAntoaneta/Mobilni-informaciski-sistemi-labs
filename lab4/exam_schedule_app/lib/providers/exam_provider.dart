import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/exam.dart';

class ExamProvider extends ChangeNotifier {
  final List<Exam> _exams = [];

  List<Exam> get exams => _exams;

  List<Exam> getExamsForDay(DateTime day) {
    return _exams.where((exam) => isSameDay(exam.date, day)).toList();
  }

  void addExam(Exam exam) {
    _exams.add(exam);
    notifyListeners();
  }
}
