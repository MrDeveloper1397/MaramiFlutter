import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/DayCollection.dart';
import 'package:http/http.dart' as http;
import 'package:mil/widgets/dashboard/Admin/DayCollectionDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DayCollectionWidget extends StatefulWidget {
  const DayCollectionWidget({Key? key}) : super(key: key);

  @override
  _DayCollection createState() => _DayCollection();
}

class _DayCollection extends State<DayCollectionWidget> {
  List<DayCollectionList> dayCollectionList = [];
  late Set<String> dayCollectionVentures = {};
  DateTime? selectedDate;
  String? formattedDate, tvDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDate = DateTime.now();
      tvDate =
          '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
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
          title: Text(
            'Day Collection (${tvDate!})',
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: FutureBuilder<List<DayCollection>>(
                      future: getDayCollectionDetails(tvDate!),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('An error has occurred! Fail',
                                style: Theme.of(context).textTheme.headline3),
                          );
                        } else if (snapshot.hasData) {
                          List<DayCollection> data = snapshot.data!;

                          if (data.length > 0) {
                            for (int i = 0; i < data.length; i++) {
                              dayCollectionList.add(DayCollectionList(
                                  title:
                                      snapshot.data![i].ventureName.toString(),
                                  ventureCode:
                                      snapshot.data![i].venturecd.toString(),
                                  acnumb: snapshot.data![i].acnumb.toString(),
                                  dayPaidAmount: double.parse(
                                      data[i].recAmount.toString()),
                                  icon: Icons.add));
                            }

                            data.forEach((e) {
                              dayCollectionVentures
                                  .add(e.ventureName.toString().trim());
                            });

                            DayCollectionList sumDayCollection =
                                dayCollectionList.reduce((value, element) =>
                                    DayCollectionList(
                                        title: 'Sum Total',
                                        ventureCode: element.ventureCode,
                                        dayPaidAmount: value.dayPaidAmount +
                                            element.dayPaidAmount,
                                        icon: Icons.add,
                                        acnumb: element.acnumb));

                            DayCollectionList sumDayCollectionSingleVenture =
                                dayCollectionList.reduce((value, element) =>
                                    DayCollectionList(
                                        title: element.title,
                                        ventureCode: element.ventureCode,
                                        dayPaidAmount:
                                            element.title == value.title
                                                ? value.dayPaidAmount +
                                                    element.dayPaidAmount
                                                : 0,
                                        icon: Icons.add,
                                        acnumb: element.acnumb));

                            debugPrint(
                                'sumDayCollectionSingleVenture Title ${sumDayCollectionSingleVenture.title} & Sum ${sumDayCollectionSingleVenture.dayPaidAmount}');

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                new Text(
                                  'Day Collection',
                                  style: new TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                                new Text(
                                  '\u{20B9} ${sumDayCollection.dayPaidAmount.toString()}',
                                  style: new TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                ),
                                new ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  // itemCount: data.length,
                                  itemCount: dayCollectionVentures.length,
                                  itemBuilder: (context, i) {
                                    return new ExpansionTile(
                                      title: Text(
                                          dayCollectionVentures.elementAt(i),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Roboto-Light',
                                            fontSize: 16.0,
                                            letterSpacing: 1,
                                            height: 1.5,
                                          )),
                                      children: <Widget>[
                                        Container(
                                          color: Theme.of(context).primaryColor,
                                          child: new Column(
                                            children: _buildExpandableContent(
                                                dayCollectionList,
                                                dayCollectionVentures
                                                    .elementAt(i),
                                                dayCollectionVentures),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          } else
                            return Center(
                              child: Text('No Data Found',
                                  style: Theme.of(context).textTheme.headline3),
                            );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Icon(Icons.calendar_today),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  Future<List<DayCollection>> getDayCollectionDetails(String tvDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);

    String dayCOlApi = ApiConfig.BASE_URL +
        'getDaycollectionByDate?ApiKey=' +
        apikey!.trimLeft() +
        '&date=' +
        tvDate;

    debugPrint('Get URL.....${dayCOlApi}');

    dayCollectionList.clear();
    dayCollectionVentures.clear();
    http.Response response = await http.get(Uri.parse(dayCOlApi));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<DayCollection>((json) => DayCollection.fromJson(json))
        .toList();
  }

  List<Widget> _buildExpandableContent(
          List<DayCollectionList> dayCollectionList,
          String ventureName,
          Set<String> dayCollectionVentures) =>
      List<Widget>.generate(
          dayCollectionList.length,
          (index) => dayCollectionList[index].title == ventureName
              ? ListTile(
                  title: Row(
                    children: [
                      Text(
                        // '${getPaymentType(dayCollectionList[index].acnumb)} ',
                        '${dayCollectionList[index].acnumb} ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontSize: 16.0,
                          // fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\u{20B9}  ${dayCollectionList[index].dayPaidAmount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Light',
                          fontSize: 16.0,
                          // fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  leading: new Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DayCollectionDetails(
                              dayCollectionList[index].title,
                              dayCollectionList[index].ventureCode,
                              dayCollectionList[index].acnumb,
                              getPaymentType(dayCollectionList[index].acnumb),
                              dayCollectionList[index].dayPaidAmount,
                              tvDate!))),
                )
              : Container());

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
            '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
        getDayCollectionDetails(tvDate.toString().trim());
      });
  }

  getPaymentType(String acnumb) {
    switch (int.parse(acnumb)) {
      case 1000:
        return 'Cash';
      case 10000:
        return 'Adjustment';
      default:
        return 'Bank';
    }
  }
}

class DayCollectionList {
  String title = '';
  String ventureCode = '';
  double dayPaidAmount = 0.0;
  String acnumb = '';
  IconData icon = const IconData(0xe800);

  DayCollectionList(
      {required this.title,
      required this.ventureCode,
      required this.acnumb,
      required this.dayPaidAmount,
      required this.icon});
}
