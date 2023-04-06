import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/models/load_dashboard.dart';
import 'package:http/http.dart' as http;

class Aboutus extends StatelessWidget {
  const Aboutus({Key? key}) : super(key: key);

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
          "About Us",
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 25, 0, 0), //apply padding to all four sides
                  child: Text(
                    'ABOUT US',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                    // style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Expanded(
                  child: Card(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      FutureBuilder<Widget>(
                        future: fetchPhotos(http.Client()),
                        builder: (Context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('An error has occurred!',
                                  style: TextStyle(color: Colors.black)),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
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
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> fetchPhotos(http.Client client) async {
    final response =
        await client.get(Uri.parse(ApiConfig.GET_HOME_SCREEN_DATA));
    if (response.statusCode == 200) {
      final loadHomeVentures = jsonDecode(response.body)
          .map<LoadDashBoard>((data) => LoadDashBoard.fromJson(data))
          .toList();

      final getVentureInfo = jsonDecode(response.body)
          .map<LoadDashBoard>((data) => LoadDashBoard.fromJson(data))
          .toList();
      return Container(
        child: VentureList(ventureInfo: getVentureInfo),
      );
    }
    return Container();
  }
}

class VentureList extends StatelessWidget {
  const VentureList({Key? key, required this.ventureInfo}) : super(key: key);

  /* final List<LoadDashBoard> venturesList;*/
  final List<LoadDashBoard> ventureInfo;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
                // constraints: BoxConstraints(maxHeight: 225),
                child: Text(ventureInfo[0].context.toString().trim(),
                    textAlign: TextAlign.justify,
                    // maxLines: 20,
                    // overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline3))),
      ],
    ));
  }
}
