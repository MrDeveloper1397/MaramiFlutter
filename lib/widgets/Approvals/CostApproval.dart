import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/PlotApprovalModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CostApproval extends StatefulWidget {
  final String? passbook, joindate, applicantname, costApproval;
  final int? plistpos, pblistpos;

  CostApproval(
      {required this.passbook,
      required this.applicantname,
      required this.joindate,
      required this.costApproval,
      required this.plistpos,
      required this.pblistpos});

  @override
  State<StatefulWidget> createState() => new CostApprovalState(passbook!,
      joindate!, applicantname!, costApproval!, plistpos!, pblistpos!);
}

class CostApprovalState extends State<CostApproval> {
  late List jsonResponse;
  String venturecd = '';
  late PlotApprovalModel model;
  double payaableAmount = 0.0;
  late bool isResultReceived;
  int? plistpos, pblistpos;
  String passbook = '', joindate = '', applicantname = '', costApproval = '';
  TextEditingController userremarks = TextEditingController();
  bool _isDisable = false;
  bool isPressed = true;
  var buttonText = 'Approval';

  CostApprovalState(String mid, String date, String name, String costApproval,
      int plistpos, int pblistpos) {
    this.passbook = mid;
    this.applicantname = name;
    this.joindate = date;
    this.costApproval = costApproval;
    this.plistpos = plistpos;
    this.pblistpos = pblistpos;
  }

  Future<PlotApprovalModel> getMemberApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    venturecd = prefs.getString("VentureCd")!;
    String Url = ApiConfig.BASE_URL +
        "PlotcostApprovaldata?PassbookNo=" +
        passbook! +
        "&VentureId=" +
        prefs.getString("VentureCd")!;
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      setState(() {
        model = PlotApprovalModel.fromJson(list[0]);
        isResultReceived = true;
      });
      return model;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    isResultReceived = false;
    getMemberApproval();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              isResultReceived
                  ? Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.minWidth),
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
                                  Column(children: [
                                    Text('PbNo',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          height: 1.8,
                                          color: Colors.black,
                                        ))
                                  ]),
                                  Column(children: [
                                    Text('Name',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          height: 1.8,
                                          color: Colors.black,
                                        ))
                                  ]),
                                  Column(children: [
                                    Text('Date Of Join',
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
                                  Column(children: [
                                    Text(model.memberid.toString(),
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Roboto',
                                            height: 1.8,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal))
                                  ]),
                                  Column(children: [
                                    Text(applicantname!.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Roboto',
                                            height: 1.8,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal))
                                  ]),
                                  Column(children: [
                                    Text(joindate!,
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
                                  child: Text('Cost Details ',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                      )))),
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
                            "Rate Per Sq.Yards                   :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.ratePerSq!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Plot Cost                                   :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '\u{20B9} ${model.totalCost!}',
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Admin Fee                                :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.adminFee!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Premium                                   :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.premium! == null
                                ? "0.0"
                                : model.premium!.toString(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Spl.Premium                            :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.spPremium! == null
                                ? "0.0"
                                : model.spPremium!.toString(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Dev Charges                             :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.devCharges!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "BSP6                                          :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.bsp6!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Carpus Fund                             :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.carpusFund!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Others                                        :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            model.others!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Total Cost                                  :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '\u{20B9} ${model.totalCost!}',
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Total Paid                                  :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '\u{20B9} ${model.paidAmount.toString()}',
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
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
                            "Payable Amount                      :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '\u{20B9} ${(double.parse(model.totalCost.toString()) - double.parse(model.paidAmount.toString())).toString()}',
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      ))
                  : Center(),

              //not for approved members
              isCostApproved(costApproval.toString())
                  ? Center()
                  : Container(
                      padding: new EdgeInsets.only(top: 13.0, left: 5),
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
              isCostApproved(costApproval.toString())
                  ? Center()
                  : Container(
                      padding: new EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          ElevatedButton(
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
                              setState(() {
                                isPressed = !isPressed;
                                buttonText = "Approved";
                              });
                              onChangeApproval(
                                      userremarks.text.trim().toString(),
                                      "Cost",
                                      model.memberid.toString(),
                                      venturecd!)
                                  .then((responseData) {
                                if (responseData == 'Success') {
                                  userremarks.clear();
                                  setState(() {
                                    ApiConfig.utiPassbookList[pblistpos!]
                                        .plotCostApproval = "Y";
                                    _isDisable = true;
                                  });
                                  /*   b1.setBackgroundColor(Color.parseColor("#ff669900"));
                               b1.setText("Approved");
                               b1.setEnabled(false);*/
                                }
                              });
                              //for clicking button u need to write the api
                            },
                            child: Text(buttonText,
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
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
              //

              isCostApproved(costApproval.toString())
                  ? Container(
                      padding: new EdgeInsets.only(top: 14.0),
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

  bool isCostApproved(String costApproval) {
    if (costApproval == "Y") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> onChangeApproval(
      String remarks, String param, String memberid, String venture) async {
    String passbook = memberid;
    String venturtecd = venture;
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
      throw Exception('Failed to Change Cost Approval Update');
    }
  }
}
