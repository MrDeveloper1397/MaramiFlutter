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

class DayBookings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DayBookings();
}

class _DayBookings extends State<DayBookings> {
  late bool isVentureSelect;
  late String vcd;
  List<ApprovalData> listModel = <ApprovalData>[];
  List<Approvallist> listVentures = <Approvallist>[];
  var loading = false;
  DateTime? selectedDate;
  late bool isEmptyResponse;
  String? formattedDate, tvDate;
  static int plistpos = 0, passbookpos = 0;
  late String flavorName;

  @override
  void initState() {
    super.initState();
    flavorName = context.read(flavorConfigProvider).state.appName;
    isVentureSelect = false;
    setState(() {
      isEmptyResponse = false;
      selectedDate = DateTime.now();
      tvDate =
          "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
    });
    getApprovalList(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Day Bookings ($tvDate)',
              style: Theme.of(context).textTheme.overline),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: FutureBuilder<List<Approvallist>>(
            future: getApprovalList(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Approvallist> data = snapshot.data!;
                if (data.length == 0) {
                  return Center(
                      child: Text("No Bookings done for the day",
                          style: Theme.of(context).textTheme.headline3));
                } else {
                  return VenturesList(
                      data, flavorName, 'dayBookings', false, tvDate!);
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Icon(Icons.calendar_today),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tvDate =
            "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
      });
  }

  void showSnackbar(BuildContext context, String responseData) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(responseData),
      backgroundColor: Colors.red,
    ));
  }

  Future<List<Approvallist>> getApprovalList(http.Client client) async {
    String Url =
        ApiConfig.BASE_URL + "getBooked_plots?date=" + tvDate.toString();
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      setState(() {
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        listVentures = parsed
            .map<Approvallist>((json) => Approvallist.fromJson(json))
            .toList();
        loading = false;
      });
      return listVentures;
    } else {
      throw Exception('Failed to load day bookings Ventures List');
    }
  }
}
