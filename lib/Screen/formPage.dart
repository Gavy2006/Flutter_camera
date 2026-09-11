import 'package:flutter/material.dart';
import 'package:video_screen/Manager/manager.dart';
import 'package:video_screen/Screen/firstPage.dart';
import 'package:camera/camera.dart';
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

  String? damagetype;
  int steps = 1;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            color: Color(0xff20244A),
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

                    steps == 1 ?'assets/images/img.png' : steps == 2 ? 'assets/images/img_1.png' : 'assets/images/img_2.png',
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
                    const Text(
                      "Submit Your Claim",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff242542),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Complete all steps to submit your insurance claim",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),


                    const SizedBox(height: 10),
                   if(steps ==1 || steps ==3)
                     Row(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: steps >= 1
                                  ? const Color(0xff6848C7)
                                  : Colors.grey,
                              child: const Text(
                                "1",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Personal",
                              style: TextStyle(
                                color: steps >= 1
                                    ? Color(0xff6848C7)
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Container(
                            height: 2,
                            color: steps >= 2 ? Color(0xff6848C7) : Colors.grey,
                            margin: const EdgeInsets.only(bottom: 25),
                          ),
                        ),

                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: steps >= 2
                                  ? const Color(0xff6848C7)
                                  : Colors.grey,
                              child: const Text(
                                "2",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Damage",
                              style: TextStyle(
                                color: steps >= 2
                                    ? const Color(0xff6848C7)
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Container(
                            height: 2,
                            color: steps >= 3 ? const Color(0xff6848C7) : Colors
                                .grey,
                            margin: const EdgeInsets.only(bottom: 25),
                          ),
                        ),

                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: steps >= 3
                                  ? const Color(0xff6848C7)
                                  : Colors.grey,
                              child: const Text(
                                "3",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Image",
                              style: TextStyle(
                                color: steps >= 3
                                    ? const Color(0xff6848C7)
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                     const SizedBox(height: 28),


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
                                color: Color(0xff6848C7),
                                width: 1.5,
                              ),
                            ),

                            child: SizedBox(
                              width: 350,
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Personal Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      "Enter your basic policy information",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

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
                                color: Color(0xff6848C7),
                                width: 1.5,
                              ),
                            ),
                            child: SizedBox(
                              width: 350,
                              height: 350,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color(0xffF0EDFA),
                                          child: const Icon(
                                            Icons.construction,
                                            color: Color(0xff6848C7),
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
                                              color: Color(0xff6848C7),
                                              width: 1.2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xff6848C7),
                                              width: 1.2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xff6848C7),
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
                                        controller: name,
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
                                        controller: policy,
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
                                  color: Color(0xff6848C7),
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
                                            child: Icon(Icons.photo , color: Color(0xff6848C7),),
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
                                    const SizedBox(height: 18),


                                    SizedBox(
                                      width: double.infinity,
                                      height: 120,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Color(0xff6848C7),
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
                                                color: Color(0xff6848C7),
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
                                  ],
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

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
                                    description.text.trim(),
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
                              backgroundColor: const Color(0xff6848C7),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(steps == 3 ? "Submit" : "Continue"),
                          ),
                        ),


                        const SizedBox(height: 20),

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
                                color: Color(0xff6848C7),
                                width: 1.5,
                              ),
                            ),
                            child: Text("Cancel" , style: const TextStyle(color:  Color(0xff6848C7)),),
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
