import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/grocery_store/GroceryHome.dart';
import 'package:share_a_bite/grocery_store/GroceryRegister.dart';
import 'package:share_a_bite/grocery_store/GroceryVerify.dart';
import 'package:share_a_bite/login/GroceryLogin.dart';
import 'package:share_a_bite/login/GuestLogin.dart';
import 'package:share_a_bite/login/MainLogin.dart';
import 'package:share_a_bite/login/NgoOpLogin.dart';
import 'package:share_a_bite/login/NgoVolLogin.dart';
import 'package:share_a_bite/login/RestroLogin.dart';
import 'package:share_a_bite/login/RuDeliverLogin.dart';
import 'package:share_a_bite/login/RuOpLogin.dart';
import 'package:share_a_bite/ngo_operator/NgoHome.dart';
import 'package:share_a_bite/ngo_operator/NgoRegister.dart';
import 'package:share_a_bite/ngo_operator/NgoVerify.dart';
import 'package:share_a_bite/onboarding/SplashScreen.dart';
import 'package:share_a_bite/onboarding/carousel.dart';
import 'package:share_a_bite/recycling_unit/RuHome.dart';
import 'package:share_a_bite/recycling_unit/RuRegister.dart';
import 'package:share_a_bite/recycling_unit/RuVerify.dart';
import 'package:share_a_bite/restro/DistributeForm.dart';
import 'package:share_a_bite/restro/RestroHome.dart';
import 'package:share_a_bite/restro/RestroVerify.dart';

appRoutes() => [
      GetPage(
        name: '/SplashScreen',
        page: () => const SplashScreen(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/carousel',
        page: () => const IntroCarousel(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/MainLogin',
        page: () => const MainLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RestroLogin',
        page: () => const RestroLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GroceryLogin',
        page: () => const GroceryLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoVolLogin',
        page: () => const NgoVolLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoOpLogin',
        page: () => const NgoOpLogin(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RuDeliveryLogin',
        page: () => const RuDeliveryLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RuOpLogin',
        page: () => const RuOpLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GuestLogin',
        page: () => const GuestLogin(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RestroVerify',
        page: () => const RestroVerify(
          name: '',
          email: '',
          phone: '',
          address: '',
          license: '',
          password: '',
        ),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoVerify',
        page: () => const NgoVerify(
          name: '',
          email: '',
          phone: '',
          address: '',
          license: '',
          password: '',
        ),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoRegister',
        page: () => const RegisterNgo(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RestroHome',
        page: () => const RestroHome(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoHome',
        page: () => const NgoHome(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GroceryRegister',
        page: () => const GroceryRegister(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GroceryVerify',
        page: () => const GroceryVerify(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GroceryHome',
        page: () => const GroceryHome(),
        middlewares: [MyMiddelware()],
      ),
       GetPage(
        name: '/RuRegister',
        page: () => const RuRegister(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RuVerify',
        page: () => const RuVerify(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RuHome',
        page: () => const RuHome(),
        middlewares: [MyMiddelware()],
      ),
       GetPage(
        name: '/DistributeForm',
        page: () => const DistributeForm(),
        middlewares: [MyMiddelware()],
      ),
    ];

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (kDebugMode) {
      print(page?.name);
    }
    return super.onPageCalled(page);
  }
}
