import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../../routes/route.dart';

class Choices {
  final String title;
  final String icon;
  final String nav;
  const Choices({required this.title, required this.icon, required this.nav});
}

class AssociateDetailsEmp extends StatelessWidget {
  List<Choices> choice = [];
  @override
  Widget build(BuildContext context) {
    String flavorType = context.read(flavorConfigProvider).state.flavourName;
    // TODO: implement build
/*(flavorType == 'SR Landmark' ? Page4LM() : Page4()*/
    // prefs.setString(
    //     'loginType', 'employee');
    choice = [
/*      const Choices(
          title: 'Associate \nRecruitment',
          icon: 'assets/images/recruitment.png',
          nav: associateRecruitment),*/
      const Choices(
          title: 'Associate \nDownline',
          icon: 'assets/images/downline.png',
          nav: associateTree),
      const Choices(
          title: 'Associate \nSales',
          icon: 'assets/images/associatesales.png',
          nav: associateSales),
    ];

    return flavorType =='pragati'? Container():
    Container(
        child: Expanded(
            child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.only(top: 30),
                children: List.generate(choice.length, (index) {
                  return Center(
                    child: CardWidget(choice[index], context),
                  );
                })))
    );
  }

  Widget CardWidget(Choices choic, BuildContext context) {
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
