import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/main.dart';
import 'package:mil/models/ReservePlotLM.dart';
import 'package:mil/models/venturesLM.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/api_config.dart';
import '../../../models/ChoiceDetails.dart';

class PlotReservationLM extends StatefulWidget {
  const PlotReservationLM({Key? key}) : super(key: key);

  @override
  State<PlotReservationLM> createState() => _PlotReservationLMState();
}

class _PlotReservationLMState extends State<PlotReservationLM> {
  final String baseURL = ApiConfig.BASE_URL + "/Get_Reg_Proj_data";
  // "http://183.82.126.49:7777//TriColorTest/Get_Reg_Proj_data";

  TextEditingController plotRegId = TextEditingController();

  List<ReservePlotLM> plotsAvailability = [];
  List<ReservePlotLM> loadSectorType = [];
  late List<ReservePlotLM> plotsSectorType = [];
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

  ReservePlotLM? availablePlots;

  String selectedsector = '';
  String dbname = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listPlotAvailability(baseURL).then((List<ReservePlotLM> value) {
      setState(() {
        plotsAvailability = value;

        plotsAvailability = Set.of(plotsAvailability).toList();

        value.forEach((val) {
          // loadSectorType = plotsAvailability.where((o) => o.ventureName == ventureName).toList();

          bool exists =
              plotsSectorType.any((file) => file.sector == val.sector);

          if (!exists)
            plotsSectorType.add(ReservePlotLM(
                ventureName: val.ventureName.toString(),
                ventureCd: val.ventureCd.toString(),
                sector: val.sector.toString(),
                dbname: val.dbname.toString()));
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
          title: Text(context.read(flavorConfigProvider).state.appName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  constraints: BoxConstraints(maxHeight: 310),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: plotsAvailability.length,
                    padding: EdgeInsets.all(8.0),
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
                                    plotsAvailability[index].dbname.toString());
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 8),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          margin: EdgeInsets.fromLTRB(
                                              15.0, 15.0, 15, 0.0),
                                          child: Text(
                                              plotsAvailability[index]
                                                  .ventureName
                                                  .toString()
                                                  .trim(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  height: 1,
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black))),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(slectedVenture,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 20,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w500))),
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text('Sector',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 20,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w500))),
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
                                              hint: Text('Select Sector'),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              items: listsectors
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: onStateChange,
                                            ),
                                          ))),
                                  SizedBox(width: 20),
                                  Expanded(
                                      child: TextFormField(
                                    maxLength: 4,
                                    keyboardType: TextInputType.text,
                                    controller: plotRegId,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        hintText: 'Enter Plot No',
                                        prefixIcon: Icon(Icons.landscape),
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder()),
                                  )),
                                ],
                              ),
                            )),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                                child: Text(
                                  'Check Plot Status',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Colors.white,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                  ),
                                ),
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
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    // elevation: 8,
                    child: Column(
                      children: [
                        Text('Plot Reservation Request',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500)),
                        Container(
                            child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        child: Text(plotRegStatusVal),
                                      ))),
                              SizedBox(width: 20),
                              Expanded(
                                  child: IconButton(
                                icon: plotStatus == 'N'
                                    ? Icon(Icons.lock)
                                    : Icon(Icons.lock_open),
                                iconSize: 50,
                                onPressed: () {
                                  debugPrint('Checking B4.....${plotStatus}');
                                  plotStatus = (plotStatus == 'R' ? 'N' : 'R');
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
      dropdownvalue = availablePlots!.sector
          .toString()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '');
    });
  }

  Future<List<AvailablePlotsLM>> listState(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<AvailablePlotsLM>((json) => AvailablePlotsLM.fromJson(json))
        .toList();
  }

  Future<List<ReservePlotLM>> listPlotAvailability(String baseURL) async {
    http.Response response = await http.get(Uri.parse(baseURL));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<ReservePlotLM>((json) => ReservePlotLM.fromJson(json))
        .toList();
  }

  void selectSectorType(String ventureName, String venturecd, String sector,
      List<String> sectors, String db) {
    setState(() {
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
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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
      child: Text("OK"),
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
      content: Text('Please enter correct plot number'),
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
