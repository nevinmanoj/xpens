class DateRange {
  DateTime startDate;
  DateTime endDate;
  DateRange({required this.endDate, required this.startDate});

  String timeLeftString() {
    DateTime today = DateTime.now();
    bool started = today.isAfter(startDate);
    String endingmsg = started ? "left" : "to start";
    final difference = endDate.difference(today);

    if (difference.inDays > 1) {
      return ("${difference.inDays} day${difference.inDays > 1 ? 's' : ''} $endingmsg");
    } else if (difference.inHours > 1) {
      return ("${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} $endingmsg");
    } else if (difference.inMinutes > 1) {
      return ("${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} $endingmsg");
    } else if (difference.inSeconds > 1) {
      return ("${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} $endingmsg");
    } else {
      return ("Time is up!");
    }
  }
}
