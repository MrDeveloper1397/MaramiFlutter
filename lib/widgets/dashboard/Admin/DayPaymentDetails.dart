import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/day_pay_model.dart';
import 'package:http/http.dart' as http;
import 'package:mil/widgets/dashboard/Admin/DayPayList.dart';

class DayPaymentDetails extends StatefulWidget {
  final double dayPaidAmount; //if you have multiple values add here
  final String userType;
  final String ventureCD;

  String tvDate;
  DayPaymentDetails(
      this.ventureCD, this.userType, this.dayPaidAmount, this.tvDate);

  @override
  DayPaymentDetailsState createState() => DayPaymentDetailsState();
}

@override
class DayPaymentDetailsState extends State<DayPaymentDetails> {
  // TODO: implement createState
  late List<DayPaymentModel> dayPayModel = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    dayPayModel.clear();
    listState().then((value) {
      setState(() {
        dayPayModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details (${widget.tvDate})',
            style: Theme.of(context).textTheme.overline),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Material(
        child: DayPayList(dayPayModel),
      ),
    );
  }

  Future<List<DayPaymentModel>> listState() async {
    http.Response response = await http.get(Uri.parse(ApiConfig.BASE_URL +
        'getPaymentTransations?date=' +
        widget.tvDate +
        '&VentureCd=' +
        widget.ventureCD +
        '&AccType=' +
        widget.userType));
    String body = response.body.trim();

    String dayPayDetailsApi = ApiConfig.BASE_URL +
        'getPaymentTransations?date=' +
        widget.tvDate +
        '&VentureCd=' +
        widget.ventureCD +
        '&AccType=' +
        widget.userType;
    debugPrint('Get URL.....${dayPayDetailsApi}');
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<DayPaymentModel>((json) => DayPaymentModel.fromJson(json))
        .toList();
  }
}
