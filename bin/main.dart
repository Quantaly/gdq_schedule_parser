import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

void main() async {
  var response = await http.get("https://gamesdonequick.com/schedule");
  var document = html.parse(response.body);

  print("BEGIN:VCALENDAR");
  print("VERSION:2.0");
  print("X-WR-CALNAME:${document.querySelector("h1").text}");
  print("X-WR-CALDESC:Autogenerated from https://gamesdonequick.com/schedule");

  var runTable = document.querySelector("#runTable");
  for (var secondRow in runTable.querySelectorAll(".second-row")) {
    var firstRow = secondRow.previousElementSibling;
    var firstRowIter = firstRow.nodes.iterator;
    firstRowIter..moveNext()..moveNext();
    var startTime = DateTime.parse(firstRowIter.current.text);
    firstRowIter..moveNext()..moveNext();
    var game = firstRowIter.current.text;
    firstRowIter..moveNext()..moveNext();
    var runners = firstRowIter.current.text;
    var secondRowIter = secondRow.nodes.iterator;

    secondRowIter..moveNext()..moveNext();
    var duration = parseDuration(secondRowIter.current.text);
    secondRowIter..moveNext()..moveNext();
    var category = secondRowIter.current.text;
    secondRowIter..moveNext()..moveNext();
    var host = secondRowIter.current.text.substring(1);

    var uid = (game + runners + category).hashCode;
    var endTime = startTime.add(duration);

    print("BEGIN:VEVENT");
    print("UID:$uid@gamesdonequick.com");
    print("DTSTAMP:${formatIcalDateTime(startTime)}");
    print("DTSTART:${formatIcalDateTime(startTime)}");
    print("DTEND:${formatIcalDateTime(endTime)}");
    print("SUMMARY:$game");
    print("DESCRIPTION:$category by $runners - hosted by $host");
    print("END:VEVENT");
  }

  print("END:VCALENDAR");
}

Duration parseDuration(String rawDuration) {
  var stripped = rawDuration.substring(1, rawDuration.length - 1);
  var components = stripped.split(":");
  return Duration(
      hours: int.parse(components[0]),
      minutes: int.parse(components[1]),
      seconds: int.parse(components[2]));
}

String formatIcalDateTime(DateTime dateTime) {
  var ret = StringBuffer();
  ret
    ..write(padNumber(dateTime.year, 4))
    ..write(padNumber(dateTime.month, 2))
    ..write(padNumber(dateTime.day, 2))
    ..write("T")
    ..write(padNumber(dateTime.hour, 2))
    ..write(padNumber(dateTime.minute, 2))
    ..write(padNumber(dateTime.second, 2))
    ..write("Z");
  return ret.toString();
}

String padNumber(int number, int spaces) =>
    number.toString().padLeft(spaces, "0");
