import 'package:exam_schedule_app/pages/add_exam_screen.dart';
import 'package:exam_schedule_app/pages/map_screen.dart';
import 'package:exam_schedule_app/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExamProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExamScreen(),
    );
  }
}

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExamProvider>(context);
    final examsForSelectedDay = provider.getExamsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Planner'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExamScreen()),
        ),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: examsForSelectedDay.isEmpty
                ? Center(child: Text('No exams for this day'))
                : ListView.builder(
              itemCount: examsForSelectedDay.length,
              itemBuilder: (context, index) {
                final exam = examsForSelectedDay[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(exam.subject),
                    subtitle: Text(
                        '${exam.date.toLocal()} @ ${exam.time}\nLocation: ${exam.location}'),
                    trailing: Icon(Icons.school),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






