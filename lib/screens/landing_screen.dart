import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mil/widgets/agent_login.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:mil/widgets/employee_login.dart';
import 'package:mil/widgets/guest_login.dart';
import '../main.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String flavorType = context.read(flavorConfigProvider).state.flavourName;
    return DefaultTabController(
        length: 3,
        child: Scaffold(

          body: Container(
            width: double.infinity,
            decoration:
            flavorType == 'pragati' ? BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.green.shade900,
              Colors.green.shade500,
              Colors.green.shade400,
            ])) :
            flavorType=='tricolour'? BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              /*Colors.red.shade900,
              Colors.red.shade500,
              Colors.red.shade400,*/

                  Color(0xFF28b6cc),
                  Color(0xFF28b6cc),
                  Color(0xFF055a6d),


            ])):
            BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  /*Colors.red.shade900,
                  Colors.red.shade500,
                  Colors.red.shade400,*/

                  Color(0xFF26a4aa),
                  Color(0xFF27a5bb),
                  Color(0xFF055a6d),
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // #login, #welcome
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Roboto-Light'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      flavorType=='pragati'?Text(
                        "Welcome to Pragati Group",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto-Light'),
                      ):Text(
                        // "Welcome to " + flavorType,
                        "Welcome to Marami Test",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto-Light'),
                      ),
                      // Text(context.read(flavorConfigProvider).state.appName,
                      //   //       style: Theme.of(context).textTheme.overline),
                      //   // )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        // topRight: Radius.circular(60)
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // #email, #password
                            Container(
                                child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Container(
                                    // margin: const EdgeInsets.all(10.0),
                                    // padding: const EdgeInsets.all(1.0),
                                    child: TabBar(
                                        labelStyle: TextStyle(
                                            fontFamily: "poppins_semibold",
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                        unselectedLabelStyle: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: "poppins_semibold"),
                                        // indicatorColor: Theme.of(context).primaryColor,
                                        indicatorColor: Color(0xFF28b6cc),

                                        indicatorWeight: 2.0,
                                        labelColor: Color(0xFF28b6cc),
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          Tab(
                                              child: Text('Agent',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "poppins_semibold"))),
                                          Tab(
                                              child: Text('Employee',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "poppins_semibold"))),
                                          Tab(
                                              child: Text('Guest',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "poppins_semibold"))),
                                        ]),
                                  ),
                                  SizedBox(
                                      height: 400,
                                      child: TabBarView(
                                        children: [
                                          Center(
                                            child: AgentLogin(),
                                          ),
                                          Center(
                                            child: EmployeeLogin(),
                                          ),
                                          Center(
                                            child: GuestLogin(),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // body: Padding(
          //
          //   padding: EdgeInsets.all(20.0),
          //   child: Column(
          //     children: [
          //       Container(
          //         height: 50,
          //         // decoration: BoxDecoration(
          //         //   color: Colors.white,
          //         //   borderRadius: BorderRadius.circular(25.0),
          //         //   border: Border.all(color: Theme.of(context).primaryColor),
          //         //
          //         // ),
          //         margin: const EdgeInsets.all(15.0),
          //         padding: const EdgeInsets.all(1.0),
          //         child: TabBar(
          //
          //           // isScrollable: true,
          //           labelStyle: TextStyle(
          //             fontFamily: "Roboto-Light",
          //               fontSize: 16.0,
          //               ),
          //           unselectedLabelStyle:
          //           TextStyle(
          //               fontSize: 14.0, fontFamily: "Roboto-Light"),
          //           // tabs: myTabs,
          //           // controller: _tabController,
          //
          //
          //             // indicator: BoxDecoration(
          //             //   color: Theme.of(context).primaryColor,
          //             //   borderRadius: BorderRadius.circular(25.0),
          //             // ),
          //           indicatorColor: Theme.of(context).primaryColor,
          //             indicatorWeight: 2.0,
          //             labelColor: Theme.of(context).primaryColor,
          //             unselectedLabelColor: Colors.black,
          //             tabs:  [
          //               Tab(child:Text('Agent',style: TextStyle(  fontFamily: "Roboto-Light"))),
          //               Tab(child:Text('Employee',style: TextStyle(fontFamily: "Roboto-Light"))),
          //               Tab(child:Text('Guest',style: TextStyle( fontFamily: "Roboto-Light"))),
          //             ]),
          //       ),
          //       Expanded(
          //           child: Container(
          //               margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          //               child: const TabBarView(
          //                 children: [
          //                   Center(
          //                     child: AgentLogin(),
          //                   ),
          //                   Center(
          //                     child: EmployeeLogin(),
          //                   ),
          //                   Center(
          //                     child: GuestLogin(),
          //                   ),
          //                 ],
          //               )))
          //     ],
          //   ),
          // ),
        ));
  }
}
