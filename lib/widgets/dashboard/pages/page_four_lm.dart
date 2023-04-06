import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/SelectedPlots.dart';
import 'package:mil/models/venture_details.dart';

import '../../../models/available_plots.dart';

class Page4LM extends StatefulWidget {
  @override
  _Page4LMState createState() => _Page4LMState();
}

class _Page4LMState extends State<Page4LM> {
  final String baseURL =
      'http://realex.co.in:7777/SRLandmarkMultipleDBFlutter/AvailablePlotsFlutter';
  // ApiConfig.BASE_URL+"AvailablePlots";

  AvailablePlots? availablePlots;
  SelectedPlots? selectedPlots;
  late List<AvailablePlots> availablePlotsLst = [];
  late List<SelectedPlots> selectedPlotsLst = [];
  late List<VentureDetails> ventureDetailsList = [];

  String ventureTxt = '';
  String sectorTxt = '';
  String avlPlotsTxt = '';
  String extentTxt = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // On Page Load Get all the states from the server
    String endpoint = "$baseURL";
    listState(endpoint).then((List<AvailablePlots> value) {
      setState(() {
        availablePlotsLst.clear();
        // availablePlotsLst = Set.of(value).toList();

        value.forEach((val) {
          bool exists = availablePlotsLst
              .any((file) => file.ventureName == val.ventureName);

          if (!exists)
            availablePlotsLst
                .add(AvailablePlots(ventureName: val.ventureName.toString()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(padding: EdgeInsets.all(10)),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '  SELECT VENTURES :',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(5),
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AvailablePlots>(
                    hint: Text('Select Venture'),
                    value: availablePlots,
                    isExpanded: true,
                    items: availablePlotsLst
                        .toSet()
                        .map((AvailablePlots avlPlots) {
                      return DropdownMenuItem<AvailablePlots>(
                        value: avlPlots,
                        child: Text(avlPlots.ventureName
                            .toString()
                            .replaceAll(RegExp('[^A-Za-z0-9]'), '')),
                      );
                    }).toList(),
                    onChanged: onStateChange,
                  ),
                ))),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '  SELECT VENTURE CODE :',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
        ),
        selectedPlotsLst.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: selectedPlotsLst.isNotEmpty
                          ? DropdownButton<SelectedPlots>(
                              hint: Text('Select Venture Code'),
                              // value: availablePlots,
                              value: selectedPlots == null
                                  ? selectedPlots = null
                                  : selectedPlots,
                              isExpanded: true,
                              items: selectedPlotsLst
                                  .toSet()
                                  .map((SelectedPlots avlPlots) {
                                return DropdownMenuItem<SelectedPlots>(
                                  value: avlPlots,
                                  child: Text(avlPlots.sectorCd
                                      .toString()
                                      .replaceAll(RegExp('[^A-Za-z0-9]'), '')),
                                );
                              }).toList(),
                              onChanged: onStateChangeVC,
                            )
                          : Container(),
                    )))
            : Container(),
        InkWell(
          child: Container(
              margin: EdgeInsets.all(5),
              child: Table(
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 1),
                  children: [
                    TableRow(children: [
                      // Column(children: [
                      //   Text('Venture',
                      //       style: TextStyle(fontSize: 18.0, color: Colors.red))
                      // ]),
                      Column(children: [
                        Text('Sector',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(context).primaryColor))
                      ]),
                      Column(children: [
                        Text('Avl.Plots',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(context).primaryColor))
                      ]),
                      Column(children: [
                        Text('Extent',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(context).primaryColor))
                      ]),
                    ]),
                    TableRow(children: [
                      // Column(children: [Text(ventureTxt)]),
                      Column(children: [
                        Text(sectorTxt, style: TextStyle(fontSize: 15.0))
                      ]),
                      Column(children: [
                        Text(avlPlotsTxt, style: TextStyle(fontSize: 15.0))
                      ]),
                      Column(children: [
                        Text(extentTxt, style: TextStyle(fontSize: 15.0))
                      ]),
                    ]),
                  ])),
          onTap: () {
            setState(() {
              ventureDetailsList.clear();
              var ventureDetailsUrl = ApiConfig.GET_VACANT_PLOTS +
                  selectedPlots!.ventureCd.toString() +
                  '&&sector=' +
                  selectedPlots!.sectorCd.toString() +
                  '&dbname=' +
                  selectedPlots!.dbname.toString();

              debugPrint('Venture List api Link .......${ventureDetailsUrl}');

              getVentureDetails(ventureDetailsUrl)
                  .then((List<VentureDetails> value) {
                setState(() {
                  ventureDetailsList = value;
                  isLoading = false;
                });
              });
            });
          },
        ),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
                constraints: BoxConstraints(maxHeight: 520),
                child: SingleChildScrollView(
                    child: Stack(children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: ventureDetailsList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          height: 50,
                          width: 200,
                          child: Card(
                              elevation: 5,
                              margin: EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                                ventureDetailsList[index]
                                                    .plotNum
                                                    .toString()
                                                    .trim(),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    height: 1.2,
                                                    letterSpacing: 1.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                                ventureDetailsList[index]
                                                    .plotArea
                                                    .toString()
                                                    .trim(),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    height: 1.2,
                                                    letterSpacing: 1.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                                ventureDetailsList[index]
                                                    .facing
                                                    .toString()
                                                    .trim(),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    height: 1.2,
                                                    letterSpacing: 1.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))));
                    },
                  ),
                  isLoading
                      ? Container(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : Container(),
                ])))),
      ])),
    );
  }

  void onStateChange(vacantPlots) {
    setState(() {
      availablePlots = vacantPlots;
      ventureDetailsList.clear();
      selectedPlots = null;
    });
    listSelectVentureCode(baseURL).then((List<SelectedPlots> value) {
      setState(() {
        selectedPlotsLst = Set.of(value).toList();

        value.forEach((val) {
          // bool exists = selectedPlotsLst.any((file) => file.ventureName == availablePlots!.ventureName);

          bool exists = selectedPlotsLst.any((file) =>
              (file.ventureName == val.ventureName &&
                  file.sectorCd == val.sectorCd));

          if (!exists)
            selectedPlotsLst.add(SelectedPlots(
                ventureName: val.ventureName.toString(),
                ventureCd: val.ventureCd.toString(),
                sectorCd: val.sectorCd.toString(),
                dbname: val.dbname.toString()));
        });
        selectedPlotsLst.removeWhere(
            (element) => element.ventureName != availablePlots?.ventureName);
      });
    });
  }

  void onStateChangeVC(vacantPlots) {
    setState(() {
      // availablePlots = vacantPlots;
      selectedPlots = vacantPlots;

      ventureTxt = selectedPlots!.ventureCd.toString();
      sectorTxt = selectedPlots!.sectorCd.toString();
      avlPlotsTxt = selectedPlots!.total.toString();
      extentTxt = selectedPlots!.extend.toString();
    });
  }

  Future<List<AvailablePlots>> listState(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    Map<String, dynamic> jsonResponse = json.decode(body);
    List data = jsonResponse['Available Plots'];
    return data.map((e) => AvailablePlots.fromJson(e)).toList();
  }

  Future<List<SelectedPlots>> listSelectVentureCode(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    Map<String, dynamic> jsonResponse = json.decode(body);
    List data = jsonResponse['Available Plots'];
    return data.map((e) => SelectedPlots.fromJson(e)).toList();
  }

  Future<List<VentureDetails>> getVentureDetails(String endpoint) async {
    isLoading = true;
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<VentureDetails>((json) => VentureDetails.fromJson(json))
        .toList();
  }
}
