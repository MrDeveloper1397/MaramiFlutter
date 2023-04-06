import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/load_dashboard.dart';
import 'package:mil/screens/splash_screen.dart';
import 'package:mil/widgets/dashboard/Admin/PlotReservation.dart';
import 'package:mil/widgets/dashboard/Admin/PlotReservationLM.dart';
import 'package:mil/widgets/dashboard/pages/Aboutus.dart';
import 'package:mil/widgets/dashboard/pages/AdminPin.dart';
import 'package:mil/widgets/dashboard/pages/Contactus.dart';
import 'package:mil/widgets/dashboard/pages/Notifications.dart';
import 'package:mil/widgets/dashboard/pages/Offers.dart';
import 'package:mil/widgets/dashboard/pages/ServicesList.dart';
import 'package:mil/widgets/dashboard/pages/page_four.dart';
import 'package:mil/widgets/dashboard/pages/page_three.dart';
import 'package:mil/widgets/dashboard/pages/page_two.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../details/project_details.dart';

class AppDashboard extends StatefulWidget {
  final String loginType;
  const AppDashboard({Key? key, required this.loginType}) : super(key: key);
  @override
  _AppDashboardState createState() => _AppDashboardState();
}

class _AppDashboardState extends State<AppDashboard> {
  int pageIndex = 0;

  final pages = [
    Page1(),
    Page2(flavorType),
    Page3(flavorType),
    Page4(),
  ];
  late Widget text = Page1();

  static var flavorType;

