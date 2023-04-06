import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/main.dart';
import 'package:http/http.dart' as http;
import 'package:mil/models/ApprovalData.dart';
import 'package:mil/models/Approvallist.dart';

import '../../ventures_list.dart';

class PendingApprovals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new PendingApprovalData();
}

class PendingApprovalData extends State<PendingApprovals> {
  TextEditingController searchFacingController = TextEditingController();
  bool showsearchField = false;
  int _selectedItemIndex = 0;
  late String _pendingApprovalsCount;

  late bool isVentureSelect;
  late String vcd;
  List<ApprovalData> listModel = <ApprovalData>[];
  List<ApprovalData> searchListModel = <ApprovalData>[];
  List<ApprovalData> searchVentures = <ApprovalData>[];
  var loading = false;
  static int plistpos = 0, passbookpos = 0;
  static int colistpos = 0, passbookcos = 0;
  static int commlistpos = 0, passbookcomm = 0;
  static int dislistpos = 0, passbookdis = 0;
  late String flavorName;
  List<Approvallist> listVentures = <Approvallist>[];
  Approvallist? approvallist;
  DateTime? selectedDate;
  String? formattedDate, tvDate;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listVentures.clear();
    searchListModel.clear();
    listModel.clear();
    searchVentures.clear();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    listVentures.clear();
    searchListModel.clear();
    listModel.clear();
    searchVentures.clear();
  }

  @override
  void initState() {
    super.initState();
    isVentureSelect = false;
    flavorName = context.read(flavorConfigProvider).state.appName;
    selectedDate = DateTime.now();
    tvDate =
        "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
    getApprovalList(http.Client()).then((List<Approvallist> value) {
      setState(() {
        listVentures.clear();

        value.forEach((element) {
          bool exists = listVentures
              .any((file) => file.ventureName == element.ventureName);

          if (!exists)
            listVentures.add(flavorName == 'SR Landmark'
                ? Approvallist(
                    ventureName: element.ventureName.toString().trim(),
                    commCalc: element.commCalc.toString().trim(),
                    ventureCd: element.ventureCd.toString().trim(),
                    dbName: element.dbName.toString().trim())
                : Approvallist(
                    count: element.count,
                    ventureName: element.ventureName.toString().trim(),
                    commCalc: element.commCalc.toString().trim(),
                    ventureCd: element.ventureCd.toString().trim()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Approvals',
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      body: VenturesList(
          listVentures, flavorName, 'pending', showsearchField, tvDate!),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // searchFacingController.vi
          setState(() {
            showsearchField = true;
          });
        },
      ),
    );
  }

  Future<List<Approvallist>> getApprovalList(http.Client client) async {
    String Url = ApiConfig.BASE_URL + "ApprovalProjectList.php";
    debugPrint('Pull Url value......${Url}');
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body.toString());
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      listVentures = parsed
          .map<Approvallist>((json) => Approvallist.fromJson(json))
          .toList();
      setState(() {
        ApiConfig.utiplistdata = listVentures;
      });
      return jsonResponse.map((job) => new Approvallist.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load Pending Approvals Ventures List');
    }
  }
}
