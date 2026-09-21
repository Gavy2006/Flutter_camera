import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_screen/Manager/manager.dart';
import 'package:video_player/video_player.dart';
import 'package:signature/signature.dart';
import 'VideoScreen.dart';
import 'package:video_screen/Manager/firebasemanger.dart';

class Newpreviewscreen extends StatefulWidget{
  const Newpreviewscreen({super.key}) ;


  @override
  State<Newpreviewscreen> createState() => _Newpreviewscreen() ;
}

class _Newpreviewscreen extends State<Newpreviewscreen>{


  List<Map<String, dynamic>> policyDetails = [];
  List<Map<String, dynamic>> listno = [];
  List<Map<String, dynamic>> describe = [];

  String? file;
   List<String> list = [];
  late VideoPlayerController videoController;

   final SignatureController controller = SignatureController(
     penStrokeWidth: 3,
     penColor: Colors.black,
   );

   Uint8List? signatureData;

   Future<void> saveSignature() async {
     final data = await controller.toPngBytes();

     if (data != null) {
       setState(() {
         signatureData = data;
       });
     }
   }

   void openSignaturePad() {
     controller.clear();

     showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: const Text(
             "Add Signature",
             style: TextStyle(
               fontWeight: FontWeight.bold,
             ),
           ),

           content: Container(
             width: 350,
             height: 200,
             decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(
                 color: const Color(0xFF00866A),
               ),
               borderRadius: BorderRadius.circular(10),
             ),
             child: Signature(
               controller: controller,
               backgroundColor: Colors.white,
             ),
           ),

           actions: [

             TextButton(
               onPressed: () {
                 controller.clear();
               },
               child: const Text("Clear"),
             ),

             ElevatedButton(
               onPressed: () async {
                 await saveSignature();

                 Navigator.pop(context);
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF00866A),
                 foregroundColor: Colors.white,
               ),
               child: const Text("Done"),
             ),

           ],
         );
       },
     );
   }

  Future<void> listdetails() async {

    final listno1 = await manager().returndetails();
    final describe1 = await manager().returndescribe();

    setState(() {
      listno = listno1;
      describe = describe1;
    });
  }


  Future<void> loadData() async {

    final details = await manager().returndetails();
    final describeData = await manager().returndescribe();

    final images = await manager().returnimages();
    final video = await manager().returnvideo();

    setState(() {
      listno = details;
      describe = describeData;

      list = images;
      file = video;
    });

    videoController = VideoPlayerController.file(
      File(file!),
    );

    await videoController.initialize();

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }

   @override
   void dispose() {
     controller.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(      backgroundColor: Colors.white,

        centerTitle: true,
        title: const Text("Review Your Claim" , style: const TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(

        child: Padding(padding: EdgeInsets.all(16) ,
        child: Column(
          children: [

            Center(
              child: Text("Review check your details before submiting" ,  style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),),
            ) ,

            const SizedBox(height: 10,) ,
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
                height: 300,
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
                                "Policy Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Your Submitted details",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                      const SizedBox(height: 10,) ,

                      Column(
                        children: [

                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Full Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),


                               Expanded(
                                child: Text(
                                    "${listno.isNotEmpty ? listno.first['name'] ?? '' : ''}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.book,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Policy Number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),

                               Expanded(
                                child: Text(
                                    "${listno.isNotEmpty ? listno.first['policyno'] ?? '' : ''}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.description,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Damage Type",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),

                               Expanded(
                                child: Text(
                                    "Damage Type: ${describe.isNotEmpty ? describe.first['damageType'] ?? '' : ''}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.description,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),

                               Expanded(
                                child: Text(
                                "${describe.isNotEmpty ? describe.first['describe'] ?? '' : ''}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Incident Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),

                               Expanded(
                                child: Text(
    "${describe.isNotEmpty ? describe.first['date'] ?? '' : ''}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),


                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Color(0xFF00866A),
                              ),
                              const SizedBox(width: 12),

                              const SizedBox(
                                width: 110,
                                child: Text(
                                  "Location",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Text(":"),
                              const SizedBox(width: 10),

                               Expanded(
                                child: Text(  "${describe.isNotEmpty ? describe.first['Location'] ?? '' : ''}"
                                  ,style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ) ,


            const SizedBox(height: 10,) ,

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
              child:  Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xffF0EDFA),
                          child: const Icon(
                            Icons.photo,
                            color: Color(0xFF00866A),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Captured Images",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            Text(
                              "${list.length} Images attached",
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Image.file(
                                      File(list[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 65,
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(list[index]),
                                  width: 65,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ) ,


            const SizedBox(height: 10,) ,
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
                height: 170,
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
                                "Video Shared",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "1 Video attached",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                      const SizedBox(height: 10,) ,

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         GestureDetector(

                             child:  Container(
                           width: 70,
                           height: 70,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: const Color(0xFF00866A),
                               width: 1.5,
                             ),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: const Center(
                             child: Icon(
                               Icons.video_file,
                               color: Color(0xFF00866A),
                               size: 30,
                             ),
                           ),
                         ),
                         onTap: (){
                               showDialog(context: context, builder: (context){
                                return Dialog(
                                  child: VideoPreview(videoPath: file!),
                                 ) ;
                               }) ;
                         },) ,

                          const SizedBox(width: 52),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Recorded On",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "12 Sep 2025\n10:45 AM",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Location",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Kurukshetra,\nHaryana",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "File Size",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "12.5 MB",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ) ,

            const SizedBox(height: 20),

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
                height: 150,
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
                                "Digital Signature",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Sign below to confirm your claim",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),



                      Center(
                        child: signatureData == null
                            ? TextButton(
                          onPressed: openSignaturePad,
                          child: const Text(
                            "Add Signature",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00866A),
                            ),
                          ),
                        )
                            : Container(
                          width: 180,
                          height: 70,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.memory(
                            signatureData!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ) ,

            const SizedBox(height: 10,) ,

            SizedBox(
              width: 350,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {

                  try {

                    await firebasemanager().syncToFirestore();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Claim submitted successfully"),
                      ),
                    );

                  } catch (e) {

                    print("Firestore Error: $e");

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Submission failed: $e"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00866A),
                  foregroundColor: Colors.white,
                ),
                child: Text( "Continue"),
              ),
            ),


            const SizedBox(height: 20),

            SizedBox(
              width: 350,
              height: 48,
              child: ElevatedButton(
                onPressed: () {


                } ,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.white,
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF00866A),
                    width: 1.5,
                  ),
                ),
                child: Text("Cancel" , style: const TextStyle(color:  Color(0xFF00866A)),),
              ),
            ),
          ],
        ),)
      ),
    ) ;
  }
}