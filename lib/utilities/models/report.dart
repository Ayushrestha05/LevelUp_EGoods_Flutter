import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:levelup_egoods/utilities/constants.dart';

class Report with ChangeNotifier {
  List<DropdownMenuItem> decodeReportCategoryList = [];

  Report() {
    getCategories();
  }

  void getCategories() async {
    final response = await http.get(Uri.parse('$apiUrl/report-questions'));
    var decode = jsonDecode(response.body);

    decode.forEach((element) {
      decodeReportCategoryList.add(DropdownMenuItem(
        child: Text(element['question_type']),
        value: element['id'],
      ));
    });

    notifyListeners();
  }
}
