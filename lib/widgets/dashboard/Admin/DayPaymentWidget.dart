import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/DayPayment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DayPaymentDetails.dart';

class DayPaymentWidget extends StatefulWidget {
  const DayPaymentWidget({Key? key}) : super(key: key);

  @override
  _DayPayment createState() => _DayPayment();
}

class _DayPayment extends State<DayPaymentWidget> {

  List<DayPaymentList> dayPaymentList = [];
  DateTime? selectedDate;
  String? formattedDate, tvDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // isEmptyResponse = false;
      selectedDate = DateTime.now();
      tvDate = "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Day Payments (${tvDate})', style: Theme.of(context).textTheme.overline,),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // background image and bottom contents
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 20, 0, 0),
                child: FutureBuilder<List<DayPayment>>(
                  future: getDayPaymentDetails(tvDate!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('An error has occurred! Fail',style: Theme.of(context).textTheme.headline3),
                      );
                    } else if (snapshot.hasData) {
                      List<DayPayment> data = snapshot.data!;
                      if(data.length > 0) {
                        for (int i = 0; i < data.length; i++) {
                          dayPaymentList.add(DayPaymentList(
                              title: snapshot.data![i].vENTURECD.toString(),
                              contents: [snapshot.data![i].userType.toString()],
                              dayPaidAmount:
                              double.parse(data[i].total.toString()),
                              icon: Icons.add));
                        }

                        DayPaymentList sumDayCollection = dayPaymentList
                            .reduce((value, element) => DayPaymentList(
                            title: 'Sum Total',
                            dayPaidAmount:
                            value.dayPaidAmount + element.dayPaidAmount,
                            icon: Icons.add,
                            contents: []));

                        return Column(
                          children: [
                            new Text(
                              'Total Payments',
                              style: new TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ),
                            new Text(
                              '\u{20B9}${sumDayCollection.dayPaidAmount.toString()}',
                              style: new TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ),
                            new ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, i) {
                                return new ExpansionTile(
                                  title: Row(
                                    children: [
                                      new Text(
                                          dayPaymentList[i].title,
                                          style: Theme.of(context).textTheme.headline3
                                      ),
                                      Spacer(),
                                      new Text(
                                          '\u{20B9}${dayPaymentList[i].dayPaidAmount.toString()}',
                                          style: Theme.of(context).textTheme.headline3
                                      ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    InkWell(
                                      onTap : (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            DayPaymentDetails(dayPaymentList[i].title, dayPaymentList[i].contents[0],dayPaymentList[i].dayPaidAmount, tvDate!)));
                                      },
                                      child: Container(
                                        child: new Column(
                                          children: _buildExpandableContent(
                                              dayPaymentList[i]),
                                        ),
                                      ),
                                    )

                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }
                      else return Center(
                        child: Text('No Data Found',
                            style: Theme.of(context).textTheme.headline3),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            _selectDate(context);
          },
          child: Icon(Icons.calendar_today),
          backgroundColor: Theme.of(context).primaryColor,
        )
    );
  }

  Future<List<DayPayment>> getDayPaymentDetails(String tvDate) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);

    String dayPayApi = ApiConfig.BASE_URL+'GetPaymentsData?ApiKey='+apikey!.trimLeft()+'&date='+tvDate;

    debugPrint('Get URL.....${dayPayApi}');

    dayPaymentList.clear();
    http.Response response = await http.get(Uri.parse(dayPayApi));
    String body = response.body.trim();
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<DayPayment>((json) => DayPayment.fromJson(json))
        .toList();
  }

  _buildExpandableContent(DayPaymentList paymentInfo) {
    List<Widget> columnContent = [];
    // columnContent.clear();
    for (String content in paymentInfo.contents)
      columnContent.add(
        new ListTile(
          title: new Text(
            content,
            style: new TextStyle(fontSize: 18.0),
          ),
          leading: new Icon(paymentInfo.icon),
        ),
      );
    return columnContent;
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
        getDayPaymentDetails(tvDate.toString().trim());
      });
  }
}

class DayPaymentList {
  final String title;
  final double dayPaidAmount;
  List<String> contents = [];
  final IconData icon;

  DayPaymentList({required this.title, required this.contents, required this.dayPaidAmount, required this.icon});
}