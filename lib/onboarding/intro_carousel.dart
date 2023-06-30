import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroCarousel extends StatefulWidget {
  const IntroCarousel({Key? key}) : super(key: key);

  @override
  State<IntroCarousel> createState() => _IntroCarouselState();
}

class _IntroCarouselState extends State<IntroCarousel> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    for (var i = 1; i < 6; i++) {
      slides.add(Slide(
          backgroundImage: 'assets/carousel/${i}.png',
          backgroundImageFit: BoxFit.contain,
          backgroundColor: Colors.white,
          backgroundOpacity: 0));
    }

    // slides.add(Slide(
    //   backgroundImage: 'assets/carousel/1.png',
    //   backgroundImageFit: BoxFit.contain,
    //   backgroundColor: Colors.white,
    //   backgroundOpacity: 0
    // ));
  }

  void onDonePress() {
    // Do what you want
    Navigator.pop(context);
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xffff3333)),
      foregroundColor: MaterialStateProperty.all<Color>(
          const Color(0xffffffff)), // Change text color here
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      // overlayColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroSlider(
        slides: slides,
        onDonePress: onDonePress,
        skipButtonStyle: myButtonStyle(),
        prevButtonStyle: myButtonStyle(),
        nextButtonStyle: myButtonStyle(),
        doneButtonStyle: myButtonStyle(),
      ),
    );
  }
}
