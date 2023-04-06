import 'dart:convert';

import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/main.dart';
import 'package:mil/models/PlotDistribution.dart';
import 'package:mil/models/available_plots.dart';
import 'package:mil/models/direction_choice.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/ChoiceDetails.dart';
import '../../../models/SelectedPlots.dart';

class PlotMatrix extends StatefulWidget {
  @override
  _PlotMatrixState createState() => _PlotMatrixState();
}

class _PlotMatrixState extends State<PlotMatrix> {
  // final String baseURL = ApiConfig.BASE_URL + "PlotMatrixHeaderFlutter";
  final String baseURL = ApiConfig.BASE_URL + "PlotMatrixHeader";

  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendShape? _legendShape = LegendShape.Circle;
  LegendPosition? _legendPosition = LegendPosition.right;

  AvailablePlots? availablePlots;
  SelectedPlots? selectedPlots;

  late List<AvailablePlots> plotsAvailability = [];
  late List<AvailablePlots> plotsAvailabilityNew = [];
  late Set<PlotDistribution> facingPlotsLst;

  late List<SelectedPlots> plotsAvailabilityVentureCode = [];
  late List<SelectedPlots> plotsAvailabilityVentureCodeNew = [];
  Set<SelectedPlots> setPlotVC = Set<SelectedPlots>();

  late Map<String, double> pieChartData = new Map();
  late List<PlotDistribution> ventureDetailsList = [];
  List<Choice> choices = [];
  List<ChoiceDetails> choiceDetails = [];
  // String ventureTxt = '';
  // String ventureName = '';
  String ventureCd = '';
  String sectorTxt = '';
  int totalPlots = 0;
  double extentTxt = 0.0;
  int allotedCount = 0;
  int reservedCount = 0;
  String selectionType = '';
  String reservedCountExtend = '';

  int mortgageCount = 0;
  String mortgageCountExtend = '';
  int blockedCount = 0;
  String blockedCountExtend = '';
  int registeredCount = 0;
  String registeredCountExtend = '';

  String allotedExtend = '';
  int availableCount = 0;
  String availableExtend = '';

  String blockedExtend = '';
  String registeredExtend = '';

  bool isTaped = false;
  bool isLoading = false;
  String availableStatus = '';
  String allotedStatus = '';
  String ventureCategory = '';
  String reserveStatus = '';
  String blockedStatus = '';
  String registeredStatus = '';
  String mortgageStatus = '';
  String fetchStatus = '';
  String allotedDb = '';

  List<Color> _colors = [
    Color(0XFFEF4836),
    Color(0XFF1E8BC3),
    Color(0XFF1F3A93),
    Color(0XFF913D88),
    Color(0XFF39912)
  ];

