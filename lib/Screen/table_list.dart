import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_ver/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_demo_ver/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_ver/Screen/main.dart';


class Tabless extends StatefulWidget {
  @override
  _TableList createState() {
    return _TableList();
  }
}

class _TableList extends State<Tabless> {
  final List<String> testsss = ['hello', "dfsa", "wrteh"];
  Map<DateTime, List<Event>> selectedEvents;
  TextEditingController _eventController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  bool check = false;
  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  Widget taskList(String title, String description, BuildContext contexts) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.white,
            size: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(contexts).size.width * 0.8,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: (TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(description,
                    style: (TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('food').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildall(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildall(BuildContext context, List<DocumentSnapshot> snapshot){
    Size size = MediaQuery.of(context).size;


    List<Container> massageWis = [];

    for(var message in snapshot){
      final messageWi = taskList(message.data()['name'],message.data()['num'].toDate().toString(),context);
      massageWis.add(messageWi);
    }

    return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              TableCalendar(
                firstDay: DateTime.utc(1990),
                lastDay: DateTime.utc(2030),
                focusedDay: DateTime.now(),
                onDaySelected: (DateTime selectDay, DateTime focusDay){
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                  print(focusedDay);
                },
                selectedDayPredicate: (DateTime date){
                  return isSameDay(selectedDay,date);
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.arrow_left),
                  rightChevronIcon: Icon(Icons.arrow_right),
                  titleTextStyle: const TextStyle(fontSize: 20.0),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  weekendTextStyle:
                  TextStyle(fontSize: 12).copyWith(color: Colors.red),
                  holidayTextStyle:
                  TextStyle(fontSize: 12).copyWith(color: Colors.red),
                ),

                locale: 'ko-KR',
                eventLoader: _getEventsfromDay,
              ),..._getEventsfromDay(selectedDay).map((Event event) => ListTile(title: Text(event.title),)),
              SizedBox(height: size.height * 0.05),
              Container(
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )),
                        Column(
                          children: massageWis,
                        )

                        /*
                        Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.length,
                                itemBuilder: (BuildContext context, int index){
                                  return taskList(snapshot.toString(), "hihihi", context);
                                })
                        ),*/

                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    kPrimaryColor.withOpacity(0),
                                    kPrimaryColor
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ])),
                        )),
                    Positioned(
                      bottom: 30,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Add Event"),
                            content: TextFormField(
                              controller: _eventController,
                            ),
                            actions: [
                              TextButton(
                                child: Text("취소"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text("확인"),
                                  onPressed: () {
                                    if (_eventController.text.isEmpty) {
                                    } else {
                                      if (selectedEvents[selectedDay] != null) {
                                        selectedEvents[selectedDay].add(Event(
                                            title: _eventController.text));
                                      }else {
                                        selectedEvents[selectedDay] = [Event(title: _eventController.text)];
                                      }
                                    }
                                    Navigator.pop(context);
                                    _eventController.clear();
                                    setState(() {});
                                    return;
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}