  _onTap(int index) async {
    switch (index) {
      case 0:
        pageIndex = 0;
        setState(() => text = Page1());
        break;
      case 1:
        pageIndex = 1;
        setState(() => text = Page2(flavorType));
        break;
      case 2:
        pageIndex = 2;
        setState(() => text = Page3(flavorType));
        break;
      case 3:
        pageIndex = 3;
        setState(() => text =
            Page4() /*(flavorType == 'SR Landmark' ? Page4LM() : Page4()*/);
        break;
      case 4:
        // setState(() => text = Page1());
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(1000.0, 1000.0, 0.0, 0.0),
          items: [
            PopupMenuItem(
              child: Text(
                "About Us",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await Future.delayed(Duration.zero);
                navigator.push(
                  MaterialPageRoute(builder: (_) => Aboutus()),
                );
              },
            ),
            PopupMenuItem(
              child: Text(
                "Contact Us",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await Future.delayed(Duration.zero);
                navigator.push(
                  MaterialPageRoute(builder: (_) => Contactus()),
                );
              },
              // onTap: () {
              //   setState(() => text = Contactus());
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: () => Contactus()));
              // }
            ),
            PopupMenuItem(
              child: Text(
                "Services",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await Future.delayed(Duration.zero);
                navigator.push(
                  MaterialPageRoute(builder: (_) => ServicesList()),
                );
              },
              // onTap: () {
              //   setState(() => text = Contactus());
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: () => Contactus()));
              // }
            ),
            PopupMenuItem(
              child: Text(
                "Share App",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=task.marami.TriColour');
              },
            ),
            PopupMenuItem(
              child: Text(
                "Log Out",
                style: Theme.of(context).textTheme.headline3,
              ),

              // onPressed: () {
              //   /// Fill webOrigin only when your current origin is different than the app's origin
              //   Restart.restartApp(webOrigin: '[your main route]');
              // }
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LandingScreen()));

                setState(() {
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil('splash', (Route<dynamic> route) => false);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MySplashScreen()),
                    (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
          elevation: 8.0,
        );
        break;
      // default:
      //   setState(() => text = Page1());
    }
  }

  _onGuestTap(int index) async {
    switch (index) {
      case 0:
        pageIndex = 0;
        setState(() => text = Page1());
        break;
      case 1:
        pageIndex = 1;

        setState(() => text = Page3(flavorType));
        break;
      case 2:
        pageIndex = 2;
        // setState(() => text = Page4());
        setState(() => text =
            Page4() /*(flavorType == 'SR Landmark' ? Page4LM() : Page4())*/);
        break;
      case 3:
        // setState(() => text = Page1());
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(1000.0, 1000.0, 0.0, 0.0),
          items: [
            PopupMenuItem(
              child: Text(
                "About Us",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await Future.delayed(Duration.zero);
                navigator.push(
                  // MaterialPageRoute(builder: (_) => Aboutus()),
                  MaterialPageRoute(builder: (_) => Aboutus()),
                );
              },
              // onTap: () {
              //   setState(() => text = Contactus());
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: () => Contactus()));
              // }
            ),
            PopupMenuItem(
              child: Text(
                "Contact Us",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await Future.delayed(Duration.zero);
                navigator.push(
                  MaterialPageRoute(builder: (_) => Contactus()),
                );
              },
              // onTap: () {
              //   setState(() => text = Contactus());
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: () => Contactus()));
              // }
            ),
            // PopupMenuItem(
            //   child: Text("Services"),
            //   onTap: () async {
            //     final navigator = Navigator.of(context);
            //     await Future.delayed(Duration.zero);
            //     navigator.push(
            //       MaterialPageRoute(builder: (_) => ServicesList()),
            //     );
            //   },
            //   // onTap: () {
            //   //   setState(() => text = Contactus());
            //   //   Navigator.push(context,
            //   //       MaterialPageRoute(builder: () => Contactus()));
            //   // }
            // ),
            PopupMenuItem(
              child: Text(
                "Share App",
                style: Theme.of(context).textTheme.headline3,
              ),
              onTap: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=task.marami.TriColour');
              },
            ),
            PopupMenuItem(
              child: Text(
                "Log Out",
                style: Theme.of(context).textTheme.headline3,
              ),

              // onPressed: () {
              //   /// Fill webOrigin only when your current origin is different than the app's origin
              //   Restart.restartApp(webOrigin: '[your main route]');
              // }
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LandingScreen()));

                setState(() {
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil('splash', (Route<dynamic> route) => false);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MySplashScreen()),
                    (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
          elevation: 8.0,
        );
        break;
      // default:
      //   setState(() => text = Page1());
    }
  }

  @override
  Widget build(BuildContext context) {
    flavorType = context.read(flavorConfigProvider).state.flavourName;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Marami Test",
          // context.read(flavorConfigProvider).state.appName,
          style: Theme.of(context).textTheme.overline,
          /* style: TextStyle(color: Colors.black,
              fontFamily: 'Raleway',
              fontSize: 18.0,
              // fontWeight: FontWeight.bold,
              height: 1.5,)*/
        ),
        // backgroundColor: Colors.white,
        // backgroundColor: Color(0xFF6EB999),
        // backgroundColor: Color(0xFFFF2400),
        // backgroundColor: Color(0xFF246EE9),
        // backgroundColor: Color(0xFF246EE9),
        // backgroundColor: Color(0xFFe7edeb),

        backgroundColor: Theme.of(context).primaryColor,
        // title: Text("PopupMenu Bottom Nav Bar"),

        actions: [
          flavorType == 'SR Landmark'
              ? Row(
                  children: <Widget>[
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.card_giftcard),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Offers())),
                        ),
                        Positioned(
                          top: 0,
                          right: 3.2,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text("0"),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Notifications())),
                        ),
                        Positioned(
                          top: 0,
                          right: 3.2,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text("0"),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          if (widget.loginType == 'employee')
            //admin&plotreservation option menubutton
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Admin",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await Future.delayed(Duration.zero);
                      navigator.push(
                        MaterialPageRoute(builder: (_) => AdminPin()),
                      );
                    },
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      "Plot Reservation Request",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await Future.delayed(Duration.zero);
                      navigator.push(
                        MaterialPageRoute(
                            builder: (_) => flavorType == 'SR Landmark'
                                ? PlotReservationLM()
                                : PlotReservation()),
                      );
                    },
                  ),
                ];
              },
            ),
        ],
      ),

      body: Center(
          child:
              text /*Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ))*/
          ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          // backgroundColor: Color(0xFFe7edeb),
          type: BottomNavigationBarType.fixed,

          //currentIndex: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                // color: Colors.white,
              ),
              label: 'Home',
            ),
            if (widget.loginType != 'guest')
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  // color: Colors.white,
                ),
                label: 'Profile',
                /*   activeIcon: Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),*/
              ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.amp_stories,
                // color: Colors.white,
              ),
              label: 'Layouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.villa,
                // color: Colors.white,
              ),
              label: 'VacantList',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.more_vert,
                // color: Colors.white,
              ),
              label: 'More',
            ),
          ],
          currentIndex: pageIndex,
          selectedLabelStyle: TextStyle(fontSize: 13, color: Colors.black),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          onTap: (widget.loginType != 'guest') ? _onTap : _onGuestTap),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String flavorType = context.read(flavorConfigProvider).state.flavourName;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                height: 155.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                    // child: Text(context.read(flavorConfigProvider).state.appName),
                    ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      FutureBuilder<List<LoadDashBoard>>(
                        future: fetchPhotos(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Center(
                                child: Text('Sorry, something went wrong.',
                                    style:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return PhotosList(photos: snapshot.data!);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ]))),
                /*Card(
                  margin: const EdgeInsets.only(top: 60.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                        FutureBuilder<Widget>(
                          future: fetchPhotos(http.Client()),
                          builder: (Context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('An error has occurred!'),
                              );
                            } else if (snapshot.hasData) {
                              return Container(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    // child: snapshot.data,
                                    child: snapshot.data,
                                  ));

                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ])),
                ),*/
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 22.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),

              child: Container(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(5.0),
                // ),
                // color: Colors.white,
                padding: const EdgeInsets.all(15),
                height: 110.0,
                width: 300.0,
                child: flavorType == 'pragati'
                    ? Image.asset(
                        'assets/app_icon/homewall2.png',
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        context.read(flavorConfigProvider).state.itemLocation,
                        fit: BoxFit.fitHeight,
                      ),
              ),
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.white,
              //     width: 10,
              //   ),
              //
              //   // shape: BoxShape.rectangle,
              //   borderRadius: BorderRadius.circular(25),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<LoadDashBoard>> fetchPhotos(http.Client client) async {
    final response = await client.get(Uri.parse(ApiConfig.BASE_URL +
        'getHomeScr_data?CompanyId=' +
        ApiConfig.COMPANY_ID));
    return compute(parsePhotos, response.body);
  }

  List<LoadDashBoard> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<LoadDashBoard>((json) => LoadDashBoard.fromJson(json))
        .toList();
  }
}

