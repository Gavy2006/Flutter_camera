import 'package:flutter/material.dart';

class photo extends StatefulWidget {
  const photo({super.key});

  @override
  State<photo> createState() => _photo();
}

class _photo extends State<photo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 20, 18, 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Insurance Claim",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff20244A),
                          ),
                        ),

                        Text(
                          "Submission",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff20244A),
                          ),
                        ),

                        SizedBox(height: 7),

                        Text(
                          "Provide the required details to submit\nyour claim",
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: Color(0xff85869A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Image.asset(
                    'assets/images/img.png',
                    width: 100,
                    height: 100,
                  )

                ],
              ),
            ),


          ]
      ),
    );
  }
}