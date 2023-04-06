import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mil/models/Approvallist.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config/api_config.dart';
import '../models/ApprovalData.dart';
import 'dashboard/Admin/Approvals.dart';

class VenturesList extends StatefulWidget {
  List<Approvallist> listVentures;
  String flavorName;
  String plotStatus;
  bool showsearchField;
  String selectedDate;
  VenturesList(this.listVentures, this.flavorName, this.plotStatus,
      this.showsearchField, this.selectedDate);
  @override
  _VenturesList createState() => _VenturesList();
}

class _VenturesList extends State<VenturesList> {
  int _selectedItemIndex = 0;

  TextEditingController searchFacingController = TextEditingController();
  bool showsearchField = false;
  late String _pendingApprovalsCount;
  Color cardBackgroundColor = Colors.white;

  late bool isVentureSelect = false;
  late String vcd;
  var loading = false;
  static int plistpos = 0, passbookpos = 0;
  late String flavorName;
  List<Approvallist> listVentures = <Approvallist>[];
  Approvallist? approvallist;
  late String plotStatus;
  late String ventureCodeSelected;
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    listVentures = widget.listVentures;
    // isVentureSelect = widget.isVentureSelect;
    flavorName = widget.flavorName;
    plotStatus = widget.plotStatus;
    showsearchField = widget.showsearchField;
    selectedDate = widget.selectedDate;

