//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:ui';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
  DateTime(2019, 5, 22): ['Easter Monday'],
};

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的任务',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '我的任务'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print("页面高度：" + MediaQuery.of(context).size.height.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).padding.top.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).padding.top.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).size.height.toString());
    double rowHeight1 = (MediaQuery.of(context).size.height - 8.0) / 7;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          //
          //_buildTableCalendar(),
          _buildTableCalendarWithBuilders(),
          // _buildTableCalendarWithBuilders(),
          //const SizedBox(height: 8.0),
          //Expanded(child: _buildEventList()),
          //_buildEventList()
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'zh_CN',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      //availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        //CalendarFormat.twoWeeks: '2 weeks',
        //CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    print("页面高度：" + MediaQuery.of(context).size.height.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).padding.top.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).padding.top.toString());
    print("状态栏高度：" + MediaQueryData.fromWindow(window).size.height.toString());
    // 日历与底部的距离
    double marginBotton = 8.0;
    // 日历与顶部的距离，顶部可见时添加，我们的场景是可见的。
    double marginTop = 6.0;
    // 日历内容与上下的距离
    double marginCalendar = 14.0;
    // 日历头的高度，日历头使用的是Row，默认与子项最大高度相同。
    double headerHeight = 10.0;
    double rowHeight1 = (MediaQuery.of(context).size.height - 8.0) / 7;
    double calendarHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top -
        6.0 -
        14.0 -
        20.0;
    double rowHeight = calendarHeight / 6;
    return TableCalendar(
      weekHeaderVisible: false,
      headerVisible:false,
      rowHeight: rowHeight,
      locale: 'zh_CN',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      // 内部事件是否生效，默认是全部生效。
      // 当前配置是只生效横向事件，这样外部ListView的滚动会生效。
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        //CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        //weekendStyle: TextStyle().copyWith(color: Colors.orangeAccent[800]),
        //holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          //weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
          ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.deepOrange),
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //   color: Colors.amber[400],
            width: 300,
            height: 300,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events != null) {
            children.add(
              Positioned(
                right: 10,
                bottom: 10,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays != null) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        print(date);
        //_onDaySelected(date, events);
        //_controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    for (String ev in events) {
      print(ev);
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Utils.isSameDay(date, _selectedDay)
            ? Colors.brown[500]
            : Utils.isSameDay(date, DateTime.now())
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    print('qwrtwertwert');
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
