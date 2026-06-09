// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// import '../core/const/app_secrets.dart';
// import '../core/localDB/data_db.dart';
// import '../core/prefs/user_prefs.dart';
// import '../core/theme/app_pallete.dart';


// class ServerQueryController extends GetxController {
//   static ServerQueryController get to => Get.find();

//   RxBool isLoading = false.obs;

//   void getServerQuery() async {
//     isLoading.value = true;
//     final String? userId = (await UserPrefs.getUser()).userId;
//     if (userId == null) {
//       Get.showSnackbar(
//         GetSnackBar(
//           title: 'Failed',
//           message: 'User id not found. Relogin and try again',
//           duration: Duration(seconds: 4),
//           backgroundColor: AppPallete.dangerColor,
//         ),
//       );
//     }
//     Uri url = Uri.parse('${AppSecrets.host}/getServerQuery.php?userId=$userId');
//     print(url.toString());
//     http
//         .get(url)
//         .then((response) async {
//           print('Response status: ${response.statusCode}');
//           print('response body: ${response.body}');

//           if (response.statusCode == 200) {
//             final List<dynamic> data = json.decode(response.body)['data'];
//             for (dynamic item in data) {
//               final res = await DataDb.instance.executeRawQuery(
//                 query: item['query'],
//               );
//               if (res) {
//                 Get.showSnackbar(
//                   GetSnackBar(
//                     title: 'Server query run success',
//                     message: '${item['sl']} run successfully',
//                     duration: Duration(seconds: 2),
//                     backgroundColor: AppPallete.acceptColor,
//                   ),
//                 );
//                 http.get(
//                   Uri.parse(
//                     '${AppSecrets.host}/updateServerQuery.php?sl=${item['sl']}',
//                   ),
//                 );
//               } else {
//                 Get.showSnackbar(
//                   GetSnackBar(
//                     title: 'Server query run Failed',
//                     message: '${item['sl']} run failed',
//                     duration: Duration(seconds: 2),
//                     backgroundColor: AppPallete.dangerColor,
//                   ),
//                 );
//               }
//               await Future.delayed(Duration(seconds: 1));
//             }
//             isLoading.value = false;
//             // DataDb.instance.executeRawQuery(query: );
//           } else {
//             Get.showSnackbar(
//               GetSnackBar(
//                 title: 'Failed',
//                 message: 'Query get failed. ${response.statusCode}',
//                 duration: Duration(seconds: 5),
//                 backgroundColor: AppPallete.dangerColor,
//               ),
//             );
//             isLoading.value = false;
//           }
//         })
//         .catchError((error) {
//           print(error);
//           Get.showSnackbar(
//             GetSnackBar(
//               title: 'Failed',
//               message: 'Exception : $error',
//               duration: Duration(seconds: 10),
//               backgroundColor: AppPallete.dangerColor,
//             ),
//           );
//           isLoading.value = false;
//         });
//   }
// }
