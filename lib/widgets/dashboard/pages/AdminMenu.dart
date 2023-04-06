import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/main.dart';
import 'package:mil/routes/route.dart';
import 'package:mil/widgets/dashboard/dash_board.dart';

class AdminMenu extends StatefulWidget {

  @override
  _AdminMenuState createState() => _AdminMenuState();
}

class Choice {
  final String title;
  final String icon;
  final String nav;
  const Choice({required this.title, required this.icon, required this.nav});
}

List<Choice> choices = [];

class _AdminMenuState extends State<AdminMenu> {
  var result;
  @override
  void initState() {
    super.initState();
    String appFlavor = context.read(flavorConfigProvider).state.appName;

    choices = [
      const Choice(
          title: 'Pending \nApprovals',
          icon: 'assets/images/icn_approval.png',
          nav: pendingApprovals),
      const Choice(
          title: 'Approved \nMembers',
          icon: 'assets/images/ic_admin_approved.png',
          nav: approvedMembers),
      appFlavor.toString().trimRight() == 'SR Landmark'
          ? const Choice(
              title: 'Plot Matrix',
              icon: 'assets/images/ic_plotmatrix.png',
              nav: plotMatrixLandMark)
          : const Choice(
              title: 'Plot Matrix',
              icon: 'assets/images/ic_plotmatrix.png',
              nav: plotMatrix),
      const Choice(
          title: 'Day Collection',
          icon: 'assets/images/ic_day_collection.png',
          nav: dayCollection),
      const Choice(
          title: 'Day Payments',
          icon: 'assets/images/ic_day_payments.png',
          nav: dayPayments),
      const Choice(
          title: 'Day Bookings',
          icon: 'assets/images/ic_day_bookings.png',
          nav: dayBookings),
      const Choice(
          title: 'Change Pin Number',
          icon: 'assets/images/ic_action_pinchange.png',
          nav: changePin),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String flavorName = context.read(flavorConfigProvider).state.appName;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // title: Text(context.read(flavorConfigProvider).state.appName,
        title: Text(
          'Admin Menu',
          style: Theme.of(context).textTheme.overline,
          textAlign: TextAlign.left,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AppDashboard(
                        loginType: 'employee',
                      ))),
          //Navigator.pop(context, false),
        ),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 1,
          padding: EdgeInsets.only(top: 40),
          children: List.generate(choices.length, (index) {
            return Center(
              child: CardWidget(choices[index]),
            );
          })),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardWidget(Choice choic) {
    return Card(
        // color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        elevation: 5,
        child: InkWell(
            onTap: () => Navigator.pushNamed(context, choic.nav),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: new Image(image: new AssetImage(choic.icon)),
                    ),
                    Text(choic.title,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        textAlign: TextAlign.center),
                    Padding(padding: EdgeInsets.all(2)),
                  ]),
            )));
  }
}
