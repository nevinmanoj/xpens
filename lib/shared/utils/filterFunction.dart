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
  if (filter['query'] != null && filter['queryType'] != null) {
    List data1 = [];
    String value = filter['query'];
    if (filter["queryType"] == "itemName" || filter["queryType"] == "remark") {
      final List<String> tags = value
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map((word) => word.toLowerCase())
          .toList();
      data1 = filterDataLocally1(data,
          filter['queryType'] == "itemName" ? "tags" : "remarkTags", tags);
    }

    if (data1.length < 5) {
      List data2 = filterDataLocally2(data, value, filter['queryType']);

      data = [...data1, ...data2];
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

List filterDataLocally2(List data, String query, String fieldName) {
  List filteredData = [];
  for (int i = 0; i < data.length; i++) {
    if (data[i][fieldName].toLowerCase().contains(query.toLowerCase())) {
      filteredData.add(data[i]);
    }
  }

  return filteredData;
}
