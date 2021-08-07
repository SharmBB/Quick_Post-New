// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:post/utils/constants.dart';
// import 'package:quickpost/components/ScheduleCard.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../constants.dart';
// import 'package:flutter/cupertino.dart';

// class RadioModel {
//   final String src;
//   final String content;
//   final String time;
//   final Function press;
//   RadioModel(this.src, this.content, this.time, this.press);
// }

// class Calendar extends StatefulWidget {
//   Calendar({Key? key}) : super(key: key);
//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
//   Map<DateTime, List> _events;
//   List _selectedEvents;
//   CalendarController _calendarController;
//   DateTime _dateTime = DateTime.now().add(new Duration(minutes: 11));
//   TextEditingController textFieldController = TextEditingController();
//   String getTime = DateTime.now().toString();

//   ScrollController _scrollController = new ScrollController();

//   List<RadioModel> sampleData = <RadioModel>[];

//   @override
//   void initState() {
//     super.initState();
//     final _selectedDay = DateTime.now();

//     _events = {
//       /*
//       _selectedDay.subtract(Duration(days: 16)): ['Event A3'],
//       _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
//       _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
//       _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
//       _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
//       _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'], */
//     };

//     _selectedEvents = _events[_selectedDay] ?? [];
//     _calendarController = CalendarController();
//   }

//   Future<void> _onDaySelected(DateTime day, List events, List holidays) async {
//     print(day);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedDate',day.toString());
//     print(day.millisecondsSinceEpoch);
//     getTime = day.toString();
//     setState(() {
//       _selectedEvents = events;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//        appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () =>
//           // Navigator.of(context).pop(),
//           _sendDataBack(context)
//         ),
//         centerTitle: true,
//         title: Text('Calendar', style: TextStyle(color: kPrimaryDarkColor, fontSize: 18),),
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//               child: Container(
//           child: Column(
//             // mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               _buildTableCalendar(),
//               Divider(),
//               _timePicker(context),
//               SizedBox(height: 8,),
//               _buildEventList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//     Widget _buildTableCalendar() {
//       return TableCalendar(
//         calendarController: _calendarController,
//         events: _events,
//         startingDayOfWeek: StartingDayOfWeek.monday,
//         calendarStyle: CalendarStyle(
// //          selectedColor: Colors.deepOrange[400],
//           highlightToday: false,
//           todayColor: Colors.deepOrange[200],
//           markersColor: Colors.brown[700],
//           outsideDaysVisible: false,
//         ),
//         onDaySelected: _onDaySelected,
//       );
//     }

//     Widget _buildEventList() {
//       return ListView(
//         controller: _scrollController,
//           reverse: true,
//           shrinkWrap: true,
//         children: _selectedEvents
//             .map((event) => SizedBox (
//                 child: CardRow(
//                   press: () {print('$event tapped!');},
//                   time: "08.00 AM",
//                   src: "https://i.ibb.co/0h6PMY9/Piggment-volume-scale.png",
//                   content: event.toString(),
//                 )
//               ),
//             ).toList(),
//       );
//     }

//      Column _timePicker(BuildContext context) {
//     return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                 "Select time",
//                 style: TextStyle(fontSize: 18.0)
//               ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//              GestureDetector(
//               child: Text(
//                   '(${DateFormat.Hm().format(_dateTime)})',
//                   style: TextStyle(fontSize: 15.0),
//                 ),
//               onTap: (){
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context){
//                     return Container(
//                       height: 200,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               CupertinoButton(
//                                 child: Text("Cancel", style: TextStyle(color: Colors.black),),
//                                 onPressed: () {
//                                   setState(() {
//                                     _dateTime =  DateTime.now();
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               Spacer(),
//                               CupertinoButton(
//                                 child: Text("Done", style: TextStyle(color: Colors.black),),
//                                 onPressed: () async {
//                                   Navigator.pop(context);
//                                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setString('selectedTime','(${DateFormat.Hm().format(_dateTime)})');
//                                   print('(${DateFormat.Hm().format(_dateTime)})');
//                                   // getTime = '(${DateFormat.Hm().format(_dateTime)})';
//                                 },
//                               ),
//                             ],
//                           ),
//                            Expanded(
//                               child:
//                                   SizedBox(
//                                     height: 200,
//                                     child: CupertinoDatePicker(
//                                       use24hFormat: true,
//                                       initialDateTime: _dateTime,
//                                       mode: CupertinoDatePickerMode.time,
//                                       onDateTimeChanged: (dateTime){
//                                         setState(() {
//                                           _dateTime = dateTime;
//                                         });
//                                       }
//                                     ),
//                                   ),
//                             ),

//                         ],
//                       ),
//                     );
//                   }
//                 );
//               },

//             ),
//               ],
//             ),
//           ],
//         );
//   }

//   void _sendDataBack(BuildContext context) {
//     String textToSendBack = getTime.toString();
//     Navigator.pop(context, textToSendBack);
//     print(getTime);
//   }
// }
