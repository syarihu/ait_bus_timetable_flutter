import 'package:ait_bus_timetable_flutter/timetable.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '愛工大シャトルバス時刻表',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '愛工大シャトルバス時刻表'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: createFutureBuilder(0),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: createFutureBuilder(1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
              bottom: new CustomTabBar(
                currentDate: "2018年4月16日（月）",
                currentTimeTable: "Aダイヤ",
                tabBar: new TabBar(
                  tabs: <Widget>[
                    new Tab(text: "愛工大ゆき"),
                    new Tab(text: "八草駅ゆき"),
                  ],
                ),
              ),
            ),
            body: new TabBarView(
              children: _pages,
            )));
  }

  static ListView createListView(List<Timetable> timetables) {
    return new ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: createDiagram(timetables),
    );
  }

  static List<Widget> createDiagram(List<Timetable> timetables) {
    List<Widget> cardList = new List();
    for (var timetable in timetables) {
      var strDiagram = "";
      switch (timetable.diagram) {
        case 0:
          strDiagram = "Aダイヤ";
          break;
        case 1:
          strDiagram = "Bダイヤ";
          break;
        case 2:
          strDiagram = "Cダイヤ";
          break;
      }
      if (strDiagram.isNotEmpty) {
        cardList.add(Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Text(strDiagram),
        ));
      }

      for (var time in timetable.times) {
        cardList.add(new Card(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(time.hour.toString() + ":" + time.minutes.toString()),
        )));
      }
    }
    return cardList;
  }

  static FutureBuilder<Destinations> createFutureBuilder(int destination) {
    return new FutureBuilder<Destinations>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return createListView(
              snapshot.data.destinations[destination].timetables);
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        // By default, show a loading spinner
        return new CircularProgressIndicator();
      },
    );
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  final String currentDate;
  final String currentTimeTable;

  CustomTabBar({this.currentDate, this.currentTimeTable, this.tabBar})
      : super();

  @override
  Size get preferredSize => new Size(0.0, 90.0);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[createCurrentStatus(), tabBar],
    );
  }

  Widget createCurrentStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        createExpanded(currentDate),
        createExpanded(currentTimeTable),
      ],
    );
  }

  Expanded createExpanded(String text) {
    return new Expanded(
      flex: 1,
      child: new Container(
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.white)),
        child: new Padding(
          padding: const EdgeInsets.all(2.0),
          child: new MaterialButton(
            onPressed: () {},
            child: new Text(
              text,
              style: new TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

Future<Destinations> fetchPost() async {
  final response = await http
      .get('http://api.syarihu.net/ait_timetable/timetables/?key=vu6iblyo8up');
  final responseJson = json.decode(response.body);

  return new Destinations.fromJson(responseJson);
}
