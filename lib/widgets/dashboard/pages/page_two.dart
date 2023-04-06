import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_info.dart';
import 'associate_details.dart';
import 'associate_details_emp.dart';

class Page2 extends StatelessWidget {
  var flavorType;

  Page2(this.flavorType);

  List<Choice> choices = [];
  List<Choices> choice = [];

  @override
  Widget build(BuildContext context) {
    const CircleAvatar(
      radius: 60,
      backgroundImage: AssetImage('assets/images/profile.jpg'),
    );

    return FutureBuilder<Widget>(
      future: fetchUserInfo(http.Client(), context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!',
                style: TextStyle(color: Colors.black)),
          );
        } else if (snapshot.hasData) {
          // return Text('Success');
          return Container(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: snapshot.data,
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<Widget> fetchUserInfo(http.Client client, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String? usertype = prefs.getString(ApiConfig.PTEF_KEY_USER_TYPE);
    String GET_PROFILE_APIKEY = "&ApiKey=" + apikey!.trimLeft();
    String GET_PROFILE_USER = "&UserType=" + usertype!;

    String url = ApiConfig.BASE_URL +
        ApiConfig.GET_PROFILE_COMPANY +
        ApiConfig.COMPANY_ID +
        GET_PROFILE_APIKEY +
        GET_PROFILE_USER;

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      debugPrint('Check Error is.....${response.body}');
      String status = decodedJson['status'].toString();
      debugPrint('Status value...${status}');
      if (status == 'fail') {
        return Container(
          child: const Center(
            child: Text('Session got expired! Please Relogin',
                style: TextStyle(color: Colors.black)),
          ),
        );
      } else {
        UserInfo userInfo = UserInfo.fromJson(decodedJson['result']);
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              SizedBox(height: 20),
              Text(
                userInfo.name.toString().trim().toUpperCase() + '\n',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
                // style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0,letterSpacing: 1, wordSpacing: 1),
              ),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Container(
                    alignment: FractionalOffset.center,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10.0, 20.0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Employee Id  ' ': ' +
                                  userInfo.id.toString().trim(),
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto-Light',
                                fontSize: 16.0,
                                // fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Joining Date     ' ': ' +
                                  ((userInfo.joiningdate.toString() != 'null')
                                      ? userInfo.joiningdate.toString()
                                      : ''),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Mobile                ' ':  ' +
                                  ((userInfo.mobile.toString() != 'null')
                                      ? userInfo.mobile.toString()
                                      : ':'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pan Card            ' ': ' +
                                  ((userInfo.pancard.toString() != 'null')
                                      ? userInfo.pancard.toString()
                                      : ''),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Aadhar No.        ' ': ' +
                                  ((userInfo.aadhar.toString() != 'null')
                                      ? userInfo.aadhar.toString()
                                      : ''),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Address             ' ': ' +
                                  ((userInfo.address.toString() != 'null')
                                      ? userInfo.address.toString()
                                      : ''),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ],
                        )),
                  )),
              // flavorType == 'SR Landmark' ? AssociateDetails() : Container(),
              (usertype == 'Employee')
                  ? AssociateDetailsEmp()
                  : AssociateDetails(),

              /*Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                elevation: 5,
                child:  Container(
                  alignment: FractionalOffset.bottomCenter,
                child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10.0, 20.0, 10.0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                        ],
                      )),
                )
            ),*/
            ],
          ),
        );
      }
    }
    return Container();
  }
}
