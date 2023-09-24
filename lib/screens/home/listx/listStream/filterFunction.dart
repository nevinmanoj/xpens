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
  if (filter['query'] != null) {
    var data1 = filterDataLocally1(data, "tags", filter['search']);
    if (data1.isEmpty) {
      var data2 = filterDataLocally2(data, filter['query']);

      data = data2;
    } else {
      data = data1;
    }
  }

  return data;
}

List<Map<String, dynamic>> filterDataLocally1(
    List<Map<String, dynamic>> data, String fieldName, List<dynamic> values) {
  // Filter data based on the arrayContainsAny-like logic
  List<Map<String, dynamic>> filteredData = data.where((item) {
    dynamic fieldValue = item[fieldName];
    if (fieldValue is List) {
      return values.every((value) => fieldValue.contains(value));
    }
    return false;
  }).toList();
  if (filteredData.isEmpty) {
    filteredData = data.where((item) {
      dynamic fieldValue = item[fieldName];
      if (fieldValue is List) {
        return values.any((value) => fieldValue.contains(value));
      }
      return false;
    }).toList();
  }

  return filteredData;
}

List<Map<String, dynamic>> filterDataLocally2(
    List<Map<String, dynamic>> data, String query) {
  List<Map<String, dynamic>> filteredData = [];
  for (int i = 0; i < data.length; i++) {
    if (data[i]['itemName'].toLowerCase().contains(query.toLowerCase())) {
      filteredData.add(data[i]);
    }
  }

  return filteredData;
}
