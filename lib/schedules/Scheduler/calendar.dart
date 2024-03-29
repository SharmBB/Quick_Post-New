import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:post/schedules/Scheduler/event.dart';
import 'package:post/utils/constants.dart';

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
  String selectedDayCollection = DateTime.now().toString();
  DateTime getTimeCollection = DateTime.now();
  DateTime getTime = DateTime.now().add(new Duration(minutes: 15));

  // DateTime dateTime = DateTime.now();
  // DateTime focusedDay = DateTime.now();



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
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () =>
                // Navigator.of(context).pop(),
                _sendDataBack(context)),
        centerTitle: true,
        title: Text(
          'Calendar',
          style: TextStyle(color: kPrimaryDarkColor, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            _buildTableCalendar(),
            Divider(),
            _timePicker(context),
            SizedBox(
              height: 20,
            ),
          ])),
    );
  }

  Padding _buildTableCalendar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TableCalendar(
        focusedDay: selectedDay,
        firstDay: DateTime.now(),
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
        onDaySelected: (DateTime day, DateTime focusDay) {
          setState(() {
            selectedDay = day;
            // focusedDay = focusDay;
          });
          print("-------------------");
          print(DateFormat.yMd().format(selectedDay).toString());
          print("Day : " + selectedDay.day.toString());
          print("Month : " + selectedDay.month.toString());
          print("Year : " + selectedDay.year.toString());
          print(selectedDayCollection);
          selectedDayCollection = DateFormat.yMd().format(selectedDay).toString();
          print(selectedDayCollection);

          print("-------------------");
        },
        selectedDayPredicate: (DateTime date) {
          return isSameDay(selectedDay, date);
        },

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
            borderRadius: BorderRadius.circular(50.0),
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
    );
  }

  Column _timePicker(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select time", style: TextStyle(fontSize: 18.0)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Text(
                '(${DateFormat.Hm().format(getTime)})',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0)),
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CupertinoButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      getTime = DateTime.now();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),
                                CupertinoButton(
                                  child: Text(
                                    "Done",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // prefs.setString('selectedTime','(${DateFormat.Hm().format(_dateTime)})');
                                    print(DateFormat.Hm().format(getTime));
                                    getTimeCollection = getTime;
                                    // getTime = '(${DateFormat.Hm().format(getTime)})';
                                  },
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                    use24hFormat: true,
                                    initialDateTime: getTime,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (dateTime) {
                                      setState(() {
                                        getTime = dateTime;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }

  void _sendDataBack(BuildContext context) {
    var textToSendBack = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, getTimeCollection.hour, getTimeCollection.minute);
    Navigator.pop(context, textToSendBack);
    print("getTimeCollection");
    print(textToSendBack);
    // print(getTimeCollection);
    // print(selectedDayCollection);

    // final toUTC = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, getTimeCollection.hour, getTimeCollection.minute);

    // print(toUTC);
    // print(DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, getTimeCollection.hour, getTimeCollection.minute));
    print("selectedDayCollection");


  }
}
