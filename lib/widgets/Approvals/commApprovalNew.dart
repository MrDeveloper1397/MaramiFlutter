import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/TotalCommission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CommissionApproval extends StatefulWidget {
  final String? passbook, joindate, applicantname, commissionApproval;
  final int? plistpos, pblistpos;

  CommissionApproval(
      {required this.passbook,
      required this.applicantname,
      required this.joindate,
      required this.commissionApproval,
      required this.plistpos,
      required this.pblistpos});

  @override
  State<StatefulWidget> createState() => CommissionApprovalState(passbook!,
      joindate!, applicantname!, commissionApproval!, plistpos!, pblistpos!);
}

class CommissionApprovalState extends State<CommissionApproval> {
  bool isPressed = true;
  var buttonText = 'Approval';
  late TotalCommission model2;
  String? passbook, applicantName, date, commissionApproval;
  late List jsonResponse;
  int? memberid;
  String? venturecd, commonCalc, sector, plotno, plotarea;
  late bool isResultRecived;
  int? plistpos, pblistpos;
  TextEditingController userremarks = TextEditingController();
  TextEditingController commController = TextEditingController();
  TextEditingController discController = TextEditingController();

  bool _isDisable = false;
  bool isLoading = false;

  double totsum = 0.0;
  double payble = 0.0;
  bool istotCommission = false;

  List<dynamic> list = [];
  List<TotalCommission> finallist = [];

  CommissionApprovalState(String passbook, String applicantname,
      String joindate, String commissionApproval, int plistpos, int pblistpos) {
    this.passbook = passbook;
    this.applicantName = applicantname;
    this.date = joindate;
    this.commissionApproval = commissionApproval;
    this.plistpos = plistpos;
    this.pblistpos = pblistpos;
  }

