import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_config/api_config.dart';
import '../../../models/GetCadres.dart';
import '../../../models/GetNewAgentDetails.dart';
import '../../../models/NewIDCreation.dart';
import '../../../models/user_info.dart';
import '../../Styling.dart';

class AssociateRecruitment extends StatefulWidget {
  AssociateRecruitment({Key? key}) : super(key: key);

  @override
  State<AssociateRecruitment> createState() => _AssociateRecruitmentState();
}

class _AssociateRecruitmentState extends State<AssociateRecruitment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Associate Recruitment",
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      body: FutureBuilder<Widget>(
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
      ),
    );
  }

  Future<Widget> fetchUserInfo(http.Client client, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String? usertype = prefs.getString(ApiConfig.PTEF_KEY_USER_TYPE);
    String GET_PROFILE_APIKEY = "&ApiKey=" + apikey!.trimLeft();
    String GET_PROFILE_USER = "&UserType=" + usertype!;

    debugPrint("apikey......${apikey}");
    String url = ApiConfig.BASE_URL +
        ApiConfig.GET_PROFILE_COMPANY +
        ApiConfig.COMPANY_ID +
        GET_PROFILE_APIKEY +
        GET_PROFILE_USER;

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      debugPrint('Check Response.....${response.body}');
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
            children: [
              Padding(
                padding: EdgeInsets.all(10), //apply padding to all four sides
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // color: Colors.white,
                    elevation: 15,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        alignment: FractionalOffset.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10.0, 20.0, 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'ID            ' ': ' +
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
                                  'Name         ' ':  ' +
                                      userInfo.name.toString().trim(),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Mobile        ' ': ' +
                                      ((userInfo.mobile.toString() != 'null')
                                          ? userInfo.mobile.toString()
                                          : ' '),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Cadre          ' ': ' +
                                      ((userInfo.cadre.toString() != 'null')
                                          ? userInfo.cadre.toString()
                                          : ' '),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ],
                            )))),
              ),
              NewAgent()
            ],
          ),
        );
      }
    }
    return Container();
  }
}

//http://183.82.126.49:7777/TriColor/AddNewAgent?action=getCadres&ApiKey=01bdf9bc0e3aff54a9077d79b6a17789&UserType=user
//final String baseURL = ApiConfig.BASE_URL + "AddNewAgent?action=getCadres&ApiKey=c32fc90fb2371e0ff940ca19e80bd720&UserType=user";
class NewAgent extends StatefulWidget {
  @override
  State<NewAgent> createState() => _NewAgent();
}

class _NewAgent extends State<NewAgent> {
  List<String> _cadreList = [];
  String? _selectedCadre;
  String? _enterdName = '' ?? '';
  String? _enteredNumber = '';
  String? _enteredEmail = '';
  final _mailformKey = GlobalKey<FormState>();
  final _mobilenoformKey = GlobalKey<FormState>();

  String _mail = '';
  String _mobnumber = '';

  TextEditingController newusername = TextEditingController();
  TextEditingController newusermail = TextEditingController();
  TextEditingController newuserphone = TextEditingController();

  var listagents = List<NewAgentDetails>;

  String message = '', agentid = '', seniourid = '';
  bool hideBtnAppoint = false;
  bool isPanNo = false, isAadhar = false;
  String base64Image = '';

  @override
  void initState() {
    super.initState();
    _fetchCadreList();
    newusermail.clear();
    newuserphone.clear();
    newusername.clear();
  }

  void _fetchCadreList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
      String? usertype = prefs.getString(ApiConfig.PTEF_KEY_USER_TYPE);
      String GET_PROFILE_APIKEY = "&ApiKey=" + apikey!.trimLeft();
      String GET_PROFILE_USER = "&UserType=" + usertype!;

      debugPrint("apikey......${apikey}");
      String url = ApiConfig.BASE_URL +
          "AddNewAgent?action=" +
          "getCadres" +
          GET_PROFILE_APIKEY +
          GET_PROFILE_USER;
      final response = await http.get(Uri.parse(url));
      //'http://183.82.126.49:7777/TriColor/AddNewAgent?action=getCadres&ApiKey=7953bc72835bfca6bebb40f51249fa32&UserType=user'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final cadreList = CadreList.fromJson(jsonResponse);

