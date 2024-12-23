class DateRange {
  DateTime startDate;
  DateTime endDate;
  DateRange({required this.endDate, required this.startDate});

  String timeLeftString() {
    final difference = endDate.difference(startDate);

    if (difference.inDays >= 1) {
      return ("${difference.inDays} day${difference.inDays > 1 ? 's' : ''} left");
    } else if (difference.inHours >= 1) {
      return ("${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} left");
    } else if (difference.inMinutes >= 1) {
      return ("${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} left");
    } else if (difference.inSeconds >= 1) {
      return ("${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} left");
    } else {
      return ("Time is up!");
    }
  }
}
