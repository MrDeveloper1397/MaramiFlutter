import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Styling.dart';
import 'dashboard/dash_board.dart';

class GuestLogin extends StatefulWidget {
  const GuestLogin({Key? key}) : super(key: key);

  @override
  State<GuestLogin> createState() => _GuestLoginState();
}

TextEditingController userLoginIdName = TextEditingController();
TextEditingController userLoginIdContactNo = TextEditingController();
TextEditingController userLoginIdOTP = TextEditingController();

String userName = '';
String userContactNo = '';
String guestUserOTP = '';

bool showUserLogin = true;
bool showOTPAuth = false;

bool _isObscure = true;

class _GuestLoginState extends State<GuestLogin> {
  @override
  void initState() {
    super.initState();
    showUserLogin = true;
    showOTPAuth = false;

    userLoginIdName.clear();
    userLoginIdContactNo.clear();
    userLoginIdOTP.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              // elevation: 20,
              margin: EdgeInsets.fromLTRB(10, 20, 1, 20),
              // margin: EdgeInsets.all(10),
              child: Form(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Visibility(
                            visible: showUserLogin,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Text('GUEST REGISTRATION',
                                        style: TextStyle(
                                          fontFamily: 'poppins_regular',
                                          fontSize: 20,
                                          // color: Theme.of(context).primaryColor,
                                          color: Colors.black,
                                          // fontWeight: FontWeight.w500
                                        ))),
                                SizedBox(height: 40.0),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          // BoxShadow(
                                          // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                                        ],
                                      ),
                                      child: TextFormField(
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        maxLength: 14,
                                        keyboardType: TextInputType.name,
                                        controller: userLoginIdName,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            hintText: 'Enter Name',
                                            prefixIcon: Icon(Icons.person),
                                            contentPadding: EdgeInsets.all(16),
                                            border: OutlineInputBorder()),
                                      ),
                                    )),
                                SizedBox(height: 10.0),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          // BoxShadow(
                                          // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                                        ],
                                      ),
                                      child: TextFormField(
                                        maxLength: 14,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: userLoginIdContactNo,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            hintText: 'Enter Mobile Number',
                                            hintStyle: TextStyle(
                                                fontFamily: 'poppins_semibold'),
                                            prefixIcon:
                                                Icon(Icons.phone_android),
                                            contentPadding: EdgeInsets.all(16),
                                            border: OutlineInputBorder()),
                                      ),
                                    )),
                                SizedBox(height: 20.0),
                                ElevatedButton(
                                    child: Text(
                                      '       Save       ',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    onPressed: () => {
                                          setState(() {
                                            debugPrint(
                                                'Check Number.....${validateMobile(userLoginIdContactNo.text.toString().trim())}');

                                            if ((userLoginIdName.text
                                                        .toString()
                                                        .trim()
                                                        .length >=
                                                    2) &&
                                                validateMobile(
                                                    userLoginIdContactNo.text
                                                        .toString()
                                                        .trim())) {
                                              showUserLogin = false;
                                              showOTPAuth = true;
                                              guestUserOTP =
                                                  userLoginIdContactNo.text
                                                      .toString()
                                                      .trim()
                                                      .substring(
                                                          userLoginIdContactNo
                                                                  .text
                                                                  .toString()
                                                                  .trim()
                                                                  .length -
                                                              4);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Enter valid username & number.')));
                                            }
                                          })
                                        }),
                              ],
                            )),

                        Visibility(
                            visible: showOTPAuth,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Text('GUEST OTP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontFamily: 'poppins_semibold',
                                        ))),
                                SizedBox(height: 60.0),
                                TextFormField(
                                  maxLength: 5,
                                  obscureText: _isObscure,
                                  enableInteractiveSelection: false,
                                  // will disable paste operation
                                  autofocus: false,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: userLoginIdOTP,
                                  decoration: const InputDecoration(
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
                                          color: Colors.redAccent,
                                        ),
                                      )),
                                ),
                                SizedBox(height: 60.0),
                                ElevatedButton(
                                  child: Text(
                                    '       Submit      ',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  onPressed: () => {
                                    if (userLoginIdOTP.text.toString().trim() ==
                                        guestUserOTP.trim())
                                      {
                                        setState(() {
                                          showUserLogin = true;
                                          showOTPAuth = false;

                                          userLoginIdName.clear();
                                          userLoginIdContactNo.clear();
                                          userLoginIdOTP.clear();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppDashboard(
                                                          loginType: 'guest')));
                                        })
                                      }
                                    else
                                      {
                                        // ignore: deprecated_member_use
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Enter Valid OTP')))
                                      }
                                  },
                                ),
                              ],
                            )),

                        // futureBuilder()
                      ],
                    )),
              )) /*SingleChildScrollView(
            child: ),*/
          ),
    );
  }

  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      // return 'Please enter mobile number';
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
