import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mil/models/PlotApprovalModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../app_config/api_config.dart';

class DiscountApproval extends StatefulWidget {
  final int? plistpos,pblistpos;
  final String? passbook, joindate, applicantname, discountApproval;


  DiscountApproval(
      {required this.passbook,
        required this.applicantname,
        required this.joindate,
        required this.discountApproval,required this.plistpos,required this.pblistpos});

  @override
  State<StatefulWidget> createState() => DiscountApprovalState(
      passbook!,
      joindate!,
      applicantname!,
      discountApproval!,
      plistpos!,
      pblistpos!
  );
}

class DiscountApprovalState extends State<DiscountApproval> {
  late List jsonResponse;
  String? venturecd, commonCalc, sector, plotno, plotarea;
  late bool isResultRecived;
  late PlotApprovalModel model;
  String? passbook, joindate, applicantname, discountApproval;

  int? plistpos,pblistpos;
  var buttonText = 'Approval';
  TextEditingController userremarks = TextEditingController();

  bool isPressed = true;
  bool isEnabled= true;
  bool _isDisable = false;
  int? memberid;

  DiscountApprovalState(
      String mid, String date, String name, String discountApproval,int plistpos,int pblistpos) {
    this.passbook = mid;
    this.applicantname = name;
    this.joindate = date;
    this.discountApproval = discountApproval;
    this.plistpos = plistpos;
    this.pblistpos = pblistpos;
  }

  Future<Null> getDiscountApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    venturecd = prefs.getString("VentureCd")!;
    commonCalc = prefs.getString("CommonCalc")!;
    // ignore: non_constant_identifier_names
    String Url = ApiConfig.BASE_URL +
        "getCommissiondata.php?VentureId=" +
        venturecd! +
        "&PassbookNo=" +
        passbook! +
        "&CommCalc=" +
        commonCalc!;
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      // List<dynamic> list = json.decode(response.body);
      setState(() {
        sector = prefs.getString("Sector");
        memberid = prefs.getInt("MemberId");
        plotno = prefs.getString("Plotno");
        plotarea = prefs.getString("PlotArea");
        // model = PlotApprovalModel.fromJson(list[0]);
        isResultRecived = true;
      });
      //return model;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // userremarks = TextEditingController();
    setState(() {
      isResultRecived = false;
      getDiscountApproval();
    });
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
              margin:  EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints:
                  BoxConstraints(minWidth: constraints.minWidth),
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(95.0),
                    border: TableBorder.all(
                        color: Colors.black, style: BorderStyle.solid, width: 1),
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
                          Text(venturecd!, style: TextStyle( fontSize: 15.0,
                              fontFamily: 'Roboto',
                              height: 1.8,
                              color: Colors.black,
                              fontWeight: FontWeight.normal))
                        ]),
                        Column(children: [
                          Text(sector!, style: TextStyle( fontSize: 15.0,
                              fontFamily: 'Roboto',
                              height: 1.8,
                              color: Colors.black,
                              fontWeight: FontWeight.normal))
                        ]),
                        Column(children: [
                          Text(plotno!, style: TextStyle( fontSize: 15.0,
                              fontFamily: 'Roboto',
                              height: 1.8,
                              color: Colors.black,
                              fontWeight: FontWeight.normal))
                        ]),
                        Column(children: [
                          Text(plotarea!, style: TextStyle( fontSize: 15.0,
                              fontFamily: 'Roboto',
                              height: 1.8,
                              color: Colors.black,
                              fontWeight: FontWeight.normal))
                        ]),

                      ]),
                    ],),),
              ),
            )
                : Center(),
            isResultRecived
                ? Container(
              margin: EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minWidth: constraints.minWidth),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(125.0),
                      border: TableBorder.all(
                          color: Colors.black, style: BorderStyle.solid, width: 1),
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
                          // Column(children: [Text(ventureTxt)]),
                          Column(children: [
                            Text(memberid!.toString(), style: TextStyle( fontSize: 15.0,
                                fontFamily: 'Roboto',
                                height: 1.8,
                                color: Colors.black,
                                fontWeight: FontWeight.normal))
                          ]),
                          Column(children: [
                            Text(applicantname!.toUpperCase(),textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 15.0,
                                    fontFamily: 'Roboto',
                                    height: 1.8,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal))
                          ]),
                          Column(children: [
                            Text(joindate!, style: TextStyle(fontSize: 15.0,
                                fontFamily: 'Roboto',
                                height: 1.8,
                                color: Colors.black,
                                fontWeight: FontWeight.normal))
                          ]),
                        ]),
                      ],),)
              ),
            )
                : Center(),
            isResultRecived
                ? Container(
              padding: new EdgeInsets.only(top: 16.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context). size. width,
                    height: 40,
                    child:Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.white,
                      elevation: 5,
                      child:

                      new Text('Discount Details ',
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
            isResultRecived
                ? Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Company Discount                    : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black,
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
                          "0.0",
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 14.0,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ))
                : Center(),
            isResultRecived
                ? Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Associate Discount                   :  ",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                          height: 1.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(
                          "0.0",
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 14.0,
                              height: 1.5,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ))
                : Center(),

            //not for approved members
            isDiscountApproved(discountApproval.toString())
                ?Center():Container(
              padding: new EdgeInsets.only(top: 15.0,left: 5),
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
                          fontWeight: FontWeight.bold
                      )),
                ],
              ),
            ),
            isDiscountApproved(discountApproval.toString())
                ?Center():Container(
                padding: new EdgeInsets.only(top: 5.0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          primary: isPressed ? Colors.red : Colors.green,
                          textStyle: const TextStyle(color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            height: 1,)
                      ),
                      onPressed:() {
                        setState(() {
                          isPressed = !isPressed;
                          buttonText ="Approved";
                        });
                        onChangeApproval(userremarks.text.trim().toString(),"Discount",memberid.toString(),venturecd!).then((responseData) {
                          if (responseData == 'Success') {
                            userremarks.clear();
                            setState(() {
                              ApiConfig.utiPassbookList[pblistpos!].discountApproval = "Y";
                            });
                          }
                        });
                      },
                      child: Text(buttonText,style: TextStyle(color: Colors.white)),

                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                              controller: userremarks,
                              decoration: InputDecoration(
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

            isDiscountApproved(discountApproval.toString())
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

  bool isDiscountApproved(String discountApproval) {
    if (discountApproval == "Y") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> onChangeApproval(String remarks,String param,String memberid,String venture) async {
    String passbook= memberid;
    String venturtecd=venture;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String Url = ApiConfig.BASE_URL + "UpdateApprovalData.php?PassbookNo=" + passbook + "&VentureId=" + venturtecd + "&Remarks=" + remarks + "&Activity=" + param+"&ApiKey="+apikey!;
    final response = await http.get(Uri.parse(Url), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      String data = response.body.toString();
      return data;
    } else {
      throw Exception('Failed to Change Discount Approval Update');
    }
  }

  // }
}