  Future<List<TotalCommission>> getCommissionApproval() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    venturecd = prefs.getString("VentureCd");
    commonCalc = prefs.getString("CommonCalc");
    String Url = ApiConfig.BASE_URL +
        "getCommissiondata.php?VentureId=" +
        venturecd! +
        "&PassbookNo=" +
        passbook! +
        "&CommCalc=" +
        commonCalc!;
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      list = json.decode(response.body).cast<Map<String, dynamic>>();
      setState(() {
        sector = prefs.getString("Sector");
        memberid = prefs.getInt("MemberId");
        plotno = prefs.getString("Plotno");
        plotarea = prefs.getString("PlotArea");
        isResultRecived = true;
        for (int i = 0; i < list.length; i++) {
          model2 = TotalCommission.fromJson(list[i]);
          totsum += double.parse(model2.grossPayable.toString());
          if (model2.discount == '') {
            discController.text = '0.0';
            ApiConfig.Totalcom += payble;
          } else {
            payble -= double.parse(model2.discount.toString());
            ApiConfig.Totalcom += payble;
            discController.text =
                "" + double.parse(model2.discount.toString()).toString();
          }
        }
        if (commonCalc == 'A') {
          commController.text = 'Comm[@sq]';
        } else {
          commController.text = 'Comm[%]';
        }
        if (list.length == 0) {
          istotCommission = false;
        } else {
          istotCommission = true;
          finallist = list
              .map<TotalCommission>((data) => TotalCommission.fromJson(data))
              .toList();
        }

        debugPrint('Commission List .......${finallist}');
        isLoading = false;
      });
      return finallist;
    } else {
      throw Exception('Failed to load Commission Data');
    }
  }

  bool toggle = true;

  @override
  void initState() {
    isResultRecived = false;
    getCommissionApproval();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(children: [
            isResultRecived
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
                                Text(sector!,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        height: 1.8,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal))
                              ]),
                              Column(children: [
                                Text(plotno!,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        height: 1.8,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal))
                              ]),
                              Column(children: [
                                Text(plotarea!,
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
            isResultRecived
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
                                  SizedBox(
                                    height: 2,
                                    width: 2,
                                  ),
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
                                // Column(children: [Text(ventureTxt)]),
                                Column(children: [
                                  Text(memberid!.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),

                                Column(children: [
                                  Text(date!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Roboto',
                                          height: 1.8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal))
                                ]),

                                Column(children: [
                                  Text(applicantName!.toUpperCase(),
                                      textAlign: TextAlign.center,
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
            //total commission
            isResultRecived
                ? Visibility(
                    visible: istotCommission,
                    child: Container(
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
                                  child: new Text(
                                      'Total Commission:' + totsum.toString(),
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
                    ))
                : Center(),

            isResultRecived && finallist.length > 0
                ? Container(
                    child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Stack(children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: finallist.length,
                            padding: EdgeInsets.all(8.0),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Card(
                                  elevation: 20.0,
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: index == 0
                                          ? const Border() // This will create no border for the first item
                                          : Border(
                                              top: BorderSide(
                                                  width: 1,
                                                  color: Colors
                                                      .black26)), // This will create top borders for the rest
                                    ),

                                    // child: InkWell(
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: <Widget>[
                                            //first row of table1 ID & CADRE
                                            Expanded(
                                              flex: -1,
                                              child: Row(
                                                children: <Widget>[
                                                  // Icon(Icons.bookmark_border_outlined),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Id :",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Text(
                                                            finallist[index]
                                                                .agentCode
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.5,
                                                            )),
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Cadre :",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        height: 35,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          finallist[index]
                                                              .agentCadre
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 2,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),

                                            //second row of table1 NAME
                                            Expanded(
                                              flex: -1,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Name :',
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 12,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          finallist[index]
                                                              .agentName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 2,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),

                                            //third row of table2 LEVEL,COMM%
                                            Expanded(
                                              flex: -1,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            top: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Level :",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            // bottom: BorderSide( //                   <--- left side
                                                            //   color: Colors.black,
                                                            //   width: 1.0,
                                                            // ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            finallist[index]
                                                                .agentLevel
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.5,
                                                            )),
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            // bottom: BorderSide( //                   <--- left side
                                                            //   color: Colors.black,
                                                            //   width: 1.0,
                                                            // ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Comm[%] :",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            // bottom: BorderSide( //                   <--- left side
                                                            //   color: Colors.black,
                                                            //   width: 1.0,
                                                            // ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            finallist[index]
                                                                .commission
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 1.5,
                                                            )),
                                                      )),
                                                ],
                                              ),
                                            ),

                                            //fourth row of table2 TOTAL PAYABLE
                                            Expanded(
                                              flex: -1,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Discount :',
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 10,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            right: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          finallist[index]
                                                              .discount
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: -1,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            left: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                            bottom: BorderSide(
                                                              //                    <--- top side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Total Payable :',
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.5,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 10,
                                                      child: Container(
                                                        height: 36,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          finallist[index]
                                                              .totalAmo
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.5,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ));
                            },
                          ),
                          isLoading
                              ? Container(
                                  child: Center(
                                  child: CircularProgressIndicator(),
                                ))
                              : Container(),
                        ])))
                : Center(
                    child: Text('Office Transaction',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          height: 1.5,
                        ))),

            //not for approved members
            isCommissionApproved(commissionApproval.toString())
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
            isCommissionApproved(commissionApproval.toString())
                ? Center()
                : Container(
                    padding: new EdgeInsets.only(top: 5.0),
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
                                    "Commission",
                                    memberid.toString(),
                                    venturecd!)
                                .then((responseData) {
                              if (responseData == 'Success') {
                                userremarks.clear();
                                setState(() {
                                  ApiConfig.utiPassbookList[pblistpos!]
                                      .commissionApproval = "Y";
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

            isCommissionApproved(commissionApproval.toString())
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
          ]),
        ),
      ),
    );
  }

  bool isCommissionApproved(String commissionApproval) {
    if (commissionApproval == "Y") {
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
      throw Exception('Failed to Change Plot Approval Update');
    }
  }
}
