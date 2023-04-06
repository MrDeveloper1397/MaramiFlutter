import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mil/models/ReservePlot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_config/api_config.dart';
import '../../../models/EmpAssocSales.dart';

class AssociateSales extends StatefulWidget {
  const AssociateSales({Key? key}) : super(key: key);

  @override
  State<AssociateSales> createState() => _AssociateSalesState();
}

class _AssociateSalesState extends State<AssociateSales> {
  final String baseURL = ApiConfig.BASE_URL + "/Get_Reg_Proj_data";

  TextEditingController plotRegId = TextEditingController();

  List<ReservePlot> plotsAvailability = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listPlotAvailability(baseURL).then((List<ReservePlot> value) {
      setState(() {
        plotsAvailability = value;

        plotsAvailability = Set.of(plotsAvailability).toList();
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
            'Associate Sales',
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: plotsAvailability.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                          decoration: BoxDecoration(
                            border: index == 0
                                ? const Border() // This will create no border for the first item
                                : Border(), // This will create top borders for the rest
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadSales(
                                      plotsAvailability:
                                          plotsAvailability[index]),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Card(
                                  // alignment: Alignment.center,
                                  elevation: 2,
                                  child: Container(
                                      height: 40,

                                      // width: ,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      margin: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
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
                          ));
                    },
                  )),
            ],
          ),
        ));
  }

  Future<List<ReservePlot>> listPlotAvailability(String baseURL) async {
    http.Response response = await http.get(Uri.parse(baseURL));
    String body = response.body;
    final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

    return parsed
        .map<ReservePlot>((json) => ReservePlot.fromJson(json))
        .toList();
  }
}

class LoadSales extends StatefulWidget {
  var plotsAvailability;

  LoadSales({this.plotsAvailability});

  @override
  _LoadSales createState() => _LoadSales(plotsAvailability);
}

class _LoadSales extends State<LoadSales> {
  var ventureList;
  bool showSalesList = false;
  List<CadreSalesCount> empAssocSales = [];

  _LoadSales(this.ventureList);

