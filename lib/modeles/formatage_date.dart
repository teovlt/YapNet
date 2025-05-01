import 'package:intl/intl.dart';

class FormatageDate {
  String formatted(int timestamps) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timestamps);
    DateTime now = DateTime.now();
    DateFormat format;

    if (now.difference(postTime).inDays > 0) {
      format = DateFormat.yMMMd();
    } else {
      format = DateFormat.Hm();
    }

    return format.format(postTime).toString();
  }
}