  @override
  void initState() {
    super.initState();
    // On Page Load Get all the plotsAvailability from the server

    String endpoint = "$baseURL";
    listState(endpoint).then((List<AvailablePlots> value) {
      setState(() {
        plotsAvailability = value;

        plotsAvailability.removeWhere((e) => e.ventureName == null);
        plotsAvailabilityVentureCode.clear();

        plotsAvailability = Set.of(plotsAvailability).toList();
        value.forEach((element) {
          pieChartData.addAll({
            element.status.toString() == 'N'
                ? 'Alloted'
                : element.status.toString() == 'Y'
                    ? 'Available'
                    : 'Reserved': element.total!.toDouble()
          });
        });

        value.forEach((val) {
          bool exists = plotsAvailabilityNew
              .any((file) => file.ventureName == val.ventureName);

          if (!exists)
            plotsAvailabilityNew.add(AvailablePlots(
              ventureName: val.ventureName.toString(),
              ventureCd: val.ventureCd.toString(),
              sectorCd: val.sectorCd,
              dbname: val.dbname,
            ));
        });
        choices.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            context.read(flavorConfigProvider).state.appName,
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '  SELECT VENTURES :',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                        menuMaxHeight: 300,
                        alignment: Alignment.centerLeft,
                        hint: Text(
                          'Select Venture',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor,
                        ),
                        value: availablePlots,
                        isExpanded: true,
                        items: plotsAvailabilityNew
                            .toSet()
                            .map((AvailablePlots avlPlots) {
                              return DropdownMenuItem<AvailablePlots>(
                                value: avlPlots,
                                child: Text(
                                  avlPlots.ventureName.toString(),
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              );
                            })
                            .toSet()
                            .toList(),
                        onChanged: onStateChange,
                      ),
                    ))),
            plotsAvailabilityVentureCode.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                          child: plotsAvailabilityVentureCode.isNotEmpty
                              ? DropdownButton<SelectedPlots>(
                                  menuMaxHeight: 300,
                                  alignment: Alignment.centerLeft,
                                  hint: Text(
                                    'Select Sector',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  // value: selectedPlots ,
                                  value: selectedPlots == null
                                      ? selectedPlots = null
                                      : selectedPlots,
                                  isExpanded: true,
                                  items: plotsAvailabilityVentureCode
                                      .toSet()
                                      .map((avlPlots) {
                                        return DropdownMenuItem<SelectedPlots>(
                                          value: avlPlots,
                                          child: Text(
                                            avlPlots.sectorCd.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                        );
                                      })
                                      .toSet()
                                      .toList(),
                                  onChanged: onStateChangeLoadVentures,
                                )
                              : Container(),
                        )))
                : Container(),
            isTaped == true
                ? InkWell(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Table(
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(children: [
                                Column(children: [
                                  Text('Sector',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor))
                                ]),
                                Column(children: [
                                  Text('Avl.Plots',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor))
                                ]),
                                Column(children: [
                                  Text('Extent',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor))
                                ]),
                              ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: isTaped
                                        ? Theme.of(context)
                                            .primaryColor // Background color for the row
                                            .withOpacity(0.5)
                                        : Colors
                                            .white, // To alternate between dark and light shades of the row's background color.
                                  ),
                                  children: [
                                    Column(children: [
                                      Text(sectorTxt,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)
                                    ]),
                                    Column(children: [
                                      Text(totalPlots.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)
                                    ]),
                                    Column(children: [
                                      Text(extentTxt.toStringAsFixed(2),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)
                                    ]),
                                  ]),
                            ])),
                    onTap: () {},
                  )
                : InkWell(
                    child: Container(),
                  ),
            Padding(
                padding: EdgeInsets.all(0.0),
                child: Container(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Spacer(),
                        InkWell(
                            // flex: 1,
                            child: InkWell(
                          child: Container(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: 90,
                                  height: 110,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFEF4836),
                                    border: Border.all(
                                        color: Color(0XFFEF4836), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        availableCount.toString(),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        availableExtend.toString().trim(),
                                        // 46662.000.toStringAsFixed(0),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Card(
                                            elevation: 8,
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Text(
                                                  'Alloted',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ))))),
                              ],
                            ),
                          ),
                          onTap: () {
                            loadPlotData(
                                Color(0XFFEF4836), availableStatus, allotedDb);
                          },
                        )),
                        Spacer(),
                        InkWell(
                            // flex: 1,
                            child: InkWell(
                          child: Container(
                              child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: 90,
                                height: 110,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF1E8BC3),
                                  border: Border.all(
                                      color: Color(0XFF1E8BC3), width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    Text(
                                      allotedCount.toString(),
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                    Text(
                                      allotedExtend,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                  child: Card(
                                      elevation: 8,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Text(
                                            'Available',
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          )))),
                            ],
                          )),
                          onTap: () {
                            loadPlotData(
                                Color(0XFF1E8BC3), allotedStatus, allotedDb);
                          },
                        )),
                        Spacer(),
                        InkWell(
                            // flex: 1,
                            child: InkWell(
                          child: Container(
                              child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: 90,
                                height: 110,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF1F3A93),
                                  border: Border.all(
                                      color: Color(0XFF1F3A93), width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    Text(
                                      registeredCount.toString(),
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                    Text(
                                      registeredCountExtend.toString().trim(),
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                  child: Card(
                                      elevation: 8,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Text(
                                            'Mortgage',
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          )))),
                            ],
                          )),
                          onTap: () {
                            loadPlotData(
                                Color(0XFF1F3A93), registeredStatus, allotedDb);
                          },
                        )),
                        Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Spacer(),
                        InkWell(
                            // flex: 1,
                            child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: 90,
                              height: 110,
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Color(0XFF913D88),
                                border: Border.all(
                                    color: Color(0XFF913D88), width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 25.0),
                                  Text(
                                    blockedCount.toString().trim(),
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    blockedCountExtend.toString().trim(),
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                child: Card(
                                    elevation: 8,
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Text(
                                          'Blocked',
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )))),
                          ],
                        )),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              loadPlotData(
                                  Color(0XFFF39912), reserveStatus, allotedDb);
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: 90,
                                  height: 110,
                                  margin: EdgeInsets.all(10),
                                  // padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF39912),
                                    border: Border.all(
                                        color: Color(0XFF39912), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        reservedCount.toString(),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        reservedCountExtend,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Card(
                                        elevation: 8,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              'Reserved',
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            )))),
                              ],
                            )),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              loadPlotData(
                                  Color(0XFF1BA39C), mortgageStatus, allotedDb);
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  width: 90,
                                  height: 110,
                                  margin: EdgeInsets.all(10),
                                  // padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0XFF1BA39C),
                                    border: Border.all(
                                        color: Color(0XFF1BA39C), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.0),
                                      Text(
                                        mortgageCount.toString(),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Text(
                                        mortgageCountExtend.toString().trim(),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Card(
                                        elevation: 8,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Text(
                                              'Registered',
                                              overflow: TextOverflow.visible,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            )))),
                              ],
                            )),
                        Spacer(),
                      ],
                    ),
                  ],
                ))),
            InkWell(
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    // padding: const EdgeInsets.all(4.0),

                    children: choices.map((Choice url) {
                      return GridTile(
                        child: InkWell(
                            onTap: () {
                              showPlotAvailablityList(
                                ventureCd,
                                url.status,
                                url.facing,
                                ventureCategory,
                              );
                            },
                            child: Container(
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 120,
                                    margin: EdgeInsets.all(13),
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: url.color,
                                      borderRadius: BorderRadius.circular(5),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 13.0),
                                        Text(
                                          url.total.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 7.0),
                                        Text(
                                          url.extend.toString().trim(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      child: Card(
                                          elevation: 8,
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Text(
                                                url.direction.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )))),
                                ],
                              ),
                            )),
                      );
                    }).toList())),
            pieChartData.length != 0
                ? Container(
                    child: PieChart(
                      // key: ValueKey(key),
                      dataMap: pieChartData,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: _chartLegendSpacing!,
                      chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
                          ? 300
                          : MediaQuery.of(context).size.width / 3.2,
                      colorList: _colors,
                      initialAngleInDegree: 0,
                      chartType: _chartType!,
                      centerText: _showCenterText ? '' : null,
                      legendOptions: LegendOptions(
                        showLegendsInRow: _showLegendsInRow,
                        legendPosition: _legendPosition!,
                        showLegends: _showLegends,
                        legendShape: _legendShape == LegendShape.Circle
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: _showChartValueBackground,
                        showChartValues: _showChartValues,
                        showChartValuesInPercentage:
                            _showChartValuesInPercentage,
                        showChartValuesOutside: _showChartValuesOutside,
                      ),
                      ringStrokeWidth: _ringStrokeWidth!,
                      emptyColor: Colors.grey,
                    ),
                  )
                : Container()
          ]),
        ));
  }

  late List<AvailablePlots> newList = [];

  onStateChange(AvailablePlots? avlPlots) {
    setState(() {
      availablePlots = avlPlots;
      selectedPlots = null;
    });

    String endpoint = "$baseURL";
    listState(endpoint).then((List<AvailablePlots> value) {
      setState(() {
        ventureDetailsList.clear();
        allotedCount = 0;
        availableCount = 0;
        reservedCount = 0;
        mortgageCount = 0;
        availableExtend = '';
        allotedExtend = '';

        pieChartData.clear();
        plotsAvailabilityVentureCode.clear();
        value.forEach((val) {
          bool exists = plotsAvailabilityVentureCode.any((file) =>
              (file.ventureName == val.ventureName &&
                  file.sectorCd == val.sectorCd));

          if (!exists)
            plotsAvailabilityVentureCode.add(SelectedPlots(
                ventureName: val.ventureName.toString(),
                ventureCd: val.ventureCd.toString(),
                sectorCd: val.sectorCd,
                dbname: val.dbname));
        });

        plotsAvailabilityVentureCode.removeWhere(
            (element) => element.ventureName != availablePlots?.ventureName);
      });
    });
  }

  void onStateChangeLoadVentures(vp) {
    setState(() {
      selectedPlots = vp;

      sectorTxt = vp.sectorCd.toString().trim();

      ventureCategory = vp.sectorCd.toString().trim();
    });
    String endpoint = "$baseURL";
    selectedVentureList(endpoint).then((List<SelectedPlots> value) {
      setState(() {
        ventureDetailsList.clear();
        int totalPlosCount = 0;
        double plotExtensionCount = 0.0;
        allotedCount = 0;
        availableCount = 0;
        reservedCount = 0;
        mortgageCount = 0;
        availableExtend = '';
        allotedExtend = '';

        pieChartData.clear();

        value.forEach((val) {
          if (selectedPlots!.ventureName.toString() == val.ventureName) {
            if (val.sectorCd.toString().trim() == sectorTxt) {
              totalPlosCount += val.total!;
              plotExtensionCount += double.parse(val.extend.toString());
              allotedDb = val.dbname.toString().trim();

              pieChartData.addAll({
                val.status.toString() == 'N'
                    ? 'Alloted'
                    : val.status.toString() == 'G'
                        ? 'Mortgage'
                        : val.status.toString() == 'Y'
                            ? 'Available'
                            : 'Reserved': val.total!.toDouble()
              });

              if (allotedCount == 0) {
                allotedCount = val.status == 'N' ? val.total! : 0;
                allotedExtend = val.status == 'N' ? val.extend! : '0';
                allotedStatus = 'N';
                fetchStatus = allotedStatus;
              }
              if (availableCount == 0) {
                availableCount = val.status == 'Y' ? val.total! : 0;
                availableExtend = val.status == 'Y' ? val.extend! : '0';
                availableStatus = 'Y';
                fetchStatus = availableStatus;
              }
              if (reservedCount == 0) {
                reservedCount = val.status == 'R' ? val.total! : 0;
                reservedCountExtend = val.status == 'R' ? val.extend! : '0';
                reserveStatus = 'R';
                fetchStatus = reserveStatus;
              }
              if (mortgageCount == 0) {
                mortgageCount = val.status == 'G' ? val.total! : 0;
                mortgageCountExtend = val.status == 'G' ? val.extend! : '0';
                mortgageStatus = 'G';
                fetchStatus = mortgageStatus;
              }
              if (registeredCount == 0) {
                registeredCount = val.status == 'M' ? val.total! : 0;
                registeredCountExtend = val.status == 'M' ? val.extend! : '0';
                registeredStatus = 'M';
                fetchStatus = registeredStatus;
              }
            }
          }
        });

        // ventureTxt = availablePlots!.ventureCd.toString();
        // ventureName = availablePlots!.ventureName.toString();
        ventureCd = availablePlots!.ventureCd.toString();
        // ventureCategory = availablePlots!.sectorCd.toString();
        totalPlots = totalPlosCount;
        extentTxt = plotExtensionCount;
        isTaped = true;
        choices.clear();
        choiceDetails.clear();
      });
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

  Future<List<SelectedPlots>> selectedVentureList(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<SelectedPlots>((json) => SelectedPlots.fromJson(json))
        .toList();
  }

  Future<List<PlotDistribution>> getVentureDetails(String endpoint) async {
    isLoading = true;
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<PlotDistribution>((json) => PlotDistribution.fromJson(json))
        .toList();
  }

  Future<List<ChoiceDetails>> getChoiceDetails(String endpoint) async {
    http.Response response = await http.get(Uri.parse(endpoint));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<ChoiceDetails>((json) => ChoiceDetails.fromJson(json))
        .toList();
  }

  void loadPlotData(
      Color selectedColor, String allotedAvailableStatus, String allotedDb) {
    setState(() {
      ventureDetailsList.clear();
      var ventureDetailsUrl = ApiConfig.GET_PLOT_MATRIX_ALLOTMENT +
          availablePlots!.ventureCd.toString() +
          '&Status=' +
          // availablePlots!.status.toString().trim() +
          allotedAvailableStatus +
          '&Sector=' +
          // availablePlots!.sectorCd.toString()+
          ventureCategory +
          '&db=' +
          allotedDb;

      getVentureDetails(ventureDetailsUrl).then((List<PlotDistribution> value) {
        setState(() {
          ventureDetailsList = value;
          isLoading = false;
          facingPlotsLst = Set();
          List<String> facingList = [
            'East',
            'West',
            'North',
            'South',
            'NorthEast',
            'NorthWest',
            'SouthEast',
            'SouthWest'
          ];
          for (String facing in facingList) {
            facingPlotsLst
                .add(PlotDistribution(total: 0, extend: '', fACING: facing));
          }
          for (PlotDistribution v in facingPlotsLst) {
            var contain = value.any((element) => element.fACING == v.fACING);
            if (!contain) {
              value.add(
                  PlotDistribution(total: 0, extend: '0', fACING: v.fACING));
            }
          }

          choices.clear();
          value.forEach((val) {
            choices.add((val.fACING == 'East')
                ? Choice(
                    direction: 'E ',
                    facing: val.fACING,
                    extend: val.extend,
                    total: val.total,
                    color: selectedColor,
                    status: allotedAvailableStatus)
                : (val.fACING == 'West')
                    ? Choice(
                        direction: 'W ',
                        facing: val.fACING,
                        extend: val.extend,
                        total: val.total,
                        color: selectedColor,
                        status: allotedAvailableStatus)
                    : (val.fACING == 'North')
                        ? Choice(
                            direction: 'N ',
                            facing: val.fACING,
                            extend: val.extend,
                            total: val.total,
                            color: selectedColor,
                            status: allotedAvailableStatus)
                        : (val.fACING == 'South')
                            ? Choice(
                                direction: 'S ',
                                facing: val.fACING,
                                extend: val.extend,
                                total: val.total != 0 ? val.total : 0,
                                color: selectedColor,
                                status: allotedAvailableStatus)
                            : (val.fACING == 'NorthEast')
                                ? Choice(
                                    direction: 'NE',
                                    facing: val.fACING,
                                    extend: val.extend,
                                    total: val.total,
                                    color: selectedColor,
                                    status: allotedAvailableStatus)
                                : (val.fACING == 'NorthWest')
                                    ? Choice(
                                        direction: 'NW',
                                        facing: val.fACING,
                                        extend: val.extend,
                                        total: val.total,
                                        color: selectedColor,
                                        status: allotedAvailableStatus)
                                    : (val.fACING == 'SouthEast')
                                        ? Choice(
                                            direction: 'SE',
                                            facing: val.fACING,
                                            extend: val.extend,
                                            total: val.total,
                                            color: selectedColor,
                                            status: allotedAvailableStatus)
                                        : /*(val.fACING == 'SouthWest')
                ?*/
                                        Choice(
                                            direction: 'SW',
                                            facing: val.fACING,
                                            extend: val.extend,
                                            total:
                                                val.total != 0 ? val.total : 0,
                                            color: selectedColor,
                                            status: allotedAvailableStatus));
          });

          choices.sort((a, b) => a.toString().compareTo(b.toString()));
        });
      });
    });
  }

  void showPlotAvailablityList(String ventureName, String fetchStatus,
      String? facing, String ventureCategory) {
    showLoaderDialog(context);

    var ventureDetailsUrl = ApiConfig.GET_PLOT_MATRIX_PLOTS_DETAILS +
        ventureName +
        '&Status=' +
        fetchStatus +
        '&Facing=' +
        facing! +
        '&Sector=' +
        ventureCategory +
        '&db=' +
        allotedDb;

    debugPrint('Facing Url Data.......${ventureDetailsUrl}');

    getChoiceDetails(ventureDetailsUrl).then((List<ChoiceDetails> value) {
      setState(() {
        choiceDetails.clear();

        choiceDetails = value;

        loadBottomSheet(
            value, ventureName, fetchStatus, facing, ventureCategory);
      });
    });
  }

  void loadBottomSheet(List<ChoiceDetails> choiceDetails, String ventureName,
      String allotedStatus, String? facing, String ventureCategory) {
    Navigator.pop(context);
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5),
                  child: Table(
                      // defaultColumnWidth: FixedColumnWidth(111.0),
                      columnWidths: {
                        0: FixedColumnWidth(100.0), // fixed to 100 width
                        1: FlexColumnWidth(),
                        2: FixedColumnWidth(100.0), //fixed to 100 width
                      }, children: [
                    TableRow(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        children: [
                          Column(children: [
                            Text(ventureName,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]),
                          Column(children: [
                            Text(ventureCategory,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]),
                          Column(children: [
                            Text(facing!,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]),
                          Column(children: [
                            Text(
                                allotedStatus == 'Y'
                                    ? 'Allot'
                                    : allotedStatus == 'N'
                                        ? 'Avail'
                                        : allotedStatus == 'M'
                                            ? 'Mortg'
                                            : allotedStatus == 'G'
                                                ? 'Regd'
                                                : allotedStatus == 'R'
                                                    ? 'Resvd'
                                                    : 'Blocked',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ]),
                        ]),
                  ])),
              GridView.count(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4.0),
                  children: choiceDetails.map((ChoiceDetails url) {
                    return GridTile(
                      child: Container(
                          child: InkWell(
                        onTap: () =>
                            (allotedStatus == 'N' || allotedStatus == 'R')
                                ? showPlotActionDialog(
                                    context,
                                    sectorTxt,
                                    url.plotNo.toString(),
                                    ventureName,
                                    ventureCategory,
                                    allotedStatus,
                                    allotedStatus == 'N' ? 'R' : 'N')
                                : debugPrint('Nothing to Move'),
                        child: Container(
                            child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: 100,
                              height: 120,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Color(0XFF1E8BC3),
                                border: Border.all(
                                    color: Color(0XFF1E8BC3), width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5.0),
                                  Text(
                                    url.plotNo.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    url.plotArea.toString().trim(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                      )),
                    );
                  }).toList()),
            ],
          ));
        });
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

  showPlotActionDialog(
      BuildContext context,
      String sectorTxt,
      String plotNoStr,
      String ventureName,
      String ventureCategory,
      String allotedStatus,
      actionStatus) {
    AlertDialog alertShow = AlertDialog(
      // allotedStatus == 'N'  ? 'R' :'N'
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              allotedStatus == 'N' ? Icon(Icons.lock) : Icon(Icons.lock_open),
              SizedBox(
                width: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 7),
                  child: Text(
                      allotedStatus == 'N' ? "Reserve Plot" : "Release Plot")),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(allotedStatus == 'N'
                  ? "Are you sure you want to Reserve this Plot : " + plotNoStr
                  : "Are you sure you want to Release this Plot : " +
                      plotNoStr)),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: allotedStatus == 'N'
                        ? "Plot Reserved Successfully."
                        : "Plot Released Successfully.",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey.shade50,
                    textColor: Colors.black,
                    fontSize: 16.0,
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                  reservePlot(sectorTxt, ventureCategory, plotNoStr,
                      allotedStatus, actionStatus);
                },
                child: Text(allotedStatus == 'N' ? "Reserve" : "Release"),
              ),
              Spacer(),
              InkWell(
                onTap: dismissDialog,
                child: Text("Cancel"),
              )
            ],
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alertShow;
      },
    );
  }

  reservePlot(sectorTxt, categoryId, plotNoStr, allotedStatus, actionStatus) {
    // http://183.82.126.49:7777/TriColor/changeStatus?VentureId=AE&SectorId=GEN&PlotNo=4&Status=R&Id=6dd066098ebded22b22612e619aa0437
    getUserBasicInfo(categoryId, plotNoStr, allotedStatus, actionStatus);
  }

  Future<String> getUserBasicInfo(
      sectorTxt, categoryId, plotNoStr, actionStatus) async {
    final prefs = await SharedPreferences.getInstance();

    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String pinkey = apikey!;

    debugPrint('The apiKey.....${pinkey}');
    String apicall = ApiConfig.RESERVE_PLOT_MATRIX +
        ventureCd +
        '&SectorId=' +
        sectorTxt +
        '&PlotNo=' +
        categoryId +
        '&Status=R' +
        '&Id=' +
        pinkey;
    debugPrint("apicall: ${apicall}");
    debugPrint(
        "VentureId.${ventureCd}..SectorId.${sectorTxt}..PlotNo.${categoryId}..Status.${actionStatus}..Apikey.${pinkey}");

    final response = await http.post(Uri.parse(ApiConfig.RESERVE_PLOT_MATRIX +
        ventureCd +
        '&SectorId=' +
        sectorTxt +
        '&PlotNo=' +
        categoryId +
        '&Status=' +
        actionStatus +
        '&Id=' +
        pinkey));
    if (response.statusCode == 200) {
      print(response.body);
      String data = response.body.toString();

      print("new list size: ${data}");
      return data;
    } else {
      throw Exception('Failed to load User Info');
    }
  }

  void dismissDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

enum LegendShape { Circle, Rectangle }
