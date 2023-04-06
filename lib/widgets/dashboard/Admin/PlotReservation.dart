import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mil/models/ReservePlot.dart';
import 'package:mil/models/ventures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/api_config.dart';
import '../../../models/ChoiceDetails.dart';

class PlotReservation extends StatefulWidget {
  const PlotReservation({Key? key}) : super(key: key);

  @override
  State<PlotReservation> createState() => _PlotReservationState();
}

class _PlotReservationState extends State<PlotReservation> {
  final String baseURL = ApiConfig.BASE_URL + "/Get_Reg_Proj_data";
  // "http://183.82.126.49:7777//TriColorTest/Get_Reg_Proj_data";

  TextEditingController plotRegId = TextEditingController();

  List<ReservePlot> plotsAvailability = [];
  List<ReservePlot> loadSectorType = [];
  late List<ReservePlot> plotsSectorType = [];
  List<String> listsectors = [];

  // Initial Selected Value
  String dropdownvalue = '';
  String slectedVenture = '';
  String ventureSector = '';
  String slectedVentureCd = '';
  String plotStatus = '';
  String plotRegStatusVal = '';

  bool visibleSectorLayout = false;
  bool visibleBlockLayout = false;

  String rmSPLChar = "#@F&L^&%U##T#T@#ER###CA@#@M*(PU@&#S%^%2324@*(^&";

  ReservePlot? availablePlots;

