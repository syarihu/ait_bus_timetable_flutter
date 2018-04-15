class Destinations {
  List<Destination> destinations;

  Destinations({this.destinations});

  factory Destinations.fromJson(Map<String, dynamic> json) {
    var list = List<Destination>();
    var items = json['items'] as List;
    for (var item in items) {
      list.add(new Destination.fromJson(item));
    }

    return new Destinations(destinations: list);
  }
}

class Destination {
  int destination;
  List<Timetable> timetables;

  Destination({this.destination, this.timetables});

  factory Destination.fromJson(Map<String, dynamic> json) {
    var destination = json["destination"];
    var timetables = (json["timetables"] as List)
        .map((timetable) => new Timetable.fromJson(timetable))
        .toList();
    return new Destination(destination: destination, timetables: timetables);
  }
}

class Timetable {
  int diagram;
  List<Time> times;

  Timetable({this.diagram, this.times});

  factory Timetable.fromJson(Map<String, dynamic> json) {
    var diagram = json["diagram"];
    var times =
        (json["times"] as List).map((time) => new Time.fromJson(time)).toList();
    return new Timetable(diagram: diagram, times: times);
  }
}

class Time {
  int hour;
  List<int> minutes;

  Time({this.hour, this.minutes});

  factory Time.fromJson(Map<String, dynamic> json) {
    var hour = json["hour"];
    var minutes = (json["minutes"] as List)
        .map((minute) => int.parse(minute.toString()))
        .toList();
    return new Time(hour: hour, minutes: minutes);
  }
}