    return Container(
      padding: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 5),
      child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ventures",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                  )),
              // Padding(
              // padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              // child:
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _jobsListView(listVentures),
                // )
              ),
              isVentureSelect
                  ? Card()
                  /*Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 8,
                      child: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Center(
                                      child: Text(
                                    plotStatus == 'pending'
                                        ? "Pending Approvals"
                                        : 'Approved',
                                    style: kTitleStyle,
                                    // Theme.of(context).textTheme.headline6,
                                  )),
                                ),
                                Container(
                                  child: Center(
                                      child: Text(
                                    _pendingApprovalsCount,
                                    style: kTitleStyle,
                                  )),
                                ),
                              ],
                            ),
                          )))*/

                  : Container(),
              Visibility(
                visible: showsearchField,
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    onChanged: searchPlotInVenture,
                    controller: searchFacingController,
                    decoration: InputDecoration(
                        labelText: "Search Person",
                        labelStyle: Theme.of(context).textTheme.headline5,
                        hintText: "Search Person",
                        hintStyle: Theme.of(context).textTheme.caption,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
              ),

              isVentureSelect
                  ? Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listModel.length,
                              padding: EdgeInsets.all(2.0),
                              itemBuilder: (context, i) {
                                passbookpos = i;
                                return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Approvals(
                                                  mid: searchListModel[i]
                                                      .memberId!
                                                      .toString(),
                                                  name: searchListModel[i]
                                                      .applicantName!
                                                      .toString(),
                                                  joinDate: searchListModel[i]
                                                      .dateJoin!
                                                      .toString(),
                                                  plotApproval:
                                                      searchListModel[i]
                                                          .plotApproval!
                                                          .toString(),
                                                  discountApproval:
                                                      searchListModel[i]
                                                          .discountApproval!
                                                          .toString(),
                                                  costApproval:
                                                      searchListModel[i]
                                                          .plotCostApproval!
                                                          .toString(),
                                                  commissionApproval:
                                                      searchListModel[i]
                                                          .commissionApproval!
                                                          .toString(),
                                                  pblistpos: i,
                                                  plistpos: plistpos,
                                                ))),
                                    child: Card(
                                        child: Container(
                                      // padding: const EdgeInsets.all(2.0),
                                      height: 40,
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Container(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    child: Text(
                                                      searchListModel[i]
                                                          .memberId
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  SizedBox(
                                                    width: 50,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      searchListModel[i]
                                                          .applicantName!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      // overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Align(
                                                    child: Text(
                                                      searchListModel[i]
                                                          .dateJoin!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    )));
                              }),
                        ),
                      ],
                    )
                  : Center(),
            ],
          )),
    );
  }

  _onVentureSelectHandler(
      String vcd, String commonCalc, List<Approvallist> data, int index) {
    setState(() {
      vcd = vcd;
      _selectedItemIndex = index;
      plistpos = index;
      _pendingApprovalsCount = data[index].count.toString();
      //  colistpos = index;
      isVentureSelect = true;
      storeCommonCalc(commonCalc, plistpos);
      ventureCodeSelected = vcd;
      _getApprovalDataBasedVenture(vcd);
    });
  }

  _onVentureSelectHandlerLM(
      String vcd, String commonCalc, int index, String dbName) {
    setState(() {
      vcd = vcd;
      plistpos = index;
      _selectedItemIndex = index;
      //  colistpos = index;
      isVentureSelect = true;
      storeCommonCalc(commonCalc, plistpos);
      _getApprovalDataBasedVentureLM(vcd, dbName);
    });
  }

  List<ApprovalData> listModel = [];

  List<ApprovalData> searchListModel = [];
  List<ApprovalData> searchVentures = [];

  void storeCommonCalc(String commonCalc, int position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CommonCalc", commonCalc);
    prefs.setInt("pos", plistpos);
    //prefs.setInt("pos", colistpos);
  }

  void _getApprovalDataBasedVenture(String ventureCd) async {
    setState(() {
      vcd = ventureCd;
      loading = true;
      listModel.clear();
    });
    String requestType = plotStatus == 'approved'
        ? "getApprovedData.php?VentureCd="
        : plotStatus == 'pending'
            ? 'getApprovalData.php?VentureCd='
            : 'getBooked_list?date=' + selectedDate!.toString() + '&venture=';

    String Url = ApiConfig.BASE_URL + requestType + ventureCd;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("VentureCd", ventureCd);
    final response = await http
        .get(Uri.parse(Url), headers: {"Content-Type": "application/json"});
    setState(() {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      listModel = parsed
          .map<ApprovalData>((json) => ApprovalData.fromJson(json))
          .toList();
      ApiConfig.utiPassbookList = listModel;
      loading = false;

      searchListModel = listModel;
      searchVentures = searchListModel;
    });
  }

  void _getApprovalDataBasedVentureLM(String ventureCd, String dbName) async {
    setState(() {
      vcd = ventureCd;
      loading = true;
      listModel.clear();
    });
    String requestType = plotStatus == 'approved'
        ? "getApprovedData.php?VentureCd="
        : plotStatus == 'pending'
            ? 'getApprovalData.php?VentureCd='
            : 'getBooked_list?date=' + selectedDate!.toString() + '&venture=';

    String Url = ApiConfig.BASE_URL + requestType + ventureCd + '&db=' + dbName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("VentureCd", ventureCd);
    debugPrint('Pull Value.....$Url');
    final response = await http
        .get(Uri.parse(Url), headers: {"Content-Type": "application/json"});
    setState(() {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      listModel = parsed
          .map<ApprovalData>((json) => ApprovalData.fromJson(json))
          .toList();
      ApiConfig.utiPassbookList = listModel;
      loading = false;
    });
  }

  _jobsListView(List<Approvallist> data) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Container(
          height: 20,
          width: 170,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8,
            color: index == _selectedItemIndex
                ? Theme.of(context).primaryColor
                : Colors.grey,
            child: InkWell(
              onTap: () => flavorName == 'SR Landmark'
                  ? _onVentureSelectHandlerLM(data[index].ventureCd!,
                      data[index].commCalc!, index, data[index].dbName!)
                  : _onVentureSelectHandler(data[index].ventureCd!,
                      data[index].commCalc!, data, index),
              child: Center(
                  child: Text(
                // data[index].ventureName!,
                // plotStatus == 'pending' ? data[index].ventureName!+" "+_pendingApprovalsCount : '',
                /* plotStatus == 'pending' ?
                    data[index].ventureName!+" ("+ data[index].count.toString()+")":
                    "",*/

                (() {
                  if (plotStatus == 'pending') {
                    return data[index].ventureName! +
                        " \n(" +
                        data[index].count.toString() +
                        ")";
                  } else if (plotStatus == 'approved') {
                    return data[index].ventureName! +
                        " \n(" +
                        data[index].count.toString() +
                        ")";
                  } else if (plotStatus != '') {
                    return data[index].ventureName! +
                        " \n(" +
                        data[index].count.toString() +
                        ")";
                  }
                  return "";
                }()),

                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: index != _selectedItemIndex
                      ? FontWeight.normal
                      : FontWeight.bold,
                  color:
                      index != _selectedItemIndex ? Colors.black : Colors.white,
                ),
              )

                  /*  child:  Text(
                    // data[index].ventureName!,
                    // plotStatus == 'pending' ? data[index].ventureName!+" "+_pendingApprovalsCount : '',
                    plotStatus == 'pending' ?
                    data[index].ventureName!+" ("+ data[index].count.toString()+")":
                    "",



                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: index != _selectedItemIndex
                          ? FontWeight.normal
                          : FontWeight.bold,
                      color: index != _selectedItemIndex
                          ? Colors.black
                          : Colors.white,
                    ),
                  )*/
                  ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        width: 5,
      ),
    );
  }

  void searchPlotInVenture(String searchingValue) {
    if (searchingValue.isNotEmpty) {
      List<ApprovalData> dummySearchListData = [];
      searchVentures.forEach((item) {
        if (item.applicantName!
            .toLowerCase()
            .contains(searchingValue.toLowerCase())) {
          dummySearchListData.add(item);
        }
      });
      setState(() {
        searchListModel..clear();
        searchListModel.addAll(dummySearchListData);
      });
      return;
    } else {
      setState(() {
        searchListModel.clear();
        _getApprovalDataBasedVenture(ventureCodeSelected);
        searchListModel.addAll(listModel);
      });
    }
  }

  final TextStyle kTitleStyle = const TextStyle(
    color: Colors.black,
    fontFamily: 'Raleway',
    fontSize: 17.0,
    fontWeight: FontWeight.bold,
    height: 2,
  );
}
