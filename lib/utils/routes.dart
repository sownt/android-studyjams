import 'package:android_studyjams/presentation/controller/home_controller.dart';
import 'package:android_studyjams/presentation/controller/main_controller.dart';
import 'package:android_studyjams/presentation/controller/result_controller3.dart';
import 'package:android_studyjams/presentation/view/home_page.dart';
import 'package:android_studyjams/presentation/view/main_page.dart';
import 'package:android_studyjams/presentation/view/not_found.dart';
import 'package:android_studyjams/presentation/view/result_page3.dart';
import 'package:android_studyjams/utils/strings.g.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static const main = '/';
  static const notFound = '/not_found';
  static const home = '/home';
  static const result = '/result/:id';

  static final fallback = GetPage(
    name: notFound,
    page: () => const NotFound(),
  );

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => HomePage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
    GetPage(
      name: result,
      page: () => ResultPage3(),
      binding: BindingsBuilder(() {
        Get.put(ResultController3());
      }),
    ),
    GetPage(
      name: main,
      page: () => MainPage(),
      binding: BindingsBuilder(
        () {
          Get.put(MainController());
        },
      ),
    ),
  ];

  static String onGenerateTitle(context) {
    if (Get.currentRoute == AppRoutes.home) {
      return AppStrings.homePage.tr;
    } else if (Get.currentRoute == AppRoutes.result) {
      return AppStrings.result.tr;
    } else if (Get.currentRoute == AppRoutes.notFound) {
      return AppStrings.pageNotFound.tr;
    } else if (Get.currentRoute == AppRoutes.main) {
      return AppStrings.name.tr;
    }
    return AppStrings.appTitle.tr;
  }
}
