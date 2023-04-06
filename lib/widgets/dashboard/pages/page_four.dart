import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/venture_details.dart';
import 'package:mil/models/SelectedPlots.dart';
import 'package:mil/widgets/plot_count.dart';
import 'package:share_extend/share_extend.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../main.dart';
import '../../../models/available_plots.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final String baseURL = ApiConfig.BASE_URL + "AvailablePlots";

  TextEditingController searchFacingController = TextEditingController();

  AvailablePlots? availablePlots;
  SelectedPlots? selectedPlots;

  late List<AvailablePlots> availablePlotsLst = [];
  late List<SelectedPlots> selectedPlotsLst = [];
  late List<AvailablePlots> states = [];
  late List<VentureDetails> ventureDetailsList = [];
  List<VentureDetails> searchVentureDetails = [];
  List<VentureDetails> searchVentures = [];

  String ventureTxt = '';
  String sectorTxt = '';
  String avlPlotsTxt = '';
  String extentTxt = '';

  bool isLoading = false;
  bool isTaped = false;

  @override
  void initState() {
    super.initState();
    searchVentureDetails.clear();
    // On Page Load Get all the states from the server
    String endpoint = "$baseURL";
    listState(endpoint).then((List<AvailablePlots> value) {
      setState(() {
        //states = value;
        {
          availablePlotsLst.clear();
          // availablePlotsLst = Set.of(value).toList();

          value.forEach((val) {
            bool exists = availablePlotsLst
                .any((file) => file.ventureName == val.ventureName);

            if (!exists)
              availablePlotsLst
                  .add(AvailablePlots(ventureName: val.ventureName.toString()));
          });
        }
      });
    });

    searchVentureDetails.addAll(ventureDetailsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 5)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '  Select Venture :',
                style: TextStyle(color: Colors.black, fontSize: 18),
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
                        value: availablePlots,
                        hint: Text(
                          'Select Venture',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        isExpanded: true,
                        items: availablePlotsLst
                            .toSet()
                            .map((AvailablePlots avlPlots) {
                          return DropdownMenuItem<AvailablePlots>(
                            value: avlPlots,
                            child: Text(avlPlots.ventureName.toString(),
                                // .replaceAll(RegExp('[^A-Za-z0-9]'), ''),
                                style: Theme.of(context).textTheme.headline3),
                          );
                        }).toList(),
                        onChanged: onStateChange,
                      ),
                    ))),
            selectedPlotsLst.isNotEmpty
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
                          child: selectedPlotsLst.isNotEmpty
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
                                  value: selectedPlots == null
                                      ? selectedPlots = null
                                      : selectedPlots,
                                  isExpanded: true,
                                  items: selectedPlotsLst
                                      .toSet()
                                      .map((SelectedPlots avlPlots) {
                                    return DropdownMenuItem<SelectedPlots>(
                                      value: avlPlots,
                                      child: Text(
                                        avlPlots.sectorCd.toString().replaceAll(
                                            RegExp('[^A-Za-z0-9]'), ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: onStateChangeVC,
                                )
                              : Container(),
                        )))
                : Container(),
            selectedPlots != null
                ? Column(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              isTaped = true;
                              ventureDetailsList.clear();
                              searchVentures.clear();
                              searchVentureDetails.clear();
                              var ventureDetailsUrl =
                                  ApiConfig.GET_VACANT_PLOTS +
                                      selectedPlots!.ventureCd.toString() +
                                      '&&sector=' +
                                      selectedPlots!.sectorCd.toString();
                              '&dbname=' + selectedPlots!.dbname.toString();

                              getVentureDetails(ventureDetailsUrl)
                                  .then((List<VentureDetails> value) {
                                setState(() {
                                  ventureDetailsList = value;
                                  searchVentures.addAll(ventureDetailsList);
                                  searchVentureDetails.addAll(searchVentures);
                                  isLoading = false;
                                });
                              });
                            });
                          },
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
                                                color: Colors.black))
                                      ]),
                                      Column(children: [
                                        Text('Avl.Plots',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black))
                                      ]),
                                      Column(children: [
                                        Text('Extent',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black))
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
                                          // Column(children: [Text(ventureTxt)]),
                                          Column(children: [
                                            Text(sectorTxt,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3)
                                          ]),
                                          Column(children: [
                                            Text(avlPlotsTxt,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3)
                                          ]),
                                          Column(children: [
                                            Text(extentTxt,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3)
                                          ]),
                                        ]),
                                  ]))),
                      //search list from row.
                    ],
                  )
                : Container(),
            searchVentureDetails.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: PlotCount(
                        ventureCode: selectedPlots!.ventureCd.toString(),
                        searchVentureDetails: searchVentureDetails),
                  )
                : Container(),
            searchVentureDetails.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        generatePDF(selectedPlots!.ventureCd.toString())
                            .then((valuePDFPath) {
                          createFolder(context
                                  .read(flavorConfigProvider)
                                  .state
                                  .flavourName)
                              .then((valueDirPath) => generatePDFnShare(
                                          valueDirPath,
                                          valuePDFPath,
                                          selectedPlots!.ventureCd.toString())
                                      .then((value) async {
                                    File testFile = new File("${value}");
                                    if (!await testFile.exists()) {
                                      await testFile.create(recursive: true);
                                      testFile.writeAsStringSync(
                                          "test for share documents file");
                                    }
                                    ShareExtend.share(testFile.path, "file");
                                  }));
                        });
                      });
                    },
                    child: Text('Share All Facings data'))
                : Container()
          ])),
    );
  }

  Future<String> generatePDF(String ventureCode) async {
    String parseURL = ApiConfig.BASE_URL +
        '/generateVentureFacingPDF.php?Venture=' +
        ventureCode;
    debugPrint('API Link......${parseURL}');
    http.Response response = await http.get(Uri.parse(parseURL));
    String body = response.body;

    return body;
  }

  void onStateChange(vacantPlots) {
    setState(() {
      availablePlots = vacantPlots;
      ventureDetailsList.clear();
      searchVentures.clear();
      searchVentureDetails.clear();
      selectedPlots = null;
      isTaped = false;
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
    // http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/TriColor/GetVacantList.php?ventureid=HW&sector=GEN'));

    //http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/Googee/GoogeeNew/PlotMatrixFacingData?Venture=10&Status=N&Sector=GEN'));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<VentureDetails>((json) => VentureDetails.fromJson(json))
        .toList();
  }

  void searchPlotInVenture(String searchingValue) {
    if (searchingValue.isNotEmpty) {
      List<VentureDetails> dummySearchListData = [];
      searchVentures.forEach((item) {
        if (item.plotNum.toLowerCase().contains(searchingValue.toLowerCase()) ||
            item.facing.toLowerCase().contains(searchingValue.toLowerCase()) ||
            item.plotArea.contains(searchingValue)) {
          dummySearchListData.add(item);
        }
      });
      setState(() {
        searchVentureDetails..clear();
        searchVentureDetails.addAll(dummySearchListData);
      });
      return;
    } else {
      setState(() {
        searchVentureDetails.clear();
        searchVentureDetails.addAll(ventureDetailsList);
      });
    }
  }

  Future<String> createFolder(String cow) async {
    final dir = Directory((Platform.isAndroid
                ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationSupportDirectory() //FOR IOS
            )!
            .path +
        '/$cow');
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
