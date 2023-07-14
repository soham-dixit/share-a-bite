import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/grocery_store/GroceryHome.dart';
import 'package:share_a_bite/grocery_store/GroceryRegister.dart';
import 'package:share_a_bite/grocery_store/GroceryVerify.dart';
import 'package:share_a_bite/grocery_store/menu.dart';
import 'package:share_a_bite/login/GroceryLogin.dart';
import 'package:share_a_bite/login/GuestLogin.dart';
import 'package:share_a_bite/login/MainLogin.dart';
import 'package:share_a_bite/login/NgoOpLogin.dart';
import 'package:share_a_bite/login/NgoVolLogin.dart';
import 'package:share_a_bite/login/RestroLogin.dart';
import 'package:share_a_bite/login/RuDeliveryLogin.dart';
import 'package:share_a_bite/login/RuOpLogin.dart';
import 'package:share_a_bite/ngo_operator/AddVolunteer.dart';
import 'package:share_a_bite/ngo_operator/ListVolunteers.dart';
import 'package:share_a_bite/ngo_operator/NgoHome.dart';
import 'package:share_a_bite/ngo_operator/NgoRegister.dart';
import 'package:share_a_bite/ngo_operator/NgoVerify.dart';
import 'package:share_a_bite/ngo_operator/PendingReq.dart';
import 'package:share_a_bite/ngo_operator/menu.dart';
import 'package:share_a_bite/ngo_volunteer/AcceptedReq.dart';
import 'package:share_a_bite/ngo_volunteer/PendingReq.dart';
import 'package:share_a_bite/ngo_volunteer/PendingReqDetails.dart';
import 'package:share_a_bite/ngo_volunteer/VolHome.dart';
import 'package:share_a_bite/ngo_volunteer/VolRegister.dart';
import 'package:share_a_bite/ngo_volunteer/VolVerify.dart';
import 'package:share_a_bite/ngo_volunteer/menu.dart';
import 'package:share_a_bite/ngo_volunteer/navigate.dart';
import 'package:share_a_bite/onboarding/SplashScreen.dart';
import 'package:share_a_bite/onboarding/carousel.dart';
import 'package:share_a_bite/recycling_unit/RuHome.dart';
import 'package:share_a_bite/recycling_unit/RuRegister.dart';
import 'package:share_a_bite/recycling_unit/RuVerify.dart';
import 'package:share_a_bite/restro/DistributeForm.dart';
import 'package:share_a_bite/restro/PendingReq.dart';
import 'package:share_a_bite/restro/PendingReqDetails.dart';
import 'package:share_a_bite/restro/RestroHome.dart';
import 'package:share_a_bite/restro/RestroVerify.dart';
import 'package:share_a_bite/restro/menu.dart';

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
        page: () => const GroceryVerify(
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
        page: () => const RuVerify(
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
        name: '/RuHome',
        page: () => const RuHome(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/DistributeForm',
        page: () => const DistributeForm(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RestroMenu',
        page: () => const RestroMenu(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/GroceryMenu',
        page: () => const GroceryMenu(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoOpMenu',
        page: () => const NgoOpMenu(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NgoPendingReq',
        page: () => const PendingReq(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/RestroPendingReq',
        page: () => const RestroPendingReq(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/ListVolunteers',
        page: () => const ListVolunteers(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/AddVolunteer',
        page: () => const AddVolunteer(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolRegister',
        page: () => const VolRegister(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolVerify',
        page: () => const VolVerify(
          name: '',
          email: '',
          password: '',
          phone: '',
        ),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolHome',
        page: () => const VolHome(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolPendingReq',
        page: () => const VolPendingReq(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/PendingReqDetailsVol',
        page: () => const PendingReqDetailsVol(
          id: '',
        ),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolAcceptedReq',
        page: () => const AcceptedReqVol(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/VolMenu',
        page: () => const VolMenu(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/NavVol',
        page: () => NavVol(
          lat: '',
          long: '',
        ),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/PendingReqDetailsRestro',
        page: () => const PendingReqDetailsRestro(id: '',),
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
