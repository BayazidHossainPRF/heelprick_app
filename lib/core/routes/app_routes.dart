import 'package:get/get.dart';
import '../../views/auth/presentation/signin_screen.dart';
import '../../views/auth/presentation/splash_screen.dart';
import '../../views/followup_form/heel_prick_blood_collection_form_screen.dart';
import '../../views/user_home/presentation/pages/infant_done_list_screen.dart';
import '../../views/user_home/presentation/pages/infant_list_screen.dart';
import '../../views/user_home/presentation/pages/user_dashboard.dart';

class AppRoutes {
  static const String SPLASH = '/';
  static const String SIGNINSCREEN = '/sign_in';
  static const String HOMESCREEN = '/home';
  static const String INFANTLISTSCREEN = '/infant_list';
  static const String INFANTDONELISTSCREEN = '/infant_done_list';
  static const String FOLLOWUPFORMSCREEN = '/followup_form';
  static const String DONEFORMSCREEN = '/done_form';
  static const String HEELPRICKBLOODCOLLECTIONFORMSCREEN = '/heel_prick_blood_collection_form';

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

  ];
}
