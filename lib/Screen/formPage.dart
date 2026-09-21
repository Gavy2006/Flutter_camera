import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_screen/Manager/firebasemanger.dart';
import 'package:video_screen/Manager/manager.dart';
import 'package:video_screen/Screen/firstPage.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FormPage extends StatefulWidget {
  final CameraDescription camera;

  const FormPage({super.key , required this.camera});

  @override
  State<FormPage> createState() => _FormPage();
}

class _FormPage extends State<FormPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController policy = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController date = TextEditingController();
  String? damagetype;
  int steps = 1;

  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  void stepinc() {
    if (steps < 3) {
      setState(() {
        steps++;
      });
    }
  }

  void stepdec() {
    if (steps > 1) {
      setState(() {
        steps--;
      });
    }
  }

  void startAutoSync() {

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) async {

          final isConnected =
              result.contains(ConnectivityResult.wifi) ||
                  result.contains(ConnectivityResult.mobile);

          if (isConnected) {
            print("Internet available - syncing data...");

            await firebasemanager().syncToFirestore();
          }
        });
  }
  Future<void> selectDate() async {

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        date.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: const Color(0xFFE8F6EF), leading: Icon(Icons.arrow_back), title: Text("File a Claim"),

      actions: [
        Container(
          margin: const EdgeInsets.only(right: 1),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,) ,
          decoration: BoxDecoration(
            color: Colors.green.shade50 ,
            borderRadius: BorderRadius.circular(16)
          ),

          child: Row(
            children: [
              Icon(Icons.headset_mic, size: 20),
              SizedBox(width: 8),
              Text("Need Help?" , style: const TextStyle(fontSize: 10),),
            ],
          ),
        )
      ],),
      body: SafeArea(
        child: Column(
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
                      children: [
                        Text(
                         steps == 1 ? "Insurance Claim" : steps == 2  ?"Tell Us About" : "Add Supporting",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff20244A),
                          ),
                        ),

                         Text(
                          steps == 1 ?  "Submission" : steps == 2 ? "the Damage" : "Images",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF005B4F),
                          ),
                        ),

                        const SizedBox(height: 7),

                         Text(
                          steps == 1 ?  "Provide the required details to submit\nyour claim" : steps ==2 ? "Help us understand what happened\nso we can assist you better" : "Upload clear photos to support your claim",
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

                    steps == 1 ?'assets/images/img_3.png' : steps == 2 ? 'assets/images/img_5.png' : 'assets/images/img_4.png',
                    width: 100,
                    height: 100,
                  )

                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F6EF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00866A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Safe & Secure",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF152238),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Your information is encrypted and protected.",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF00866A),
                            size: 22,
                          ),
                        ],
                      ),
                    ) ,



                    const SizedBox(height: 12),
                  // if(steps ==1 || steps ==3)
                     Row(
                       children: [
                         Column(
                           children: [
                             CircleAvatar(
                               radius: 17,
                               backgroundColor: steps >= 1
                                   ? const Color(0xff00866A)
                                   : Colors.grey.shade400,
                               child: const Text(
                                 "1",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               ),
                             ),

                             const SizedBox(height: 5),

                             Text(
                               "Personal",
                               style: TextStyle(
                                 fontSize: 13,
                                 color: steps >= 1
                                     ? const Color(0xff00866A)
                                     : Colors.grey,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ],
                         ),

                         Expanded(
                           child: Container(
                             height: 2,
                             color: steps >= 2
                                 ? const Color(0xff00866A)
                                 : Colors.grey.shade300,
                             margin: const EdgeInsets.only(bottom: 22),
                           ),
                         ),

                         Column(
                           children: [
                             CircleAvatar(
                               radius: 17,
                               backgroundColor: steps >= 2
                                   ? const Color(0xff00866A)
                                   : Colors.grey.shade400,
                               child: const Text(
                                 "2",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               ),
                             ),

                             const SizedBox(height: 5),

                             Text(
                               "Damage",
                               style: TextStyle(
                                 fontSize: 13,
                                 color: steps >= 2
                                     ? const Color(0xff00866A)
                                     : Colors.grey,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ],
                         ),

                         Expanded(
                           child: Container(
                             height: 2,
                             color: steps >= 3
                                 ? const Color(0xff00866A)
                                 : Colors.grey.shade300,
                             margin: const EdgeInsets.only(bottom: 22),
                           ),
                         ),

                         Column(
                           children: [
                             CircleAvatar(
                               radius: 17,
                               backgroundColor: steps >= 3
                                   ? const Color(0xff00866A)
                                   : Colors.grey.shade400,
                               child: const Text(
                                 "3",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               ),
                             ),

                             const SizedBox(height: 5),

                             Text(
                               "Images",
                               style: TextStyle(
                                 fontSize: 13,
                                 color: steps >= 3
                                     ? const Color(0xff00866A)
                                     : Colors.grey,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ],
                         ),
                       ],
                     ) ,
                     const SizedBox(height: 20),


                    Column(
                      children: [
                        if (steps == 1)
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side:  const BorderSide(
                                color: Color(0xFF00866A),
                                width: 1.5,
                              ),
                            ),

                            child: SizedBox(
                              width: 350,
                              height: 260,
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F6EF),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD1F0E2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.person_outline,
                                              color: Color(0xFF00866A),
                                              size: 25,
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Personal Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                ),
                                              ),

                                              SizedBox(height: 1),

                                              Text(
                                                "Enter your basic policy information",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ) ,

                                    const SizedBox(height: 14),

                                    const Text(
                                      "Full Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 42,
                                      child: TextField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: name,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Enter your full name",
                                          hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.person_outline,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 0,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xff6848C7),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Text(
                                      "Policy Number",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 42,
                                      child: TextField(
                                        controller: policy,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Enter policy number",
                                          hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.description_outlined,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 0,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xff6848C7),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        if (steps == 2)
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                color: Color(0xFF00866A),
                                width: 1.5,
                              ),
                            ),
                            child: SizedBox(
                              width: 350,
                              height: 260,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color(0xFFE8F6EF),
                                          child: const Icon(
                                            Icons.construction,
                                            color: Color(0xFF00866A),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Damage Details",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              "Provide the required details",
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    const Text(
                                      "Types of damage",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 42,
                                      child: DropdownButtonFormField<String>(
                                        value: damagetype,
                                        decoration: InputDecoration(
                                          hintText: "Select Damage Type",
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFE8F6EF),
                                              width: 1.2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFE8F6EF),
                                              width: 1.2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFE8F6EF),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Minor Damage",
                                            child: Text("Minor Damage"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Major Damage",
                                            child: Text("Major Damage"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Total Loss",
                                            child: Text("Total Loss"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            damagetype = value;
                                          });
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 12),
                                    const Text(
                                      "Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 80,
                                      child: TextField(
                                        controller: description,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.description),
                                          hintText: "Enter damage description",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Text(
                                      "Date of Incident",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 42,
                                      child: TextField(
                                        controller: date,
                                        readOnly: true,
                                        onTap: selectDate,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.calendar_month),
                                          hintText: "Select Date",
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Text(
                                      "Location",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      height: 42,
                                      child: TextField(
                                        controller: location,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.location_city),
                                          hintText: "Enter incident location",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) ,
                        if (steps == 3)
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side:  const BorderSide(
                                  color: Color(0xFF00866A),
                                  width: 1.5,
                                )
                            ),
                            child: SizedBox(
                              width: 350,
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row  (

                                        children:[

                                          CircleAvatar(
                                            backgroundColor: const Color(0xFFE8F6EF),

                                            child: Icon(Icons.photo , color: Color(0xFF00866A),),
                                          ) ,

                                          const   SizedBox(width: 8,) ,
                                          Column  (

                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [const Text(
                                                "Upload Images",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),

                                                Text(
                                                  "Add photos of the damaged , vehicle or\nrelevant documents" ,
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    height: 1.4,
                                                    color: Color(0xff85869A),
                                                  ),
                                                )
                                              ]) ,])
                                    ,
                                    const SizedBox(height: 5),


                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Color(0xFF00866A),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: () {
                                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: widget.camera))) ;
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.cloud_upload_outlined,
                                                color: Color(0xFF00866A),
                                                size: 38,
                                              ),

                                              const SizedBox(height: 8),

                                              const Text(
                                                "Tap to Upload Images",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage('assets/images/img_6.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage('assets/images/img_7.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage('assets/images/img_8.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Color(0xFF00897B),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Color(0xFF00897B),
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: 350,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (steps == 1) {
                                  await manager().details(
                                    name.text.trim(),
                                    policy.text.trim(),
                                  );

                                  if (!mounted) return;

                                  setState(() {
                                    steps = 2;
                                  });
                                } else if (steps == 2) {
                                  await manager().describe(
                                    damagetype!,
                                    description.text.trim(),
                                      date.text,
                                    location.text
                                  );

                                  if (!mounted) return;

                                  setState(() {
                                    steps = 3;
                                  });
                                }
                              } catch (e) {
                                print("ERROR: $e");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color(0xff00866A),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(steps == 3 ? "Submit" : "Continue"),
                          ),
                        ),


                        const SizedBox(height: 10),

                        SizedBox(
                          width: 350,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (steps > 1) {
                                setState(() {
                                  steps--;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Colors.white,
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                              color :  const Color(0xff00866A),
                                width: 1.5,
                              ),
                            ),
                            child: Text("Cancel" , style: const TextStyle(color:   const Color(0xff00866A)),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
