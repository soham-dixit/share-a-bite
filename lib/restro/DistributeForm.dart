import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class DistributeForm extends StatefulWidget {
  const DistributeForm({super.key});

  @override
  State<DistributeForm> createState() => _DistributeFormState();
}

class _DistributeFormState extends State<DistributeForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 40,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/mis/back.svg',
                        height: 48,
                        width: 48,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: const [
                    Text(
                      'Distribute Excess Food',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Color(0xFF4F200D),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 30),
                child: MainButton(
                  initialTitle: 'Next',
                  onPressed: () {},
                ))
          ],
        ),
      ),
    );
  }
}
