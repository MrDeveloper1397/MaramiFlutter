import 'package:flutter/material.dart';
import 'package:mil/widgets/dashboard/pages/AdminMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/src/provider.dart';
import '../../../app_config/api_config.dart';
import '../../../main.dart';
import '../dash_board.dart';

class ChangeNewPin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChangedAdminNewPin();
}

class ChangedAdminNewPin extends State<ChangeNewPin> {
  late bool isVentureSelect;
  late String vcd;
  var loading = false;
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  final TextEditingController _RefieldOne = TextEditingController();
  final TextEditingController _RefieldTwo = TextEditingController();
  final TextEditingController _RefieldThree = TextEditingController();
  final TextEditingController _RefieldFour = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _otp, _Newotp;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          ),
        ),
        body: Center(
            child: Container(
          alignment: Alignment.center,
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
              children: [
                Text(
                  'New Pin Number',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      height: 2),
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
                // Spacer(),
                Text(
                  'Re-Enter New Pin Number',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      height: 2),
                ),

                const SizedBox(
                  height: 30,
                ),
                // Implement 4 input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(_RefieldOne, true),
                    OtpInput(_RefieldTwo, false),
                    OtpInput(_RefieldThree, false),
                    OtpInput(_RefieldFour, false)
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
                        _Newotp = _RefieldOne.text +
                            _RefieldTwo.text +
                            _RefieldThree.text +
                            _RefieldFour.text;
                        String pin =
                            int.parse(_otp!, radix: 16).toRadixString(2);
                        String newpin =
                            int.parse(_Newotp!, radix: 16).toRadixString(2);
                        if (pin == newpin) {
                          adminPinCheck(pin).then((responseData) {
                            // print(responseData);
                            if (responseData == 'success') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminMenu()));
                            } else if (responseData == 'miss_match') {
                              showSnackbar(context, responseData);
                              _RefieldOne.clear();
                              _RefieldTwo.clear();
                              _RefieldThree.clear();
                              _RefieldFour.clear();
                            } else if (responseData == 'Not_Admin') {
                              showSnackbar(context, responseData);
                              _RefieldOne.clear();
                              _RefieldTwo.clear();
                              _RefieldThree.clear();
                              _RefieldFour.clear();
                            }
                          });
                        } else {
                          showSnackbar(context, "Pin Number MissMatch");
                          _RefieldOne.clear();
                          _RefieldTwo.clear();
                          _RefieldThree.clear();
                          _RefieldFour.clear();
                        }
                      });
                    },
                    child: Text(
                      '       Submit      ',
                      style: Theme.of(context).textTheme.button,
                    )),
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
      ApiConfig.PIN_CHANGE_ID +
      pinkey +
      ApiConfig.PIN_CHANGE_PIN +
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
