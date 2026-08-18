import 'package:get/get.dart';
import '../../views/auth/presentation/signin_screen.dart';
import '../../views/auth/presentation/splash_screen.dart';
import '../../views/followup_form/heel_prick_blood_collection_form_screen.dart';
import '../../views/growth_monitoring/asset_form_screen.dart';
import '../../views/growth_monitoring/enrollment_form.dart';
import '../../views/growth_monitoring/growth_monitoring_form_screen.dart';
import '../../views/user_home/presentation/pages/infant_done_list_screen.dart';
import '../../views/user_home/presentation/pages/infant_list_screen.dart';
import '../../views/user_home/presentation/pages/pending_infant_list_screen.dart';
import '../../views/user_home/presentation/pages/todo_enrollment.dart';
import '../../views/user_home/presentation/pages/todo_growth_monitoring.dart';
import '../../views/user_home/presentation/pages/user_dashboard.dart';

class AppRoutes {
  static const String SPLASH = '/';
  static const String SIGNINSCREEN = '/sign_in';
  static const String HOMESCREEN = '/home';
  static const String INFANTLISTSCREEN = '/infant_list';
  static const String INFANTDONELISTSCREEN = '/infant_done_list';
  static const String FOLLOWUPFORMSCREEN = '/followup_form';
  static const String DONEFORMSCREEN = '/done_form';
  static const String HEELPRICKBLOODCOLLECTIONFORMSCREEN =
      '/heel_prick_blood_collection_form';
  static const String PENDINGINFANTLIST = '/pending_infant_list';
  static const String ENROLLMENTFORM = '/enrollment_form';
  static const String TODOENROLLMENT = '/todo_enrollment';
  static const String TODOGROWTHMONITORING = '/todo_growth_monitoring';
  static const String GROWTHMONITORINGFORM = '/growth_monitoring_form';
  static const String ASSETFORMSCREEN = '/asset_form';

  static List<GetPage> routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(
      name: SIGNINSCREEN,
      page: () => SigninScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: HOMESCREEN,
      page: () => UserDashboard(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: INFANTLISTSCREEN,
      page: () => InfantListScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: INFANTDONELISTSCREEN,
      page: () => InfantDoneListScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: HEELPRICKBLOODCOLLECTIONFORMSCREEN,
      page: () => HeelPrickBloodCollectionFormScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: PENDINGINFANTLIST,
      page: () => PendingInfantListScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: ENROLLMENTFORM,
      page: () => EnrollmentFormScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: TODOENROLLMENT,
      page: () => TodoEnrollment(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: TODOGROWTHMONITORING,
      page: () => TodoGrowthMonitoring(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: GROWTHMONITORINGFORM,
      page: () => GrowthMonitoringFormScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: ASSETFORMSCREEN,
      page: () => AssetFormScreen(),
      transitionDuration: Duration(milliseconds: 100),
      transition: Transition.cupertino,
    ),
  ];
}