class VentureList extends StatelessWidget {
  const VentureList(
      {Key? key, required this.ventureInfo, required this.venturesList})
      : super(key: key);

  final List<LoadDashBoard> venturesList;
  final List<LoadDashBoard> ventureInfo;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Material(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'ONGOING VENTURES',
            // textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Container(
          height: 480.0,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: venturesList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                  height: 150,
                  width: 200,
                  child: Card(
                      elevation: 2,
                      margin: EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectDetails(
                                    venturesList[index].lINK.toString(),
                                    venturesList[index].projectTitle.toString(),
                                    venturesList[index].avlCount.toString(),
                                    venturesList[index].alloCount.toString(),
                                    venturesList[index].mortCount.toString(),
                                    venturesList[index].regsCount.toString(),
                                    venturesList[index].reseCount.toString(),
                                    venturesList[index].totcount.toString(),
                                  ),
                                ));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Image.network(ApiConfig.LOAD_IMAGES_BASE_URL +
                                    venturesList[index]
                                        .upcomingProject
                                        .toString()),
                                Text(
                                    venturesList[index]
                                        .projectTitle
                                        .toString()
                                        .trim(),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ],
                            ),
                          ))));
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
          ),
        )
      ],
    ));
  }
}

//homescreen.
class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<LoadDashBoard> photos;

  @override
  Widget build(BuildContext context) {
    return new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        elevation: 5,
        // margin: EdgeInsets.fromLTRB(10,15,10,15),
        // margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: List.generate(photos.length, (index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              elevation: 8,
                              // margin: EdgeInsets.all(10.0),
                              semanticContainer: true,
                              clipBehavior: Clip.none, // antiAliasWithSaveLayer

                              margin: EdgeInsets.fromLTRB(10, 25, 10, 25),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectDetails(
                                                  photos[index].lINK.toString(),
                                                  photos[index]
                                                      .projectTitle
                                                      .toString(),
                                                  photos[index]
                                                      .avlCount
                                                      .toString(),
                                                  photos[index]
                                                      .alloCount
                                                      .toString(),
                                                  photos[index]
                                                      .mortCount
                                                      .toString(),
                                                  photos[index]
                                                      .regsCount
                                                      .toString(),
                                                  photos[index]
                                                      .reseCount
                                                      .toString(),
                                                  photos[index]
                                                      .totcount
                                                      .toString(),
                                                )));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: Image.network(
                                          ApiConfig.LOAD_IMAGES_BASE_URL +
                                              photos[index]
                                                  .upcomingProject
                                                  .toString(),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center))));
                        })))),
          ],
        ));
  }
}
