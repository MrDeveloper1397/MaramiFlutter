import 'package:flutter/material.dart';
import 'package:mil/screens/landing_screen.dart';
import 'package:mil/screens/splash_screen.dart';
import 'package:mil/widgets/dashboard/Admin/ApprovedMembers.dart';
import 'package:mil/widgets/dashboard/Admin/ChangePin.dart';
import 'package:mil/widgets/dashboard/Admin/DayBookings.dart';
import 'package:mil/widgets/dashboard/Admin/DayCollectionWidget.dart';
import 'package:mil/widgets/dashboard/Admin/DayPaymentWidget.dart';
import 'package:mil/widgets/dashboard/Admin/PendingApprovals.dart';
import 'package:mil/widgets/dashboard/Admin/PlotMatrix.dart';
import 'package:mil/widgets/dashboard/dash_board.dart';
import 'package:mil/widgets/dashboard/pages/AssociateRecruitment.dart';
import 'package:mil/widgets/dashboard/pages/Notifications.dart';

import '../widgets/dashboard/Admin/PlotMatrixLandMark.dart';
import '../widgets/dashboard/pages/AssociateDownline.dart';
import '../widgets/dashboard/pages/AssociateSales.dart';

const String splashScreen = 'splash';
const String landingScreen = 'landing';
const String registrationPage = 'signUp';
const String appDashBoard = 'dashBoard';

//Dynamic Routes for generating navigation
const String pendingApprovals = "/PendingApprovals";
const String approvedMembers = "/ApprovedMembers";
const String plotMatrix = "/PlotMatrix";
const String plotMatrixLandMark = "/plotMatrixLandMark";
const String dayCollection = "/DayCollection";
const String dayPayments = "/DayPaymentWidget";
const String dayBookings = "/DayBookings";
const String changePin = "/ChangePin";
const String associateTree = "/AssociateTree";
const String agentAssociateTree = "/AgentAssociateTree";
const String associateSales = "/AssociateSales";
const String associateRecruitment = "/AssociateRecruitment";
const String notifications = "/Notifications";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return MaterialPageRoute(builder: (context) => MySplashScreen());
    case landingScreen:
      return MaterialPageRoute(builder: (context) => LandingScreen());
    case appDashBoard:
      return MaterialPageRoute(
          builder: (context) => AppDashboard(
                loginType: 'employee',
              ));

//for admin menu
    case pendingApprovals:
      return MaterialPageRoute(builder: (_) => PendingApprovals());
    case approvedMembers:
      return MaterialPageRoute(builder: (_) => ApprovedMembers());
    case plotMatrix:
      return MaterialPageRoute(builder: (_) => PlotMatrix());
    case plotMatrixLandMark:
      return MaterialPageRoute(builder: (_) => PlotMatrixLandMark());
    case dayCollection:
      return MaterialPageRoute(builder: (_) => DayCollectionWidget());

    case dayPayments:
      return MaterialPageRoute(builder: (_) => DayPaymentWidget());
    case dayBookings:
      return MaterialPageRoute(builder: (_) => DayBookings());
    case changePin:
      return MaterialPageRoute(builder: (_) => ChangePin());
    case associateTree:
      return MaterialPageRoute(builder: (_) => AssociateDownline());
    case associateSales:
      return MaterialPageRoute(builder: (_) => AssociateSales());
    case associateRecruitment:
      return MaterialPageRoute(builder: (_) => AssociateRecruitment());

    default:
      throw ('this route name does not exist');
  }
}
