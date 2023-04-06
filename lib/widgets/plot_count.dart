import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/venture_details.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:share_extend/share_extend.dart';

import '../models/PlotDistribution.dart';

class PlotCount extends StatelessWidget {
  List<VentureDetails> searchVentureDetails;
  String ventureCode;

  late Set<PlotDistribution> facingPlotsLst;
  late List<PlotDistribution> ventureDetailsList = [];
  bool isLoading = false;

  PlotCount({
    required this.ventureCode,
    required this.searchVentureDetails,
  });

  List<Choice> choices = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var countEast =
        searchVentureDetails.where((c) => c.facing == 'East')?.toList() ?? [];

    var toalEastFacings = countEast.reduce((value, element) => VentureDetails(
        plotNum: element.plotNum,
        facing: element.facing,
        plotArea:
            (double.parse(value.plotArea) + double.parse(element.plotArea))
                .toString()));

    var countWest =
        searchVentureDetails.where((c) => c.facing == 'West')?.toList() ?? [];

    var toalWestFacings = countWest.length > 0
        ? countWest?.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', facing: 'West', plotArea: '0');

    var countNorth =
        searchVentureDetails.where((c) => c.facing == 'North')?.toList() ?? [];

    var toalNorthFacings = countNorth.length > 0
        ? countNorth?.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', facing: 'North', plotArea: '0');

    var countSouth =
        searchVentureDetails.where((c) => c.facing == 'South')?.toList() ?? [];

    var toalSouthFacings = countSouth.length > 0
        ? countSouth.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', facing: 'South', plotArea: '0');

    var countSouthEast =
        searchVentureDetails.where((c) => c.facing == 'SouthEast')?.toList() ??
            [];

    var toalSouthEastFacings = countSouthEast.length > 0
        ? countSouthEast.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', plotArea: '0', facing: 'SouthEast');

    var countSouthWest =
        searchVentureDetails.where((c) => c.facing == 'SouthWest')?.toList() ??
            [];

    var toalSouthWestFacings = countSouthWest.length > 0
        ? countSouthWest.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', plotArea: '0', facing: 'SouthWest');

    var countNorthWest =
        searchVentureDetails.where((c) => c.facing == 'NorthWest')?.toList() ??
            [];

    var toalNorthWestFacings = countNorthWest.length > 0
        ? countNorthWest.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', plotArea: '0', facing: 'NorthWest');

    var countNorthEast =
        searchVentureDetails.where((c) => c.facing == 'NorthEast')?.toList() ??
            [];

    var toalNorthEastFacings = countNorthEast.length > 0
        ? countNorthEast.reduce((value, element) => VentureDetails(
            plotNum: element.plotNum,
            facing: element.facing,
            plotArea:
                (double.parse(value.plotArea) + double.parse(element.plotArea))
                    .toString()))
        : VentureDetails(plotNum: '0', facing: 'NorthEast', plotArea: '0');

    choices = <Choice>[
      Choice(
          title: 'E',
          count: countEast.length,
          area: toalEastFacings!.plotArea,
          facingList: countEast,
          facing: 'East'),
      Choice(
          title: 'W',
          count: countWest.length,
          area: toalWestFacings!.plotArea,
          facingList: countWest,
          facing: 'West'),
      Choice(
          title: 'N',
          count: countNorth.length,
          area: toalNorthFacings!.plotArea,
          facingList: countNorth,
          facing: 'North'),
      Choice(
          title: 'S',
          count: countSouth.length,
          area: toalSouthFacings.plotArea,
          facingList: countSouth,
          facing: 'South'),
      Choice(
          title: 'SE',
          count: countSouthEast.length,
          area: toalSouthEastFacings!.plotArea,
          facingList: countSouthEast,
          facing: 'SouthEast'),
      Choice(
          title: 'SW',
          count: countSouthWest.length,
          area: toalSouthWestFacings!.plotArea,
          facingList: countSouthWest,
          facing: 'SouthWest'),
      Choice(
          title: 'NE',
          count: countNorthEast.length,
          area: toalNorthEastFacings!.plotArea,
          facingList: countNorthEast,
          facing: 'NorthEast'),
      Choice(
          title: 'NW',
          count: countNorthWest.length,
          area: toalNorthWestFacings!.plotArea,
          facingList: countNorthWest,
          facing: 'NorthWest'),
    ];

