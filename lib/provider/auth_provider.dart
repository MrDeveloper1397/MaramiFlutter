import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mil/app_config/api_config.dart';

class ProviderAuthentication extends ChangeNotifier {
  late String userdId;
  late String username;
  late String contactNumber;

  String get userId => userdId;

  String get userName => username;

  String get userNumber => contactNumber;

  Future<String> authenticateUser(http.Client http, String loginId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    // String url = "http://183.82.54.218:8080/VikyathRRR/get_Emp_data?EmpId=333";
    String url = ApiConfig.BASE_URL + ApiConfig.GET_USER_INFO + loginId;

    final response = await http.post(Uri.parse(url), headers: headers);

    var responseData = response.body.toString();

    print(
        'Checkiong Reesponse value.....${response.body}.......${responseData}');

    return responseData;
  }
}
