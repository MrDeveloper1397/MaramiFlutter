import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mil/widgets/Approvals/CostApproval.dart';
import 'package:mil/widgets/Approvals/DiscountApproval.dart';
import 'package:mil/widgets/Approvals/PlotApproval.dart';

import '../../Approvals/CommissionApproval.dart';

class Approvals extends StatefulWidget {
  final int plistpos, pblistpos;
  final String mid,
      name,
      joinDate,
      plotApproval,
      costApproval,
      discountApproval,
      commissionApproval;

  Approvals({
    required this.mid,
    required this.name,
    required this.joinDate,
    required this.plotApproval,
    required this.costApproval,
    required this.discountApproval,
    required this.commissionApproval,
    required this.plistpos,
    required this.pblistpos,
  });

  @override
  State<StatefulWidget> createState() => new ApprovalInformation(
        mid,
        name,
        joinDate,
        plotApproval,
        costApproval,
        discountApproval,
        commissionApproval,
        plistpos,
        pblistpos,
      );
}

class ApprovalInformation extends State<Approvals> {
  String? passbook,
      joindate,
      applicantname,
      plotApproval,
      costApproval,
      discountApproval,
      commissionApproval;

  int? plistpos, pblistpos;

  ApprovalInformation(
      String mid,
      String name,
      String date,
      String plotApproval,
      String costApproval,
      String discountApproval,
      String commissionApproval,
      int plistpos,
      int pblistpos) {
    this.passbook = mid;
    this.applicantname = name;
    this.joindate = date;
    this.plotApproval = plotApproval;
    this.costApproval = costApproval;
    this.discountApproval = discountApproval;
    this.commissionApproval = commissionApproval;
    this.plistpos = plistpos;
    this.pblistpos = pblistpos;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Approvals',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                // Tab(child:Text('Agent',style: TextStyle(fontFamily: "Roboto"))),
                Tab(
                    child:
                        Text('Plot', style: TextStyle(fontFamily: "Roboto"))),
                Tab(
                    child:
                        Text('Cost', style: TextStyle(fontFamily: "Roboto"))),
                Tab(
                    child: Text('Discount',
                        style: TextStyle(fontFamily: "Roboto"))),
                Tab(
                    child: Text('Commission',
                        style: TextStyle(fontFamily: "Roboto")))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PlotApproval(
                  passbook: passbook!,
                  applicantname: applicantname!,
                  joindate: joindate!,
                  plotApproval: plotApproval!,
                  plistpos: plistpos,
                  pblistpos: pblistpos),
              CostApproval(
                  passbook: passbook!,
                  applicantname: applicantname!,
                  joindate: joindate!,
                  costApproval: costApproval!,
                  plistpos: plistpos,
                  pblistpos: pblistpos),
              DiscountApproval(
                  passbook: passbook!,
                  applicantname: applicantname!,
                  joindate: joindate!,
                  discountApproval: discountApproval!,
                  plistpos: plistpos,
                  pblistpos: pblistpos),
              CommissionApproval(
                  passbook: passbook!,
                  applicantname: applicantname!,
                  joindate: joindate!,
                  commissionApproval: commissionApproval!,
                  plistpos: plistpos,
                  pblistpos: pblistpos)
            ],
          ),
        ),
      ),
    );
  }
}
