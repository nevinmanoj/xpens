// ignore_for_file: file_names

double calcCardpoints(
    {required DateTime? start,
    required DateTime end,
    required var data,
    required String card}) {
  var filteredData = data.where((element) => element['cardName'] == card);
  double sum = 0;
  if (start != null) {
    //limited points
    filteredData = filteredData.where((doc) =>
        DateTime.parse(doc['date']).isAfter(start) &&
        DateTime.parse(doc['date']).isBefore(end));
  }

  for (var d in filteredData) {
    sum += d['points'];
  }

  return sum;
}
