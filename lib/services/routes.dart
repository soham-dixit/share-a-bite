import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/onboarding/SplashScreen.dart';
import 'package:share_a_bite/onboarding/carousel.dart';

appRoutes() => [
      GetPage(
        name: '/carousel',
        page: () => const IntroCarousel(),
        transition: Transition.zoom,
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: '/SplashScreen',
        page: () => const SplashScreen(),
        transition: Transition.zoom,
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
