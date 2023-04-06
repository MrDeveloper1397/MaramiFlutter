import 'package:mil/models/ApprovalData.dart';
import 'package:mil/models/Approvallist.dart';

class ApiConfig {
  static const String APP_ENV = String.fromEnvironment('MIL_ENV');
  // static final String BASE_URL="http://183.82.126.49:7777/TriColor/";
  // static final String BASE_URL='http://183.82.126.49:7777/TriColorTest/';
  // static final String BASE_URL=getApiIfo(APP_ENV);
  static final BASE_URL = getApiIfo(APP_ENV).apiURL;

  static String imageurl = getApiIfo(APP_ENV).imgURL;
  static String COMPANY_ID = getApiIfo(APP_ENV).companyId;

  // Dashboards URL's
  static String GET_HOME_SCREEN_DATA =
      BASE_URL + '/getHomeScr_data?CompanyId=' + COMPANY_ID;

  static String GET_USER_INFO = "get_Emp_data?EmpId=";
  static String GET_AGENT_USER_INFO = "User_reg.php?AgentCd=";
  static String GET_CMPY_PROJECT =
      BASE_URL + 'getProjects_data?CompanyId=' + COMPANY_ID;

  //Available Plots
  static String GET_AVAILABLE_PLOTS = BASE_URL + 'AvailablePlots';
  static String GET_VACANT_PLOTS = BASE_URL + 'GetVacantList.php?ventureid=';

  // OTP
  static String GET_AUTH_OTP_NUM = "Employee_reg.php?Emp_No=";
  static String GET_AUTH_OTP_NAME = "&Emp_Name=";
  static String GET_AUTH_OTP_CONTACT = "&Emp_Mob=";

  static String GET_AUTH_AOTP_NUM = "Agent_reg.php?Emp_No=";
  // static String GET_AUTH_AOTP_NUM="Agent_reg.php?Empand on_No=";
  static String GET_AUTH_AOTP_NAME = "&Emp_Name=";
  static String GET_AUTH_AOTP_CONTACT = "&Emp_Mob=";

  static String GET_PLOT_MATRIX_ALLOTMENT =
      BASE_URL + 'PlotMatrixFacingData?Venture=';
  // static String GET_PLOT_MATRIX_PLOTS_DETAILS = BASE_URL+'PlotMatrixFacingData?Venture=';
  static String GET_PLOT_MATRIX_PLOTS_DETAILS =
      BASE_URL + 'PlotMatrixPlotData?Venture=';

  //Associate Downline Actions
  // http://183.82.40.106:7777/TriColor/GetAssocaitiveTreeEmployee.php?AssociateID=1101&VentureCode=AE&reportID=123
  static String GET_EMP_ASSOCIATIVE_TREE =
      BASE_URL + 'GetAssocaitiveTreeEmployee.php?AssociateID=';
  static String GET_EMP_AGENT_ASSOCIATIVE_TREE =
      BASE_URL + 'GetAssocaitiveTree?ApiKey=';

  //Associate Sales Actions
  static String GET_EMP_ASSOCIATIVE_SALES =
      BASE_URL + 'AssociativeSalesEmp?reportID=';

  static String GET_EMP_AGENT_ASSOCIATIVE_SALES =
      BASE_URL + 'getAssociativeSales?AgentID=';

  // Loading Images Base URL
  static String LOAD_IMAGES_BASE_URL =
      'http://183.82.40.106:7777/mobilemodule1';

  //PROFILE
  static String GET_PROFILE_COMPANY = "AgentProfile?CompanyId=";

  static String RESERVE_PLOT_MATRIX = BASE_URL + 'changeStatus?VentureId=';

  //ADMIN PIN
  static String GET_PIN_CHECK_ID = "Admin_pin_check.php?Id=";
  static String GET_PIN_CHECK_PIN = "&Pin=";

  //Approved Member
  static List<ApprovalData> utiPassbookList = <ApprovalData>[];
  static List<Approvallist> utiplistdata = <Approvallist>[];

  //ADMIN MENU COLLECTION
  static String GET_COLLECTION_DATA_ADMIN_MENU =
      BASE_URL + "GetCollectionData?ApiKey=";

  //change pin
  static String PIN_CHANGE_ID = "Change_Admin_Pin.php?Id=";
  static String PIN_CHANGE_PIN = "&Pin=";

  // Loading Images Base URL

  // ignore: non_constant_identifier_names
  static final String PREF_KEY_AUTH_VALUE = "AUTH_VALUE";
  // ignore: non_constant_identifier_names
  static final String PREF_KEY_CURR_NAME = "USER_NAME";
  // ignore: non_constant_identifier_names
  static final String PREF_KEY_CURR_MOBILE = "USER_MOBILE";
  // ignore: non_constant_identifier_names
  static final String PREF_KEY_API_TOKEN = "API_KEY";
  // ignore: non_constant_identifier_names
  static final String PTEF_KEY_USER_TYPE = "USER_TYPE";
  static final String PTEF_KEY_USERID = "USERID";

  static double Totalcom = 0.0;
}

RootInfo getApiIfo(appEnv) {
  switch (appEnv) {
    case '.tc':
      return RootInfo('Tri685071608', 'http://183.82.126.49:7777/TriColor/',
          'http://183.82.40.106:7777/mobilemodule1/');
    case '.ssv':
      return RootInfo(
          'Roy1720991764',
          'http://183.82.54.218:8080/RoyalNirmanInfra/',
          'http://183.82.54.218:8080/RoyalNirmanInfra/');
    case '.landmark':
      return RootInfo(
          'Lan110901517',
          'http://183.82.40.106:7777/SRLandmarkMultipleDBFlutter/',
          'http://183.82.40.106:7777/mobilemodule1/');

    case '.newvision':
      return RootInfo(
          'New1225980771',
          'http://183.82.40.106:7777/NewVisionInfra/',
          'http://183.82.40.106:7777/mobilemodule1/');

    case '.gp':
      return RootInfo('Goo23481', 'http://183.82.40.106:7777/GoogeeFlutter/',
          'http://183.82.40.106:7777/mobilemodule1/');

    case '.pragati':
      return RootInfo('Pra889776621', 'http://183.82.40.106:7777/PragatiNew/',
          'http://183.82.40.106:7777/mobilemodule1/');
  }

  return RootInfo('Tri685071608', 'http://183.82.126.49:7777/TriColor',
      'http://183.82.54.218:8080/MilTaskMobileModule/');
}

class RootInfo {
  final String companyId;
  final String apiURL;
  final String imgURL;

  RootInfo(this.companyId, this.apiURL, this.imgURL);
}
