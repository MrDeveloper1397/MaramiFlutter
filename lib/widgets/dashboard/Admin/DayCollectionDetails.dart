import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/day_coll_model.dart';
import 'package:http/http.dart' as http;
import 'package:mil/widgets/dashboard/Admin/DayCollList.dart';

class DayCollectionDetails extends StatefulWidget {
  final double dayPaidAmount; //if you have multiple values add here
  final String userType;
  final String ventureCD;
  final String ventureName;
  final String ventureCdType;

  String tvDate;
  DayCollectionDetails(this.ventureName, this.ventureCD, this.userType,
      this.ventureCdType, this.dayPaidAmount, this.tvDate);

  @override
  DayCollectionDetailsState createState() => DayCollectionDetailsState();
}

@override
class DayCollectionDetailsState extends State<DayCollectionDetails> {
  // TODO: implement createState
  late List<DayCollectionModel> dayCollModel = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    dayCollModel.clear();
    listState().then((value) {
      setState(() {
        dayCollModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collection Details (${widget.tvDate})',
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.overline,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: new EdgeInsets.only(top: 35.0),
            color: Theme.of(context).primaryColor,
            height: 130.0,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Text(
                  widget.ventureName.toString() +
                      '->' +
                      widget.ventureCdType.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto-Light',
                    fontSize: 20.0,
                    // fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                Text(
                  '\u{20B9} ${widget.dayPaidAmount.toString()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto-Light',
                    fontSize: 20.0,
                    // fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                )
              ],
            ),
          ),
          Container(height: 580, child: DayCollList(dayCollModel))
        ],
      )),
    );
  }

  Future<List<DayCollectionModel>> listState() async {
    http.Response response = await http.get(Uri.parse(ApiConfig.BASE_URL +
        'getCollectionTransations?' +
        'venture=' +
        widget.ventureCD +
        '&acctype=' +
        widget.userType +
        '&date=' +
        widget.tvDate));
    String body = response.body.trim();
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<DayCollectionModel>((json) => DayCollectionModel.fromJson(json))
        .toList();
  }
}
