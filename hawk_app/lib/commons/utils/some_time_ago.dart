import 'package:date_format/date_format.dart';
import 'package:timeago/timeago.dart' as timeago;

getTimeAgo(DateTime time) {
  return timeago.format(time);
}

getChatTime(DateTime time) {
  var difference = DateTime.now().difference(time);

  if (difference.inMinutes < 60) {
    return timeago.format(time);
  }

  if (difference.inHours < 24) {
    return formatDate(time, [HH, ':', nn]);
  }

  if (difference.inHours < 48) {
    return "Yesterday ${formatDate(time, [HH, ':', nn])}";
  }

  if (difference.inDays < 7) {
    return formatDate(time, [D, " ", HH, ':', nn]);
  }

  return formatDate(time, [yyyy, '/', mm, '/', dd]);
}
