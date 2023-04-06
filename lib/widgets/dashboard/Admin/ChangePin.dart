import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:mil/main.dart';
import 'package:mil/widgets/dashboard/Admin/ChangeNewPin.dart';
import 'package:mil/widgets/dashboard/dash_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ChangePin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChangeAdminPin();
}

class ChangeAdminPin extends State<ChangePin> {
  late bool isVentureSelect;
  late String vcd;
  var loading = false;
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _otp;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            context.read(flavorConfigProvider).state.appName,
            style: Theme.of(context).textTheme.overline,
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
        body: Center(
            child: Container(
          // height: MediaQuery.of(context).size.height/3,
          alignment: Alignment.center,
          //width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 20,
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Old Pin Number',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    height: 2,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Implement 4 input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(_fieldOne, true),
                    OtpInput(_fieldTwo, false),
                    OtpInput(_fieldThree, false),
                    OtpInput(_fieldFour, false)
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _otp = _fieldOne.text +
                          _fieldTwo.text +
                          _fieldThree.text +
                          _fieldFour.text;
                      String pin = int.parse(_otp!, radix: 16).toRadixString(2);
                      adminPinCheck(pin).then((responseData) {
                        // print(responseData);
                        if (responseData == 'Success') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNewPin()));
                        } else if (responseData == 'miss_match') {
                          showSnackbar(context, responseData);
                          _fieldOne.clear();
                          _fieldTwo.clear();
                          _fieldThree.clear();
                          _fieldFour.clear();
                        } else if (responseData == 'Not_Admin') {
                          showSnackbar(context, responseData);
                          _fieldOne.clear();
                          _fieldTwo.clear();
                          _fieldThree.clear();
                          _fieldFour.clear();
                        }
                      });
                    });
                  },
                  child: Text(
                    '       Submit      ',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // Display the entered OTP code
              ],
            ),
          ),
        )));
  }

  void showSnackbar(BuildContext context, String responseData) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(responseData),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }
}

Future<String> adminPinCheck(String pin) async {
  final prefs = await SharedPreferences.getInstance();
  String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
  String pinkey = apikey!;
  final response = await http.post(Uri.parse(ApiConfig.BASE_URL +
      ApiConfig.GET_PIN_CHECK_ID +
      pinkey +
      ApiConfig.GET_PIN_CHECK_PIN +
      pin));
  if (response.statusCode == 200) {
    String data = response.body.toString();
    return data;
  } else {
    throw Exception('Failed to load User Info');
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