        setState(() {
          _cadreList =
              cadreList.result?.cadrelist?.map((e) => e.agentCadre!).toList() ??
                  [];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text(
        "New Associate",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: 'Roboto',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          height: 2,
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(10),
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
              inputFormatters: [UpperCaseTextFormatter()],
              // Capital first letter
              keyboardType: TextInputType.name,
              maxLength: 14,
              controller: newusername,
              decoration: const InputDecoration(
                  counterText: "",
                  hintText: 'Associate Name',
                  hintStyle: TextStyle(fontFamily: 'poppins_semibold'),
                  prefixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  _enterdName = value;
                });
              },
            ),
          )),
      Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                // BoxShadow(
                // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
              ],
            ),
            child: Form(
              key: _mobilenoformKey,
              child: TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.phone,
                controller: newuserphone,
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: 'Associate Mobile',
                  hintStyle: TextStyle(fontFamily: 'poppins_semibold'),
                  prefixIcon: Icon(Icons.phone_android),
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Define regex for valid phone number pattern
                  final RegExp regex = RegExp(r'^[6-9]\d{9}$');
                  // Check if entered phone number matches regex pattern
                  if (!regex.hasMatch(value!)) {
                    return 'Please enter a valid phone number';
                  } else if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobnumber = value!;
                },
                onChanged: (value) {
                  setState(() {
                    _enteredNumber = value;
                  });
                },
              ),
            ),
          )),
      Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  // BoxShadow(
                  // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                ],
              ),
              child: Form(
                  key: _mailformKey,
                  child: TextFormField(
                    //  maxLength: 14,
                    keyboardType: TextInputType.emailAddress,
                    controller: newusermail,
                    decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Associate Email',
                        hintStyle: TextStyle(fontFamily: 'poppins_semibold'),
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.all(16),
                        // errorText: Email
                        border: OutlineInputBorder()),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _mail = value!;
                    },

                    onChanged: (value) {
                      // validateEmail(value);
                      setState(() {
                        _enteredEmail = value;
                      });
                    },
                  )))),
      Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8)),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCadre,
                  onChanged: (value) {
                    setState(() {
                      _selectedCadre = value;
                    });
                  },
                  items: _cadreList
                      .map(
                        (cadre) => DropdownMenuItem<String>(
                          value: cadre,
                          child: Text(cadre),
                        ),
                      )
                      .toList(),
                ),
              ))),
      SizedBox(height: 10.0),
      ElevatedButton(
        child: Text(
          'Create New Associate',
          style: TextStyle(color: Colors.white),
        ),
        // onPressed: save,
        style: ElevatedButton.styleFrom(
          // primary: Color.fromRGBO(23, 152, 185, 100),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        ),

        onPressed: () async {
          fetchAgentDetails(http.Client());
        },
      ),
      SizedBox(height: 3.0),
      Visibility(
          visible: hideBtnAppoint,
          child: Column(
            children: [
              message == 'New Associative Added Successfully'
                  ? Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image.asset(
                          'assets/images/associatecreated-removebg-preview.png'),
                    )
                  : Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image.asset('assets/images/exist.png'),
                    ),
              ElevatedButton(
                child: Text(
                  '     Appointment     ',
                  style: TextStyle(color: Colors.white),
                ),
                // onPressed: save,
                style: ElevatedButton.styleFrom(
                  // primary: Color.fromRGBO(23, 152, 185, 100),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => RecruitmentAppoint("PanVal": isPanNo,"AadharVal":isAadhar, pan: null,),
                      builder: (context) => RecruitmentAppoint(
                          pan: isPanNo,
                          aadhar: isAadhar,
                          name: _enterdName!,
                          newAgentId: agentid,
                          seniorId: seniourid),
                    ),
                  );
                },
              ),
            ],
          ))
    ]));
  }

  void fetchAgentDetails(http.Client client) async {
    String cadre = _selectedCadre ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String? usertype = prefs.getString(ApiConfig.PTEF_KEY_USER_TYPE);
    String GET_PROFILE_APIKEY = "&ApiKey=" + apikey!.trimLeft();
    String GET_PROFILE_USER = "&UserType=" + usertype!;
    if (_enterdName!.isNotEmpty &&
        _enteredNumber!.isNotEmpty &&
        cadre!.isNotEmpty &&
        _enteredEmail!.isNotEmpty &&
        _mailformKey.currentState!.validate() &&
        _mobilenoformKey.currentState!.validate()) {
      String apiUrl = (ApiConfig.BASE_URL +
          "AddNewAgent?action=postagent" +
          GET_PROFILE_APIKEY +
          GET_PROFILE_USER +
          "&name=$_enterdName&mobile=$_enteredNumber&Cadre=$cadre&Email=$_enteredEmail");

      print(apiUrl);

      try {
        final response = await http.post(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          print('Data sent successfully.');
          var decodedJson = json.decode(response.body);
          debugPrint('Check response....${response.body}');
          String status = decodedJson['status'].toString();
          message = decodedJson['message'].toString();
          debugPrint('Status value...${status}');
          if (status == 'fail') {
          } else {
            if (message == 'New Associative Added Successfully') {
              setState(() {
                final userInfo = NewUserResult.fromJson(decodedJson['result']);
                agentid = userInfo.userdata!.newAgentId.toString();
                debugPrint(
                    'New Agent Id...${userInfo.userdata!.newAgentId.toString()}');
                hideBtnAppoint = true;
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: message.toString(),
                );
              });
            } else if (message == 'This Associative Is Already Exist') {
              setState(() {
                final userInfo = UserResult.fromJson(decodedJson['result']);
                agentid = userInfo.userdata!.agentId.toString();
                seniourid = userInfo.userdata!.seniourId.toString();
                isAadhar = userInfo.userdata!.isAadhar!;
                isPanNo = userInfo.userdata!.isPan!;
                debugPrint('Agent Id...${userInfo.userdata!.agentId.toString()}'
                    'Seniour Id...${userInfo.userdata!.seniourId.toString()}');
                hideBtnAppoint = true;
                /*ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message.toString())));*/
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: 'Warning!',
                  text: message.toString(),
                );
                //final CadresList = userInfo.cadre;
              });
            }
          }
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning!',
        text: 'Please make sure all fields are filled out correctly.',
      );
    }
  }
}

