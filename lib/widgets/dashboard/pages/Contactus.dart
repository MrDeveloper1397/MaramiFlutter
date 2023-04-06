import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/app_config/api_config.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;
import '../../../models/contactus.dart';

class Contactus extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<Contactus> {
  bool isResultReceived = false;

  String clientname = '', address = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyAddress();
  }

  @override
  Widget build(BuildContext context) {
    String flavorType = context.read(flavorConfigProvider).state.flavourName;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Contact Us",
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        backgroundColor: Colors.white,
        body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          margin: EdgeInsets.fromLTRB(10, 25, 10, 25),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: flavorType == 'pragati'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Get in touch',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      const Text(
                          "We'd like to hear from you. Our friendly team is always here to connect"
                          ".",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 30.0),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_pin,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            isResultReceived
                                ? Text(address.toString(),
                                    // 'Plot No: 1355A,\n3rd Floor, Road No: 1 & 45,\nAbove HDFC Bank,\nJubilee Hills,Hyd - 33.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.normal))
                                : Text(''),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('040-4544-4444',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mail,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('sales@pragatigreenliving.com',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('www.pragatigreenliving.com',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Get in touch',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      const Text(
                          "We'd like to hear from you. Our friendly team is always here to connect"
                          ".",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 30.0),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_pin,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            isResultReceived
                                ? Text(address.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.normal))
                                : Text(''),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('1800-120-5153',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mail,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('contact@tricolour.co.in',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //logic  goes here
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 20.0),
                            Text('www.tricolour.co.in',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  Future<void> getCompanyAddress() async {
    http.Response response =
        await http.get(Uri.parse(ApiConfig.BASE_URL + 'getCompanyAddress.php'));
    debugPrint('Checking response $response');
    List<dynamic> list = json.decode(response.body);
    setState(() {
      isResultReceived = true;
    });
    getContact getValues = getContact.fromJson(list[0]);
    clientname = getValues.names.toString();
    address = getValues.address1.toString();
    List phase = address.split(",");
    if (phase.length == 6) {
      address = phase[0] +
          "\n" +
          phase[1] +
          "\n" +
          phase[2] +
          "\n" +
          phase[3] +
          "\n" +
          phase[4] +
          "\n" +
          phase[5];
    } else {
      address = phase[0] +
          "\n" +
          phase[1] +
          "\n" +
          phase[2] +
          "\n" +
          phase[3] +
          "\n" +
          phase[4];
    }
  }
}
