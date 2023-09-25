List applyFilter({required data, required filter}) {
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
      data.sort((a, b) {
        return int.parse(b['date'].compareTo(a['date']).toString());
      });
    } else {
      data.sort((a, b) {
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

List filterDataLocally1(List data, String fieldName, List<dynamic> values) {
  // Filter data based on the arrayContainsAny-like logic
  List filteredData = data.where((item) {
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

List filterDataLocally2(List data, String query) {
  List filteredData = [];
  for (int i = 0; i < data.length; i++) {
    if (data[i]['itemName'].toLowerCase().contains(query.toLowerCase())) {
      filteredData.add(data[i]);
    }
  }

  return filteredData;
}