  String selectedsector = '';
  String dbname = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listPlotAvailability(baseURL).then((List<ReservePlot> value) {
      setState(() {
        plotsAvailability = value;

        plotsAvailability = Set.of(plotsAvailability).toList();

        value.forEach((val) {
          // loadSectorType = plotsAvailability.where((o) => o.ventureName == ventureName).toList();

          bool exists =
              plotsSectorType.any((file) => file.sector == val.sector);

          if (!exists)
            plotsSectorType.add(ReservePlot(
                ventureName: val.ventureName.toString(),
                ventureCd: val.ventureCd.toString(),
                sector: val.sector.toString()));
        });
      });
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
            'Plot Reservation Request',
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  constraints: BoxConstraints(maxHeight: 140),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: plotsAvailability.length,
                    padding: EdgeInsets.only(top: 20),
                    // padding: EdgeInsets.fromLTRB(8, 20, 8, 20),
                    physics: const BouncingScrollPhysics(
                        // parent: AlwaysScrollableScrollPhysics()
                        ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          decoration: BoxDecoration(
                            border: index == 0
                                ? const Border() // This will create no border for the first item
                                : Border(
                                    // top: BorderSide(
                                    //     width: 1,
                                    //     color: Colors
                                    //         .black26)
                                    ), // This will create top borders for the rest
                          ),
                          child: InkWell(
                              onTap: () {
                                debugPrint(
                                    'Checking split.....${plotsAvailability[index].sector!.split(",")}');
                                final List<String> sectors =
                                    plotsAvailability[index].sector!.split(",");
                                debugPrint(
                                    'Checking String to list.....${plotsAvailability[index].sector!.split(",")}');
                                listsectors.clear();
                                selectSectorType(
                                    plotsAvailability[index]
                                        .ventureName
                                        .toString()
                                        .trim(),
                                    plotsAvailability[index]
                                        .ventureCd
                                        .toString()
                                        .trim(),
                                    plotsAvailability[index]
                                        .sector!
                                        .split(",")
                                        .toString(),
                                    sectors,
                                    plotsAvailability[index].toString());
                                //  .trim(),plotsAvailability[index].sector!.split(",").toString(),sectors,plotsAvailability[index].dbname.toString());
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          height: 70,
                                          width: 150,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 8),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 20.0, 5.0, 20.0),
                                          child: Text(
                                              plotsAvailability[index]
                                                  .ventureName
                                                  .toString()
                                                  .trim(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Roboto',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5,
                                              ))),
                                    ),
                                  ],
                                ),
                              )));
                    },
                  )),
              Visibility(
                  visible: visibleSectorLayout,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // elevation: 20,
                    margin: EdgeInsets.fromLTRB(10, 40, 10, 40),
                    elevation: 25,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(slectedVenture,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontFamily: 'Roboto',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text('Sector',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontFamily: 'Roboto',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ))),
                                ],
                              ),
                            ),
                            Container(
                                child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    maxLength: 4,
                                    keyboardType: TextInputType.text,
                                    controller: plotRegId,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: 'Enter Plot No. ',
                                      hintStyle:
                                          Theme.of(context).textTheme.headline3,

                                      // prefixIcon: Icon(Icons.landscape),
                                      contentPadding: EdgeInsets.all(14),
                                    ),
                                  )),
                                  SizedBox(width: 20),
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                /* color: Theme.of(context)
                                                    .primaryColor,*/
                                                color: Colors.black,
                                              ),
                                              /*  value: availablePlots,
                                          isExpanded: true,*/
                                              items: listsectors
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3,
                                                  ),
                                                );
                                              }).toList(),
                                              hint: Text(
                                                selectedsector,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3,
                                              ),
                                              onChanged: onStateChange,
                                            ),
                                          ))),
                                ],
                              ),
                            )),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'CHECK PLOT STATUS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    textStyle:
                                        Theme.of(context).textTheme.overline),
                                onPressed: () => {
                                      setState(() {
                                        checkPlotStatus(
                                                slectedVentureCd,
                                                selectedsector,
                                                plotRegId.text
                                                    .toString()
                                                    .trim(),
                                                dbname)
                                            .then((value) {
                                          if (value == 'error')
                                            showAlertDialog(context);
                                          else {
                                            setState(() {
                                              plotStatus = value;
                                              visibleBlockLayout = true;
                                            });
                                          }
                                        });
                                      })
                                    }),
                            SizedBox(height: 20.0),
                          ],
                        )),
                  )),
              Visibility(
                  visible: visibleBlockLayout,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // elevation: 20,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      elevation: 25,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        // elevation: 8,
                        child: Column(
                          children: [
                            Text('PLOT RESERVATION REQUEST',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                )),
                            Container(
                                child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Container(
                                              child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              plotRegStatusVal
                                                  .toString()
                                                  .trim()
                                                  .toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                            ),
                                          )))),
                                  SizedBox(width: 20),
                                  Expanded(
                                      child: IconButton(
                                    icon: plotStatus == 'N'
                                        ? Icon(Icons.lock)
                                        : Icon(Icons.lock_open),
                                    iconSize: 50,
                                    onPressed: () {
                                      debugPrint(
                                          'Checking B4.....${plotStatus}');

                                      plotStatus =
                                          (plotStatus == 'R' ? 'N' : 'R');

                                      /* if(plotStatus == 'R'){

                                    plotStatus = 'N';

                                }else {

                                    plotStatus = 'R';

                                }*/

                                      debugPrint(
                                          'Checking After.....${plotStatus}');

                                      reservePlotBooking(
                                              slectedVentureCd,
                                              selectedsector,
                                              plotRegId.text.toString().trim(),
                                              plotStatus,
                                              dbname)
                                          .then((value) {
                                        setState(() {
                                          plotRegStatusVal = value.toString();
                                        });
                                      });
                                    },
                                  )),
                                ],
                              ),
                            ))
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }

  void onStateChange(vacantPlots) {
    setState(() {
      selectedsector = vacantPlots;

      // dropdownvalue = availablePlots!.sector.toString().replaceAll(RegExp('[^A-Za-z0-9]'), '');
    });
  }

  Future<List<AvailablePlots>> listState(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<AvailablePlots>((json) => AvailablePlots.fromJson(json))
        .toList();
  }

  Future<List<ReservePlot>> listPlotAvailability(String baseURL) async {
    http.Response response = await http.get(Uri.parse(baseURL));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<ReservePlot>((json) => ReservePlot.fromJson(json))
        .toList();
  }

  void selectSectorType(String ventureName, String venturecd, String sector,
      List<String> sectors, String db) {
    setState(() {
      selectedsector = '';
      slectedVenture = ventureName;
      ventureSector = sector;
      slectedVentureCd = venturecd;
      listsectors = sectors;
      visibleSectorLayout = true;
      dbname = db;
    });
  }

  Future<String> checkPlotStatus(String slectedVenture, String ventureSector,
      String plotRegId, String db) async {
    final prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String pinkey = apikey!;

    debugPrint(
        'Checking Before url.....${(ApiConfig.BASE_URL + 'plotstatus.php?VentureId=' + slectedVenture + '&SectorId=' + ventureSector + '&PlotNo=' + plotRegId + '&Id=' + pinkey + "&db=" + db)}');
    http.Response response = await http.get(Uri.parse(ApiConfig.BASE_URL +
        'plotstatus.php?VentureId=' +
        slectedVenture +
        '&SectorId=' +
        ventureSector +
        '&PlotNo=' +
        plotRegId +
        '&Id=' +
        pinkey +
        "&db=" +
        db));

    String body = response.body.toString().trim();

    return body != "" ? body : 'error';
  }

  Future<List<ChoiceDetails>> getChoiceDetails(String endpoint) async {
    // isLoading = true;
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<ChoiceDetails>((json) => ChoiceDetails.fromJson(json))
        .toList();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline3,
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // AlertDialog(title: Text('Please enter correct plot number'));

    // Create button
    Widget okButton = ElevatedButton(
      child: Text(
        "OK",
        style: Theme.of(context).textTheme.headline3,
      ),
      onPressed: () {
        setState(() {
          visibleBlockLayout = false;
        });
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Alert"),
      content: Text(
        'Please enter correct plot number',
        style: Theme.of(context).textTheme.headline3,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> reservePlotBooking(
      String slectedVenture,
      String slectedVentureType,
      String plotNoRegId,
      String plotStatus,
      String dbname) async {
    final prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String pinkey = apikey!;

    http.Response response = await http.get(Uri.parse(ApiConfig.BASE_URL +
        'changeStatus?VentureId=' +
        slectedVenture +
        '&SectorId=' +
        slectedVentureType +
        '&PlotNo=' +
        plotNoRegId +
        '&Status=' +
        plotStatus +
        '&Id=' +
        pinkey +
        "&db=" +
        dbname));
    String body = response.body.toString().trim();

    return body != "" ? body : 'error';
  }
}
