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

class ReqCard extends StatefulWidget {
  final VoidCallback onPress;

  final String restroName;
  final String foodName;
  final String foodType;
  final String shelfLife;
  // final String jobCreatedTime;
  final String status;
  const ReqCard(
      {Key? key,
      required this.restroName,
      required this.foodName,
      required this.foodType,
      required this.shelfLife,
      required this.status,
      required this.onPress})
      : super(key: key);

  @override
  State<ReqCard> createState() => _ReqCardState();
}

//display vehicle number, customer name, assigned employee, job created date and time on left side one below the other and status on top right. if status is ongoing, display text in blue, if status is ready, display text in green, if status is created, display text in yellow, if status is payment due, display text in red
class _ReqCardState extends State<ReqCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: widget.onPress,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 1, // Add shadow
          child: Container(
            width: 358.0, // Set width
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle number
                    Text(
                      widget.restroName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Customer name
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.foodName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    // Assigned employee
                    Row(children: [
                      const Icon(
                        Icons.person_2_outlined,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.foodType,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(20, 20, 20, 0.6),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 2,
                    ),

                    // Job created date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 4,
                        ),

                        // Job created time
                        Text(
                          widget.shelfLife,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(20, 20, 20, 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(
                          8, 12, 8, 12), // Adjust padding as needed
                      decoration: BoxDecoration(
                        color: widget.status == 'pending'
                            ? const Color.fromRGBO(219, 0, 0, 0.078)
                            : widget.status == 'accepted'
                                ? const Color.fromRGBO(89, 195, 106, 0.08)
                                : widget.status == 'completed'
                                    ? const Color.fromRGBO(244, 73, 15, 0.08)
                                    : const Color.fromRGBO(255, 204, 0, 0.08),

                        borderRadius:
                            BorderRadius.circular(8), // Radius of the box
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          // fontWeight: FontWeight.bold,
                          color: widget.status == 'pending'
                              ? const Color.fromRGBO(255, 0, 0, 1)
                              : widget.status == 'accepted'
                                  ? Color.fromARGB(255, 16, 157, 40)
                                  : widget.status == 'completed'
                                      ? const Color.fromRGBO(244, 73, 15, 0.08)
                                      : const Color.fromRGBO(244, 73, 15, 0.08),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VolunteerCard extends StatefulWidget {
  final VoidCallback onPress;

  final String name;
  final String email;
  final String phone;
  const VolunteerCard(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.onPress})
      : super(key: key);

  @override
  State<VolunteerCard> createState() => _VolunteerCardState();
}

//display vehicle number, customer name, assigned employee, job created date and time on left side one below the other and status on top right. if status is ongoing, display text in blue, if status is ready, display text in green, if status is created, display text in yellow, if status is payment due, display text in red
class _VolunteerCardState extends State<VolunteerCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: widget.onPress,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 1, // Add shadow
          child: Container(
            width: 358.0, // Set width
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle number
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Customer name
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 12,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            widget.email,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    // Assigned employee
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          widget.phone,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
