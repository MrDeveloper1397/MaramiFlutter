import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../app_config/api_config.dart';
import '../pages/AdminMenu.dart';
import 'number_pad.dart';

class AdminPin extends StatefulWidget {
  AdminPinNewState createState() => AdminPinNewState();
}

class AdminPinNewState extends State<AdminPin> {
  String verifyCode = "";

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentfocus =
        FocusScope.of(context); //get the currnet focus node
    if (!currentfocus.hasPrimaryFocus) {
      //prevent Flutter from throwing an exception
      currentfocus
          .unfocus(); //unfocust from current focust, so that keyboard will dismiss
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        title: Text(
          "Authenticate Account",
          style: Theme.of(context).textTheme.overline,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 74),
                    child: Text(
                      "Please Enter Pin ",
                      style: TextStyle(
                        fontSize: 22,
                        // color: Color(0xFF818181),
                        // fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        height: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildCodeNumberBox(verifyCode.length > 0
                            ? verifyCode.substring(0, 1)
                            : ""),
                        buildCodeNumberBox(verifyCode.length > 1
                            ? verifyCode.substring(1, 2)
                            : ""),
                        buildCodeNumberBox(verifyCode.length > 2
                            ? verifyCode.substring(2, 3)
                            : ""),
                        buildCodeNumberBox(verifyCode.length > 3
                            ? verifyCode.substring(3, 4)
                            : ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          NumericPad(
            onNumberSelected: (value) {
              setState(() {
                if (value != -1) {
                  if (verifyCode.length < 4) {
                    verifyCode = verifyCode + value.toString();
                  }
                } else {
                  verifyCode = verifyCode.substring(0, verifyCode.length - 1);
                }
                debugPrint(verifyCode);
              });
            },
            otpVal: (String) {
              String = verifyCode;
              if (verifyCode.length < 4) {
                debugPrint('in OTP Value total ......$String...$verifyCode');
              } else {
                adminPinCheck(verifyCode).then((responseData) {
                  // print(responseData);
                  if (responseData.trimLeft() == 'Success') {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AdminMenu()));
                  } else if (responseData == 'miss_match') {
                    _showToast(responseData);
                  } else if (responseData == 'Not_Admin') {
                    _showToast(responseData);
                  } else {
                    _showToast('Session got expired please re login, ');
                  }
                });
              }
            },
            // otpVal: verifyCode,
          ),
        ],
      )),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber != '' ? '*' : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> adminPinCheck(String _otp) async {
    String pin = int.parse(_otp, radix: 16).toRadixString(2);

    final prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String pinkey = apikey!.trimLeft();
    String url = ApiConfig.BASE_URL +
        ApiConfig.GET_PIN_CHECK_ID +
        pinkey +
        ApiConfig.GET_PIN_CHECK_PIN +
        pin;

    debugPrint(url);

    final response = await http.post(Uri.parse(url));
    debugPrint('Response.......${response.body.toString()}');
    if (response.statusCode == 200) {
      String data = response.body.toString();
      return data;
    } else {
      throw Exception('Failed to load User Info');
    }
  }

  void _showToast(String responseData) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData + ', Please login with valid details')));
  }
}
