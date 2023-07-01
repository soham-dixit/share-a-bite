import 'package:flutter/material.dart';

class Constants {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class MainButton extends StatefulWidget {
  final String initialTitle;
  final Function? onPressed;
  const MainButton(
      {Key? key, required this.initialTitle, required this.onPressed})
      : super(key: key);

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Constants.getScreenHeight(context) * 0.07,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffff3333),
        ),
        onPressed: () {
          widget.onPressed!();
        },
        child: Text(
          widget.initialTitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MainOrangeBorderButton extends StatefulWidget {
  final String initialTitle;
  final Function? onPressed;
  const MainOrangeBorderButton(
      {Key? key, required this.initialTitle, required this.onPressed})
      : super(key: key);

  @override
  State<MainOrangeBorderButton> createState() => _MainOrangeBorderButtonState();
}

class _MainOrangeBorderButtonState extends State<MainOrangeBorderButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Constants.getScreenHeight(context) * 0.07,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xffff3333), width: 2),
            borderRadius: BorderRadius.circular(12.0),
          ),
          foregroundColor: const Color(0xffff3333),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          widget.onPressed!();
        },
        child: Text(
          widget.initialTitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xffff3333),
          ),
        ),
      ),
    );
  }
}
