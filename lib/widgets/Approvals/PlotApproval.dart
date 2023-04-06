import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../app_config/api_config.dart';
import '../../models/PlotApprovalModel.dart';

class PlotApproval extends StatefulWidget {
  final String? passbook, joindate, applicantname, plotApproval;
  final int? plistpos, pblistpos;

  PlotApproval(
      {required this.passbook,
      required this.applicantname,
      required this.joindate,
      required this.plotApproval,
      required this.plistpos,
      required this.pblistpos});

  @override
  State<StatefulWidget> createState() => new _PlotApproval(passbook!, joindate!,
      applicantname!, plotApproval!, plistpos!, pblistpos!);
}

class _PlotApproval extends State<PlotApproval> {
  late List jsonResponse;
  String venturecd = '';
  late bool isResultReceived;
  late PlotApprovalModel model;
  String? passbook, joindate, applicantname, plotApproval;

  int? plistpos, pblistpos;
  var buttonText = 'Approval';
  TextEditingController userremarks = TextEditingController();

  bool isPressed = true;
  bool isEnabled = true;

  _PlotApproval(String mid, String date, String name, String plotApproval,
      int plistpos, int pblistpos) {
    this.passbook = mid;
    this.applicantname = name;
    this.joindate = date;
    this.plotApproval = plotApproval;
    this.plistpos = plistpos;
    this.pblistpos = pblistpos;
  }

  Future<PlotApprovalModel> getMemberApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    venturecd = prefs.getString("VentureCd").toString();
    debugPrint('Check Venture Cd .....${venturecd}');
    String Url = ApiConfig.BASE_URL +
        "PlotcostApprovaldata?PassbookNo=" +
        passbook! +
        "&VentureId=" +
        prefs.getString("VentureCd").toString();
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      setState(() {
        model = PlotApprovalModel.fromJson(list[0]);
        prefs.setString("Sector", model.sectorCd!);
        prefs.setInt("MemberId", model.memberid!);
        prefs.setString("Plotno", model.plotNo!);
        prefs.setString("PlotArea", model.plotArea!);
        isResultReceived = true;
      });
      return PlotApprovalModel.fromJson(list[0]);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // userremarks = TextEditingController();
    setState(() {
      isResultReceived = false;
      getMemberApproval();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              isResultReceived
                  ? Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: constraints.maxWidth),
                          child: Table(
                            defaultColumnWidth: FixedColumnWidth(95.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(children: [
                                Column(children: [
                                  Text('Venture',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      ))
                                ]),
                                Column(children: [
                                  Text('Sector',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      ))
                                ]),
                                Column(children: [
                                  Text('PlotNo',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      ))
                                ]),
                                Column(children: [
                                  Text('PlotArea',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      ))
                                ]),
                              ]),
                              TableRow(children: [
                                // Column(children: [Text(ventureTxt)]),
                                Column(children: [
                                  Text(venturecd!,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),
                                Column(children: [
                                  Text(model.sectorCd!.toString(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),
                                Column(children: [
                                  Text(model.plotNo!.toString(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),
                                Column(children: [
                                  Text(model.plotArea!.toString(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(),
              isResultReceived
                  ? Container(
                      margin: EdgeInsets.all(5.0),
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.minWidth),
                            child: Table(
                              defaultColumnWidth: FixedColumnWidth(125.0),
                              border: TableBorder.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1),
                              children: [
                                TableRow(children: [
                                  Text('PbNo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      )),
                                  Text('Name',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      )),
                                  Text('Date Of Join',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                        color: Colors.black,
                                      )),
                                ]),
                                TableRow(children: [
                                  // Column(children: [Text(ventureTxt)]),
                                  Text(model.memberid.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),

                                  Text(applicantname!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),

                                  Text(joindate!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                ]),
                              ],
                            ),
                          )),
                    )
                  : Center(),
              isResultReceived
                  ? Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 5,
                              child: Text('Plot Details ',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(),
              isResultReceived
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Facing                      : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   ":",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          Expanded(
                              child: Text(
                            model.fACING == null ? '' : model.fACING!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ))
                  : Center(),
              isResultReceived
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Premium                 : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   "",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          Expanded(
                              child: Text(
                            model.premium == null
                                ? "0.0"
                                : model.premium!.toString(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ))
                  : Center(),
              isResultReceived
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "PlotCategory          : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   ":",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          Expanded(
                              child: Text(
                            model.pCATEG == null
                                ? " "
                                : model.pCATEG!.toString(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ))
                  : Center(),
              isResultReceived
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Spl.Premium          : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   ":",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          Expanded(
                              child: Text(
                            model.spPremium == null
                                ? "0.0"
                                : model.spPremium!.toString(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ))
                  : Center(),

//not for approved members
              isPlotApproved(plotApproval.toString())
                  ? Center()
                  : Container(
                      padding: new EdgeInsets.only(top: 15.0, left: 5),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text('Remarks',
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
              isPlotApproved(plotApproval.toString())
                  ? Center()
                  : Container(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          ElevatedButton(
                            // style: ElevatedButton.styleFrom(
                            //   fixedSize: size,
                            //   padding: const EdgeInsets.zero,
                            //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // ),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20),
                                primary: isPressed ? Colors.red : Colors.green,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                )),

                            onPressed: () {
                              //for clicking button u need to write the api
                              setState(() {
                                isPressed = !isPressed;
                                buttonText = "Approved";
                              });
                              onChangeApproval(
                                      userremarks.text.trim().toString(),
                                      "Plot",
                                      model.memberid.toString(),
                                      venturecd!)
                                  .then((responseData) {
                                if (responseData == 'Success') {
                                  userremarks.clear();
                                  setState(() {
                                    // _isDisable = true;
                                    ApiConfig.utiPassbookList[pblistpos!]
                                        .plotApproval = "Y";
                                  });
                                }
                              });
                            },
                            child: Text(buttonText,
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                    controller: userremarks,
                                    decoration: InputDecoration(
                                      //Add th Hint text here.
                                      hintText: "Enter Remarks",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        height: 1,
                                      ),
                                      border: OutlineInputBorder(),
                                    ))),
                          )
                        ],
                      )),

              isPlotApproved(plotApproval.toString())
                  ? Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Image.asset(
                            'assets/images/ic_fragment_approved.png',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                          new Text('Approved',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              )),
                        ],
                      ),
                    )
                  : Center(),
            ],
          ),
        ),
      ),
    );
  }

  bool isPlotApproved(String plotApproval) {
    if (plotApproval == "Y") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> onChangeApproval(
      String remarks, String param, String memberid, String venture) async {
    String passbook = memberid;
    String venturtecd = venture;
    // String passbook= ApiConfig.utiPassbookList[pblistpos!].memberId.toString();
    //  String venturtecd=ApiConfig.utiplistdata[plistpos!].ventureCd.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String Url = ApiConfig.BASE_URL +
        "UpdateApprovalData.php?PassbookNo=" +
        passbook +
        "&VentureId=" +
        venturtecd +
        "&Remarks=" +
        remarks +
        "&Activity=" +
        param +
        "&ApiKey=" +
        apikey!;
    final response = await http
        .get(Uri.parse(Url), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      String data = response.body.toString();
      return data;
    } else {
      throw Exception('Failed to Change Plot Approval Update');
    }
    // fPlotApprovalPresenter.onChangeApproval(plistpos, pblistpos, remarks, "Plot");
  }
}
