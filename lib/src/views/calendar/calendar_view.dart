// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:walk/src/constants/app_color.dart';

// class CalendarEvents extends StatefulWidget {
//   final Map<DateTime, dynamic> kEvents;
//   final DateTime kFirstDay;
//   final DateTime kLastDay;
//   const CalendarEvents(
//       {super.key,
//       required this.kEvents,
//       required this.kFirstDay,
//       required this.kLastDay}); // Constructor to receive kEvents

//   @override
//   State<CalendarEvents> createState() => _CalendarEventsState();
// }

// class _CalendarEventsState extends State<CalendarEvents> {
//   late final ValueNotifier<List<int>> _selectedEvents;
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   List<int> _getEventsForDay(DateTime day) {
//     return widget.kEvents[day] ?? []; // Access kEvents from widget
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//       });

//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         iconTheme: const IconThemeData(
//           color: AppColor.blackColor,
//         ),
//         title: const Text(
//           'Calendar - Events',
//           style: TextStyle(
//             color: AppColor.blackColor,
//             fontSize: 19,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               color: AppColor.lightgreen,
//               borderRadius: BorderRadius.all(
//                 Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: TableCalendar<int>(
//                 firstDay: widget.kFirstDay,
//                 lastDay: widget.kLastDay,
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 calendarFormat: _calendarFormat,
//                 headerStyle: const HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                 ),
//                 eventLoader: _getEventsForDay,
//                 startingDayOfWeek: StartingDayOfWeek.monday,
//                 calendarStyle: const CalendarStyle(
//                   outsideDaysVisible: false,
//                   todayDecoration: BoxDecoration(
//                       color: Color.fromARGB(255, 0, 133, 111),
//                       shape: BoxShape.circle),
//                   selectedDecoration: BoxDecoration(
//                       color: AppColor.greenDarkColor, shape: BoxShape.circle),
//                 ),
//                 onDaySelected: _onDaySelected,
//                 onPageChanged: (focusedDay) {
//                   setState(() {
//                       _focusedDay = focusedDay; // Update _focusedDay
//                     });
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: ValueListenableBuilder<List<int>>(
//               valueListenable: _selectedEvents,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: ListTile(
//                         // ignore: avoid_print
//                         onTap: () => print('${value[index]}'),
//                         title: Text('${value[index]}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