//nxt page after click on appointment
class RecruitmentAppoint extends StatefulWidget {
  final bool pan;
  final bool aadhar;
  final String name;
  final String newAgentId;
  final String seniorId;

  const RecruitmentAppoint(
      {required this.pan,
      required this.aadhar,
      required this.name,
      required this.newAgentId,
      required this.seniorId});

  @override
  State<RecruitmentAppoint> createState() =>
      _RecruitmentAppoint(pan, aadhar, name, newAgentId, seniorId);
}

class _RecruitmentAppoint extends State<RecruitmentAppoint> {
  final _panformKey = GlobalKey<FormState>();
  final _aadharformKey = GlobalKey<FormState>();

  bool _hidePan = true;
  bool _hideAadhar = true;
  String _assocaitename = '';
  String newAgentid = '';
  String seniorId = '';

  TextEditingController _panno = TextEditingController();
  TextEditingController _aadharno = TextEditingController();
  FlutterValidation validator = new FlutterValidation();

  var _image;

  String _cardno = '',
      _cardtype = '',
      _usertype = '',
      _status1 = '',
      _status2 = '';

  var flavorType;

  _RecruitmentAppoint(isPanNo, isAadhar, name, newAgentid, seniorid) {
    this._hideAadhar = isAadhar;
    this._hidePan = isPanNo;
    this._assocaitename = name;
    this.newAgentid = newAgentid;
    this.seniorId = seniorid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _panno.clear();
    _aadharno.clear();
  }

