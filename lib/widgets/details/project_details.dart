import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProjectDetails extends StatefulWidget {
  final String projectnameController; //if you have multiple values add here
  final String projectTitle; //if you have multiple values add here
  final String availableCount; //if you have multiple values add here
  final String alloCount; //if you have multiple values add here
  final String mortCount; //if you have multiple values add here
  final String regsCount; //if you have multiple values add here
  final String reseCount; //if you have multiple values add here
  final String totcount; //if you have multiple values add here
  ProjectDetails(
      this.projectnameController,
      this.projectTitle,
      this.availableCount,
      this.alloCount,
      this.mortCount,
      this.regsCount,
      this.reseCount,
      this.totcount); //add

  @override
  ProjectDetailsState createState() => ProjectDetailsState();
}

class ProjectDetailsState extends State<ProjectDetails> {
  String projectnameController = '';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  int _stackToView = 1;
  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.projectTitle,
              style: Theme.of(context).textTheme.overline),
        ),
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text("Total Plots : " + widget.totcount,
                      style: Theme.of(context).textTheme.headline1),
                ),
                Container(
                    // margin: EdgeInsets.all(5),
                    child: Table(
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1),
                        children: [
                      TableRow(children: [
                        Column(children: [
                          Container(
                            width: 100,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Color(0XFF00A84C),
                            ),
                            // color: Colors.green[900],

                            child: Text('Available',
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                )),
                          )
                        ]),
                        Column(children: [
                          Container(
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              // color: Colors.green[300],
                              color: Color(0XFFEF4836),
                              child: Text('Allotted',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,

                              // color: Colors.green[300],
                              color: Color(0XFFA07E50),
                              child: Text('Mortg',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,

                              // color: Colors.green[300],
                              color: Color(0XFF1BA39C),
                              child: Text('Regd',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,

                              // color: Colors.green[300],
                              color: Color(0XFFF39C12),
                              child: Text('Resvd',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                      ]),
                      TableRow(children: [
                        // Column(children: [Text(ventureTxt)]),
                        Column(children: [
                          Container(
                              // color: Colors.green[900],
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Color(0XFF00A84C),
                              ),
                              child: Text(widget.availableCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              // color: Colors.green[300],
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Color(0XFFEF4836),
                              ),
                              child: Text(widget.alloCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              // color: Colors.green[300],
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Color(0XFFA07E50),
                              ),
                              child: Text(widget.mortCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              // color: Colors.green[300],
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Color(0XFF1BA39C),
                              ),
                              child: Text(widget.regsCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                        Column(children: [
                          Container(
                              // color: Colors.green[300],
                              width: 100,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                color: Color(0XFFF39C12),
                              ),
                              child: Text(widget.reseCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  )))
                        ]),
                      ]),
                    ])),
                Expanded(
                    child: WebView(
                  initialUrl: widget.projectnameController,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )),
              ],
            ),
            Container(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          ],
        ));
  }
}
