import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:post/schedules/scheduler/button_widget.dart';
import 'package:post/schedules/scheduler/event.dart';
import 'package:post/schedules/scheduler/utils.dart';
import 'package:post/schedules/new_schedule.dart';

import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Time>> selectedEvents;

  late Map<DateTime, List<Date>> selectedEvents1;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<Time> _getEventsfromTime(
    DateTime time,
  ) {
    return selectedEvents[time] ?? [];
  }

  List<Date> _getEventsfromDate(
    DateTime date,
  ) {
    return selectedEvents1[date] ?? [];
  }

  DateTime dateTime = DateTime.now();
  String? time;
  String? _viewtime = "", _viewdate, _viewdate2;

  void _timeView() {
    setState(
      () {
        _viewtime = time;
        _viewdate = selectedDay.day.toString() +
            " " +
            DateFormat.MMMM().format(selectedDay).toString() +
            " , " +
            _viewtime.toString();
        _viewdate2 = DateFormat('EEEE').format(selectedDay).toString() +
            ", " +
            selectedDay.day.toString() +
            " " +
            DateFormat.MMMM().format(selectedDay).toString() +
            " " +
            selectedDay.year.toString();

        if (selectedEvents1[selectedDay] != null) {
        } else {
          selectedEvents1[selectedDay] = [
            Date(viewdate: _viewdate2.toString()),
          ];
        }
        setState(() {});

        if (selectedEvents[selectedDay] != null) {
          selectedEvents[selectedDay]!.add(
            Time(viewtime: _viewtime.toString()),
          );
        } else {
          selectedEvents[selectedDay] = [
            Time(viewtime: _viewtime.toString()),
          ];
        }

        setState(() {});
      },
    );
    print(_viewdate);
    print(_viewtime);
  }

  @override
  void initState() {
    selectedEvents = {};
    selectedEvents1 = {};
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon:
                    Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewSchedule(
                            title: "", date: "", date2: "", time: "")),
                  );
                },
              ),
              Text(
                "Back",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ]),
        leadingWidth: 100,
        centerTitle: true,
        title: Text(
          'Calendar',
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: TextButton(
                onPressed: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new NewSchedule(
                      date: _viewdate.toString(),
                      date2: _viewdate.toString(),
                      time: _viewtime.toString(),
                      title: '',
                    ),
                  );
                  Navigator.of(context).push(route);
                },
                child: const Text(
                  "Next",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat _format) {
                  setState(() {
                    format = _format;
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.sunday,
                daysOfWeekVisible: true,

                //Day Changed
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                  print(focusedDay);
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },

                //To style the Calendar
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFE0B2),
                        Color(0xFFFFEB74D),
                        Colors.pinkAccent,
                        Color(0xFFBA68C8),
                        Color(0xFF7E57C2),
                      ],
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  todayDecoration: BoxDecoration(
                    color: null,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  defaultDecoration: BoxDecoration(
                    color: null,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Divider(),
            ButtonWidget(
              onClicked: () => Utils.showSheet(
                context,
                child: buildTimePicker(),
                onClicked: () {
                  time = DateFormat('hh:mm' + ' a').format(dateTime);

                  _timeView();
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              _viewtime.toString(),
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
          ])),
    );
  }

  Widget buildTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.time,
          minuteInterval: 1,
          //use24hFormat: true,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );
}