    return Column(
      children: [
        Container(
            height: 200,
            child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                children: List.generate(choices.length, (index) {
                  return Center(
                    child: InkWell(
                        // flex: 1,
                        child: InkWell(
                      onTap: () => loadFacingList(choices[index].facingList,
                          choices[index].facing, context),
                      child: Container(
                          child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 90,
                            height: 150,
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
                                SizedBox(height: 15.0),
                                Text(
                                  choices[index].count.toString(),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 1.0),
                                Text(
                                  double.parse(choices[index].area)
                                      .toStringAsFixed(2),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 13,
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
                                        choices[index].title,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )))),
                        ],
                      )),
                    )),
                  );
                }))),
      ],
    );
  }

  loadFacingList(
      List<VentureDetails> facingList, plotFacing, BuildContext context) {
    // facingList.forEach((element) =>  debugPrint(element.facing + ' => '+element.plotNum),);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          Widget cancelButton = ElevatedButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
            /*  onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) =>  Page4())),*/
          );
          Widget launchButton = ElevatedButton(
            child: Text("Share"),
            onPressed: () {
              generatePDF(ventureCode, plotFacing).then((valuePDFPath) {
                createFolder('Tri Colour Properties').then((valueDirPath) =>
                    generatePDFnShare(valueDirPath, valuePDFPath, ventureCode)
                        .then((value) async {
                      Directory dir = await getApplicationDocumentsDirectory();
                      File testFile = new File("${value}");
                      if (!await testFile.exists()) {
                        await testFile.create(recursive: true);
                        testFile
                            .writeAsStringSync("test for share documents file");
                      }
                      ShareExtend.share(testFile.path, "file");
                    }));
              });

              //
            },
          );

          return Dialog(
            shape: BeveledRectangleBorder(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Vacant List'),
                Container(
                    child: Card(
                  elevation: 5,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                                // ventureDetailsList[index]
                                'Plot No',
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 10.0),
                            child: Text(
                                // ventureDetailsList[index]
                                'Facing',
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                                // ventureDetailsList[index]
                                'Plot Area',
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                setupAlertDialoadContainer(facingList, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [launchButton, cancelButton],
                )
              ],
            ),
          );
        });
  }

  Widget setupAlertDialoadContainer(facingList, context) {
    return Expanded(
        child: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: facingList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Container(
              height: 50,
              width: 200,
              child: Card(
                  elevation: 5,
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                    // ventureDetailsList[index]
                                    facingList[index].plotNum.toString().trim(),
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                    // ventureDetailsList[index]
                                    facingList[index].facing.toString().trim(),
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                    // ventureDetailsList[index]
                                    facingList[index]
                                        .plotArea
                                        .toString()
                                        .trim(),
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            ),
                          ],
                        ),
                      ))));
        },
      ),
    ));
  }

  loadFacingListItems(List<VentureDetails> facingList, BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
                child: Card(
              elevation: 5,
              // margin: EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            // ventureDetailsList[index]
                            'Plot No',
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            // ventureDetailsList[index]
                            'Facing',
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            // ventureDetailsList[index]
                            'Plot Area',
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                  ],
                ),
              ),
            ))),
      ],
    );
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

  Future<String> generatePDF(String ventureCode, plotFacing) async {
    String url = ApiConfig.BASE_URL +
        '/generateVacantPDFNew.php?Venture=' +
        ventureCode +
        '&Facing=' +
        plotFacing;
    http.Response response = await http.get(Uri.parse(url));
    String body = response.body;
    debugPrint('API Link Sharepdf with facing......$url');

    return body;
  }

  Future<String> generatePDFnShare(
      String fileName, String valuePDFPath, String ventureCode) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = '${ApiConfig.BASE_URL}' + '/' + valuePDFPath;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        DateTime now = new DateTime.now();
        var formatter = new DateFormat('dd-MMM-yyyy');
        String formattedDate = formatter.format(now);

        filePath =
            '$fileName' + ' ' + ventureCode + '_' + formattedDate + '.pdf';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}

Future<String> createFolder(String ventureName) async {
  final dir = Directory((Platform.isAndroid
              ? await getExternalStorageDirectory() //FOR ANDROID
              : await getApplicationSupportDirectory() //FOR IOS
          )!
          .path +
      '/$ventureName');
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await dir.exists())) {
    return dir.path;
  } else {
    dir.create();
    return dir.path;
  }
}

class Choice {
  Choice(
      {required this.title,
      required this.count,
      required this.area,
      required this.facingList,
      required this.facing});
  final String title;
  final int count;
  final String area;
  final String facing;
  final List<VentureDetails> facingList;
}