  //api calling
  late File? imgFile = null;
  final imgPicker = ImagePicker();

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Choose a Picture",
                style: TextStyle(
                    fontFamily: "poppins_semibold",
                    color: Colors.red,
                    fontSize: 18.0)),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      funcConvert(imgFile!);
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      funcConvert(imgFile!);
    });
    Navigator.of(context).pop();
  }

  void funcConvert(File path) {
    Uint8List bytes = path.readAsBytesSync();
    String base64Image = base64Encode(bytes);
    print(base64Image);
    uploadImages(base64Image);
  }

  void uploadImages(String base64Image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login_type = prefs.getString("loginType");
    if (login_type == 'agent') {
      _usertype = "A";
    } else {
      _usertype = "M";
    }
    Map<String, String> MapParams = {
      "carddata": base64Image,
      "scantype": "JPG",
      "usertype": _usertype,
      "cardtype": _cardtype,
      "venturecd": "",
      "passbook": newAgentid!,
      "name": _assocaitename,
      "cardno": _cardno,
    };

    final response = await http.post(
        Uri.parse(ApiConfig.BASE_URL + "IdCardUploding"),
        body: MapParams);
    debugPrint('$response');

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Updated Successfully!',
      );
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var ventureId = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        // show the snackbar with some text
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              //run this and show me
            ),
            title: Text(
              "Associate Recruitment",
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        // BoxShadow(
                        // color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Visibility(
                            visible: !_hidePan,
                            child: Form(
                              key: _panformKey,
                              child: TextFormField(
                                maxLength: 14,
                                keyboardType: TextInputType.text,
                                inputFormatters: [UpperCaseTextFormatter()],
                                // Capital first letter
                                controller: _panno,
                                decoration: InputDecoration(
                                    counterText: "",
                                    hintText: 'Enter Pan Number',
                                    hintStyle: TextStyle(
                                        fontFamily: 'poppins_semibold'),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.upload),
                                      onPressed: () {
                                        setState(() {
                                          if (_panformKey.currentState!
                                              .validate()) {
                                            _status1 = "clicked";
                                            showOptionsDialog(context);
                                          }
                                        });
                                      },
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  bool result = validator.panValidate(
                                      content: _panno.text);
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your pan number';
                                  } else if (!RegExp(
                                          r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid Pan Number';
                                  } else if (result == false) {
                                    return 'Please enter a valid Pan Number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _cardno = _panno.text;
                                    _cardtype = 'P';
                                  });
                                },
                                onSaved: (value) {
                                  _hidePan = value! as bool;
                                },
                              ),
                            ))
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [],
                    ),
                    child: Column(
                      children: [
                        Visibility(
                            visible: !_hideAadhar,
                            child: Form(
                              key: _aadharformKey,
                              child: TextFormField(
                                maxLength: 12,
                                controller: _aadharno,
                                // keyboardType: TextInputType.number,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'Enter Aadhar Number',
                                  hintStyle:
                                      TextStyle(fontFamily: 'poppins_semibold'),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.upload),
                                    onPressed: () {
                                      if (_aadharformKey.currentState!
                                          .validate()) {
                                        _status2 = "clicked";
                                        showOptionsDialog(context);
                                      }
                                    },
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  bool result = validator.aadhaarValidate(
                                      content: _aadharno.text);
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Aadhar card number';
                                  } else if (value.length != 12) {
                                    return 'Please enter a 12-digit Aadhar card number';
                                  } else if (int.tryParse(value) == null) {
                                    return 'Please enter only digits in your Aadhar card number';
                                  } else if (result == false) {
                                    return 'Please enter valid Aadhar Number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _cardno = _aadharno.text;
                                    _cardtype = 'A';
                                  });
                                },
                                onSaved: (value) {
                                  _hideAadhar = value! as bool;
                                },
                              ),
                            )),
                      ],
                    ),
                  )),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: ElevatedButton(
                    child: Text(
                      '     APPOINT TO VENTURE     ',
                      style: TextStyle(color: Colors.white),
                    ),
                    // onPressed: save,
                    style: ElevatedButton.styleFrom(
                      // primary: Color.fromRGBO(23, 152, 185, 100),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    onPressed: () async {
                      setState(() {
                        // if (_panno.text.isNotEmpty && _status1.isNotEmpty && _aadharno.text.isNotEmpty && _status2.isNotEmpty)
                        if (_panno.text.isNotEmpty &&
                            _status1.isNotEmpty &&
                            _aadharno.text.isNotEmpty &&
                            _status2.isNotEmpty) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Do you want to Appoint to Venture?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            onConfirmBtnTap: () =>
                                appointToVenture(http.Client()),
                            confirmBtnColor: Colors.green,
                          );
                          //  appointToVenture(http.Client());
                        } else if (_hidePan && _hideAadhar) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Do you want to Appoint to Venture?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            onConfirmBtnTap: () =>
                                appointToVenture(http.Client()),
                            confirmBtnColor: Colors.green,
                          );
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'Warning!',
                            text: 'Enter the fields with images are mandatory',
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void appointToVenture(http.Client client) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.getString(ApiConfig.PREF_KEY_API_TOKEN);
    String? usertype = prefs.getString(ApiConfig.PTEF_KEY_USER_TYPE);
    String GET_PROFILE_APIKEY = "&ApiKey=" + apikey!.trimLeft();
    String GET_PROFILE_USER = "&UserType=" + usertype!;

    String apiUrl = (ApiConfig.BASE_URL +
        "AddNewAgent?action=insertagent" +
        GET_PROFILE_APIKEY +
        GET_PROFILE_USER +
        "&agentid=$newAgentid" +
        "&seniourid=$seniorId");
    debugPrint('InsertAgent...${apiUrl}');
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      String status = jsonResponse['status'].toString();

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Associate Added Successfully for all Ventures.',
      ).then((_) {
        Navigator.pop(context);
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
