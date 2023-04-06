import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/projects.dart';
import 'package:mil/widgets/dashboard/pages/projects_list.dart';

class Page3 extends StatelessWidget {
  var flavorType;

  Page3(this.flavorType);

  @override
  Widget build(BuildContext context) {
    String appFlavor = flavorType;
    return Container(
        color: const Color(0xffffffff),
        child: FutureBuilder<List<Projects>>(
          future: fetchProjects(http.Client(), appFlavor),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Sorry, something went wrong.',
                    style: TextStyle(color: Colors.black)),
              );
            } else if (snapshot.hasData) {
              return Container(
                  alignment: Alignment.topCenter,
                  child: ProjectsList(projects: snapshot.data!));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future<List<Projects>> fetchProjects(http.Client client, appFlavor) async {
    final response = await client.get(Uri.parse(ApiConfig.GET_CMPY_PROJECT));

    return appFlavor == 'SR Landmark'
        ? compute(parseLMProjects, response.body)
        : compute(parseProjects, response.body);
  }

  List<Projects> parseProjects(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//here getting error
    return parsed.map<Projects>((json) => Projects.fromJson(json)).toList();
  }

  FutureOr<List<Projects>> parseLMProjects(String responseBody) {
    Map<String, dynamic> jsonResponse = json.decode(responseBody);
    List data = jsonResponse['result'];
    return data.map<Projects>((json) => Projects.fromJson(json)).toList();
  }
}
