import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/main.dart';
import 'package:mil/models/ApprovalData.dart';
import 'package:mil/models/Approvallist.dart';
import 'package:http/http.dart' as http;

import '../../ventures_list.dart';

class ApprovedMembers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ApprovedMembersData();
}

class ApprovedMembersData extends State<ApprovedMembers> {
  var loading = false;
  late bool isVentureSelect;
  late String vcd;
  List<ApprovalData> listModel = <ApprovalData>[];
  static int plistpos = 0, passbookpos = 0;
  late String flavorName;
  DateTime? selectedDate;
  String? formattedDate, tvDate;

  @override
  void initState() {
    super.initState();
    isVentureSelect = false;
    flavorName = context.read(flavorConfigProvider).state.appName;
    selectedDate = DateTime.now();
    tvDate =
        "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approved',
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      body: getFormUI(width, height),
    );
  }

  getFormUI(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      // margin: EdgeInsets.symmetric(vertical: 15.0),
      // height: 130.0,
      child: FutureBuilder<List<Approvallist>>(
        future: getApprovalList(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Approvallist> data = snapshot.data!;
            return VenturesList(data, flavorName, 'approved', false, tvDate!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Approvallist>> getApprovalList(http.Client client) async {
    String Url = ApiConfig.BASE_URL + "ApprovedProjectsList.php";
    final response = await http
        .get(Uri.parse(Url), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body.toString());
      return jsonResponse.map((job) => new Approvallist.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Approved Members Ventures List');
    }
  }
}