  Future<String?> getLoginType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginType');
  }

  var ventureId = TextEditingController();
  String ventureIdStr = 'Select Ventures';
  String loginType = '';

  @override
  void initState() {
    // TODO: implement initState
    // getLoginType();
    super.initState();
    getLoginType().then((value) {
      setState(() {
        empAssocSales.clear();
        loginType = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<AssocaitiveTree> dataAgent = [];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Associate Sales",
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: SingleChildScrollView(
          child: loginType == 'employee'
              ? Column(
                  children: [
                    Text(
                      "Venture : ${ventureList.ventureName}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        height: 2,
                      ),
                    ),
                    Padding(
                        // padding: const EdgeInsets.all(10),
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              // BoxShadow(
                              // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                            ],
                          ),
                          child: TextFormField(
                            maxLength: 4,
                            controller: ventureId,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            inputFormatters: [
                              // FilteringTextInputFormatter.digitsOnly,
                            ],
                            // controller: userLoginId,
                            decoration: InputDecoration(
                                counterText: "",
                                hintText: 'Enter Agent Id',
                                hintStyle:
                                    TextStyle(fontFamily: 'poppins_semibold'),
                                prefixIcon: Icon(Icons.person_pin_rounded),
                                contentPadding: EdgeInsets.all(16),
                                border: OutlineInputBorder()),
                          ),
                        )),
                    // SizedBox(height: 30.0),
                    Padding(
                      // padding: const EdgeInsets.all(10),
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            maximumSize: const Size(double.infinity, 40),
                          ),
                          onPressed: () {
                            setState(() {
                              ventureIdStr = ventureId.text.toString().trim();

                              showSalesList = true;
                            });
                            debugPrint(
                                'Check Vaue......${ventureId.text.toString().trim()}.....${ventureList.ventureCd}');
                          },
                          child: Text('Load Associate Sales')),
                    ),

                    showSalesList
                        ? Visibility(
                            visible: true,
                            // visible: true,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: FutureBuilder<List<CadreSalesCount>>(
                                  future: loadListInfo(
                                      ventureIdStr, ventureList.ventureCd),
                                  // future:   loadListInfo('123', ventureList.ventureCd),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Enter Valid Id',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      );
                                    } else if (snapshot.hasData) {
                                      List<CadreSalesCount> data =
                                          snapshot.data!;
                                      if (data.length > 0) {
                                        empAssocSales.clear();
                                        for (int i = 0; i < data.length; i++) {
                                          empAssocSales.add(CadreSalesCount(
                                            cadre: snapshot.data![i].cadre,
                                            childs: snapshot.data![i].childs,
                                          ));
                                        }
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: empAssocSales.length,
                                                itemBuilder: (context, i) {
                                                  return ExpansionTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          empAssocSales[i]
                                                              .cadre
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          empAssocSales[i]
                                                              .childs!
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                    children: <Widget>[
                                                      Column(
                                                        children:
                                                            _buildExpandableContent(
                                                                empAssocSales[
                                                                    i]),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else
                                        return Center(
                                          child: Text('No Data Found',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                        );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                )),
                          )
                        : Container()
                  ],
                )
              : loginType == 'agent'
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: FutureBuilder<List<CadreSalesCount>>(
                              // future: loadAgentListInfo(ventureList.ventureCd),
                              future: loadAgentListInfo(
                                  ventureId.text.toString().trim(),
                                  ventureList.ventureCd),
                              // future:   loadListInfo('123', ventureList.ventureCd),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('An error has occurred! Fail',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                  );
                                } else if (snapshot.hasData) {
                                  List<CadreSalesCount> data =
                                      snapshot.data!.toSet().toList();
                                  if (data.length > 0) {
                                    empAssocSales.clear();

                                    for (int i = 0; i < data.length; i++) {
                                      empAssocSales.add(CadreSalesCount(
                                        cadre: snapshot.data![i].cadre,
                                        childs: snapshot.data![i].childs,
                                      ));
                                    }
                                    return Container(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: empAssocSales.length,
                                            itemBuilder: (context, i) {
                                              return ExpansionTile(
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      empAssocSales[i]
                                                          .cadre
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      empAssocSales[i]
                                                          .childs!
                                                          .length
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                    ),
                                                  ],
                                                ),
                                                children: <Widget>[
                                                  Column(
                                                    children:
                                                        _buildExpandableContent(
                                                            empAssocSales[i]),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else
                                    return Center(
                                      child: Text('No Data Found',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3),
                                    );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ))
                      ],
                    )
                  : Container(),
        ));
  }

  Future<List<CadreSalesCount>> loadListInfo(
      String associateId, ventureListItemCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString('userId');

    // http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/TriColor/GetAssocaitiveTreeEmployee.php?AssociateID=2109&VentureCode=AE&reportID=123'));
    // http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/Tricolor/AssociativeSalesEmp?reportID=123&UserType=Employee&VentureCode=AE&AgentID=2109'));
    String assocSalesApi = ApiConfig.GET_EMP_ASSOCIATIVE_SALES +
        empId! +
        '&UserType=Employee&VentureCode=' +
        ventureListItemCode +
        '&AgentID=' +
        associateId;
    debugPrint('Get URL 307 :: ${assocSalesApi}');
    // debugPrint('Get URL 307 :: ${assocSalesApi}');
    http.Response response = await http.get(Uri.parse(assocSalesApi));

    String body = response.body.trim();
    Map<String, dynamic> jsonResponse = json.decode(body);
    var dataResult = jsonResponse['result'];

    var dataAssocTree = dataResult['CadreSalesCount'];
    return dataAssocTree
        .map<CadreSalesCount>((json) => CadreSalesCount.fromJson(json))
        .toList();
  }

  //
  Future<List<CadreSalesCount>> loadAgentListInfo(
      String associateId, ventureListItemCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? associateId = prefs.getString('userId');

    //http://183.82.40.106:7777/Tricolor/getAssociativeSales?reportID=2109&UserType=user&VentureCode=AE&AgentID=2109

    String assocSalesApi = ApiConfig.GET_EMP_AGENT_ASSOCIATIVE_SALES +
        associateId! +
        '&UserType=user&VentureCode=' +
        ventureListItemCode +
        '&reportID=' +
        associateId!;
    debugPrint('Get URL 307 :: ${assocSalesApi}');
    // debugPrint('Get URL 307 :: ${assocSalesApi}');
    http.Response response = await http.get(Uri.parse(assocSalesApi));

    String body = response.body.trim();
    Map<String, dynamic> jsonResponse = json.decode(body);
    var dataResult = jsonResponse['result'];

    var dataAssocTree = dataResult['CadreSalesCount'];
    return dataAssocTree
        .map<CadreSalesCount>((json) => CadreSalesCount.fromJson(json))
        .toList();
  }

/*
  Future<List<CadreSalesCount>> loadAgentListInfo(ventureListItemCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString('userId');
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String pinkey = apikey!.trimLeft();

    // http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/TriColor/GetAssocaitiveTreeEmployee.php?AssociateID=2109&VentureCode=AE&reportID=123'));
    // http.Response response = await http.get(Uri.parse('http://183.82.40.106:7777/Tricolor/getAssociativeSales?reportID=2109&UserType=user&VentureCode=AE&AgentID=2109'));

    String assocSalesApi = ApiConfig.GET_EMP_AGENT_ASSOCIATIVE_SALES +
        associateId +
        '&UserType=user&VentureCode=' +
        ventureListItemCode +
        '&reportID=' +
        associateId;
    debugPrint('Get URL 307 empId :: ${empId}');
    debugPrint('Get URL 307 :: ${assocSalesApi}');
    http.Response response = await http.get(Uri.parse(assocSalesApi));

    String body = response.body.trim();
    Map<String, dynamic> jsonResponse = json.decode(body);
    var dataResult = jsonResponse['result'];

    var dataAssocTree = dataResult['CadreSalesCount'];
    return dataAssocTree
        .map<CadreSalesCount>((json) => CadreSalesCount.fromJson(json))
        .toList();
  }*/

  _buildExpandableContent(CadreSalesCount cadreSalesCount) {
    List<Widget> columnContent = [];

    for (Childs content in cadreSalesCount.childs!)
      columnContent.add(
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            color: Colors.white,
            elevation: 5,
            child: Container(
              alignment: FractionalOffset.center,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5.0, 10.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Assoc. Id      ' ': ' + content.agentCd.toString(),
                        style: new TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto-Light',
                          fontSize: 16.0,
                          // fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Assoc. Name  ' ': ' + content.associateName.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Name                ' ': ' + content.name.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Member Id       ' ': ' + content.memberId.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plot No.            ' ': ' +
                            content.plotNo.toString() +
                            ' (' +
                            content.sector.toString() +
                            ')',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plot Area          ' ':  ' +
                            content.plotArea.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  )),
            )),
      );

    return columnContent;
  }
}
