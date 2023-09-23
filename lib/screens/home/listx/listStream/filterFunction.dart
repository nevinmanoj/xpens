List<Map<String, dynamic>> applyFilter({required data, required filter}) {
  if (filter['itemName'] != null) {
    if (filter['itemName'] != "Other") {
      data = data.where((item) {
        return item['itemName'] == filter['itemName'];
      }).toList();
    } else {
      data = data.where((item) {
        return item['isOther'] == true;
      }).toList();
    }
  }
  if (filter['location'] != null) {
    data = data.where((item) {
      return item['location'] == filter['location'];
    }).toList();
  }
  if (filter['order'] != null) {
    if (filter['order'] == "new") {
      data.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        return int.parse(b['date'].compareTo(a['date']).toString());
      });
    } else {
      data.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        return int.parse(a['date'].compareTo(b['date']).toString());
      });
    }
  }
  // print(data[1].id);
  return data;
}
