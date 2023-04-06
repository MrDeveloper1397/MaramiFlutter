import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mil/app_config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/dash_board.dart';

class AgentLogin extends StatefulWidget {
  const AgentLogin({Key? key}) : super(key: key);

  @override
  State<AgentLogin> createState() => _AgentLogin();
}

TextEditingController userLoginId = TextEditingController();
TextEditingController userLoginIdCloud = TextEditingController();
TextEditingController userLoginIdName = TextEditingController();
TextEditingController userLoginIdContactNo = TextEditingController();
TextEditingController userLoginIdOTP = TextEditingController();

bool visible = true;
bool hideUserId = false;
bool hideUserOTP = false;

String userContactNo = '';
String userBasicInfo = '';
String userOTPPhTrim = '';
String userOTPAuth = '';

bool _isObscure = true;

class _AgentLogin extends State<AgentLogin> {
  String text = 'Some text';

  @override
  void initState() {
    super.initState();
    visible = true;
    hideUserId = false;
    hideUserOTP = false;

    userLoginId.clear();
    userLoginIdCloud.clear();
    userLoginIdName.clear();
    userLoginIdContactNo.clear();
    userLoginIdOTP.clear();
  }

  @override
  Widget build(BuildContext contextVal) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 20,
                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Form(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //Agent Reg Page
                          Visibility(
                              visible: visible,
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Text(' AGENT REGISTRATION',
                                          style: TextStyle(
                                            fontSize: 20,
                                            // color: Theme.of(context).primaryColor,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.w500,
                                            fontFamily: 'poppins_regular',
                                            height: 2,
                                          ))),
                                  SizedBox(height: 40.0),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            // BoxShadow(
                                            // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                                          ],
                                        ),
                                        child: TextFormField(
                                          maxLength: 4,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          controller: userLoginId,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              hintText: 'Enter Id',
                                              hintStyle: TextStyle(
                                                  fontFamily:
                                                      'poppins_semibold'),
                                              prefixIcon: Icon(
                                                  Icons.person_pin_rounded),
                                              contentPadding:
                                                  EdgeInsets.all(16),
                                              border: OutlineInputBorder()),
                                        ),
                                      )),
                                  SizedBox(height: 60.0),
                                  ElevatedButton(
                                      child: Text(
                                        '       Save       ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'poppins_semibold'),
                                      ),
                                      onPressed: () => {
                                            setState(() {
                                              getUserBasicInfo(userLoginId.text
                                                      .trim()
                                                      .toString())
                                                  .then((responseData) {
                                                if (responseData !=
                                                    'not_employee') {
                                                  setState(() {
                                                    visible = false;
                                                    hideUserId = true;
                                                    hideUserOTP = false;

                                                    final split =
                                                        responseData.split(',');
                                                    userOTPAuth = split[1];
                                                    final Map<int, String>
                                                        values = {
                                                      for (int i = 0;
                                                          i < split.length;
                                                          i++)
                                                        i: split[i]
                                                    };
                                                    userLoginId.text =
                                                        userLoginId.text.trim();
                                                    userLoginIdName.text =
                                                        values[0]
                                                            .toString()
                                                            .trim();
                                                    // userLoginIdContactNo.text =
                                                    userContactNo = values[1]
                                                        .toString()
                                                        .trim();

                                                    String hideUserContactNo =
                                                        values[1]
                                                            .toString()
                                                            .trim()
                                                            .replaceRange(
                                                                2, 8, 'XXXXXX');

                                                    userLoginIdContactNo.text =
                                                        hideUserContactNo;
                                                    userOTPPhTrim = values[1]
                                                        .toString()
                                                        .trim()
                                                        .substring(values[1]
                                                                .toString()
                                                                .trim()
                                                                .length -
                                                            4);
                                                    print(values);
                                                  });
                                                } else if (responseData ==
                                                    'not_employee') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Enter Valid Id')));
                                                }
                                                userOTPAuth = responseData;
                                                return userBasicInfo =
                                                    responseData;
                                              });
                                            })
                                          }),
                                ],
                              )),

                          //Display Data
                          Visibility(
                              visible: hideUserId,
                              child: Column(
                                children: [
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enableInteractiveSelection: false,
                                    // will disable paste operation
                                    enabled: false,
                                    autofocus: false,
                                    keyboardType: TextInputType.phone,
                                    controller: userLoginIdCloud,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.person_pin_rounded),
                                        hintText: userLoginId.text,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enableInteractiveSelection: false,
                                    // will disable paste operation
                                    enabled: false,
                                    autofocus: false,
                                    keyboardType: TextInputType.name,
                                    controller: userLoginIdName,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        hintText: userLoginIdName.text,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enableInteractiveSelection: false,
                                    // will disable paste operation
                                    enabled: false,
                                    autofocus: false,
                                    keyboardType: TextInputType.phone,
                                    controller: userLoginIdContactNo,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.phone_android_outlined),
                                        hintText: userLoginIdContactNo.text,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 30.0),
                                  ElevatedButton(
                                      child: Text(
                                        '     Register     ',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      onPressed: () => {
                                            setState(() {
                                              getAuthOTP(
                                                      userLoginId.text
                                                          .trim()
                                                          .toString(),
                                                      userLoginIdName.text
                                                          .toString()
                                                          .trim(),
                                                      userLoginIdContactNo.text
                                                          .trim()
                                                          .toString())
                                                  .then((responseData) {
                                                if (responseData !=
                                                    'not_employee') {
                                                  setState(() {
                                                    visible = false;
                                                    hideUserId = false;
                                                    hideUserOTP = true;
                                                  });
                                                }

                                                return userBasicInfo =
                                                    responseData;
                                              });
                                            })
                                          }),
                                ],
                              )),

                          //OTP
                          Visibility(
                              visible: hideUserOTP,
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      child: Text('AGENT OTP',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: 'poppins_semibold',
                                            // fontWeight: FontWeight.w500
                                          ))),
                                  SizedBox(height: 60.0),
                                  TextFormField(
                                    maxLength: 5,
                                    obscureText: _isObscure,
                                    enableInteractiveSelection: false,
                                    // will disable paste operation
                                    autofocus: false,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: userLoginIdOTP,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        prefixIcon: Icon(Icons.input),
                                        hintText: 'Please enter OTP',
                                        hintStyle: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'poppins_semibold',
                                            color: Colors.grey),
                                        contentPadding: EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 60.0),
                                  ElevatedButton(
                                      child: Text(
                                        '       Submit      ',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      onPressed: () => {
                                            setState(() async {
                                              if (userOTPPhTrim.trim() ==
                                                  userLoginIdOTP.text
                                                      .toString()
                                                      .trim()) {
                                                visible = true;
                                                hideUserId = false;
                                                hideUserOTP = false;

                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    'userId',
                                                    userLoginId.text
                                                        .trim()
                                                        .toString());
                                                prefs.setString(
                                                    'userName',
                                                    userLoginIdName.text
                                                        .toString()
                                                        .trim());
                                                prefs.setString(
                                                    'contactNo',
                                                    userLoginIdContactNo.text
                                                        .trim()
                                                        .toString());
                                                prefs.setString(
                                                    'loginType', 'agent');

                                                userLoginId.clear();
                                                userLoginIdCloud.clear();
                                                userLoginIdName.clear();
                                                userLoginIdContactNo.clear();
                                                userLoginIdOTP.clear();

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AppDashboard(
                                                            loginType: 'agent',
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                // ignore: deprecated_member_use
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Enter Valid OTP')));
                                              }
                                            })
                                          }),
                                ],
                              ))

                          // futureBuilder()
                        ],
                      )),
                ))),
      ),
    );
  }

  Future<String> getUserBasicInfo(String loginId) async {
    final response = await http.post(Uri.parse(
        ApiConfig.BASE_URL + ApiConfig.GET_AGENT_USER_INFO + loginId));

    if (response.statusCode == 200) {
      print(response.body);
      String data = response.body.toString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConfig.PTEF_KEY_USERID, loginId);
      print("new list size: ${data}");
      return data;
    } else {
      throw Exception('Failed to load User Info');
    }
  }

  Future<String> getAuthOTP(
      String loginId, String userName, String userContactNo) async {
    String url = ApiConfig.BASE_URL +
        ApiConfig.GET_AUTH_AOTP_NUM +
        loginId +
        ApiConfig.GET_AUTH_AOTP_NAME +
        userName +
        ApiConfig.GET_AUTH_AOTP_CONTACT +
        userContactNo;
    debugPrint('Checking URL $url');
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      String data = response.body.toString();
      List phase = data.split(",");
      String apikey = phase[0];
      userOTPAuth = phase[1];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConfig.PREF_KEY_API_TOKEN, apikey);
      await prefs.setString(ApiConfig.PTEF_KEY_USER_TYPE, "user");
      print("new list size: ${data}");
      return data;
    } else {
      throw Exception('Failed to load User Info');
    }
  }
}
