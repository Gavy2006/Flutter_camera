import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/listScreen.dart';

class Searchscreen  extends StatefulWidget{
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _Searchscreen() ;
}

class _Searchscreen extends State<Searchscreen>{

  TextEditingController searchController = TextEditingController();

  List<listScreen> claims = [
    listScreen("POL-001", "Rahul Sharma", "Vehicle Damage", "In Review"),
    listScreen("POL-002", "Aman Verma", "Accident", "Approved"),
    listScreen("POL-003", "Priya Singh", "Car Damage", "Pending"),
    listScreen("POL-004", "Rohit Kumar", "Vehicle Damage", "Rejected"),
    listScreen("POL-005", "Neha Sharma", "Glass Damage", "In Review"),
    listScreen("POL-006", "Arjun Mehta", "Accident", "Approved"),
    listScreen("POL-007", "Simran Kaur", "Vehicle Damage", "Pending"),
    listScreen("POL-008", "Vikas Gupta", "Car Damage", "In Review"),
    listScreen("POL-009", "Ankit Singh", "Accident", "Approved"),
    listScreen("POL-010", "Karan Patel", "Vehicle Damage", "Pending"),

    listScreen("POL-011", "Mohit Sharma", "Car Damage", "In Review"),
    listScreen("POL-012", "Pooja Verma", "Glass Damage", "Approved"),
    listScreen("POL-013", "Nitin Kumar", "Accident", "Pending"),
    listScreen("POL-014", "Kavya Singh", "Vehicle Damage", "Rejected"),
    listScreen("POL-015", "Deepak Mehta", "Car Damage", "In Review"),
  ] ;



  late List<listScreen> filteredClaims;

  @override
  void initState() {
    super.initState();
    filteredClaims = claims;
  }

  @override
  Widget build(BuildContext context){



    return Scaffold(

        backgroundColor: Colors.white,

        appBar: AppBar(backgroundColor: const Color(0xFFE8F6EF), leading: Icon(Icons.arrow_back), title: Text("File a Claim"),) ,

            body: Padding(padding: EdgeInsets.all(8 ) ,
                child:  Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Claims" , style: const TextStyle(  color: Color(0xFF00866A) , fontWeight: FontWeight.bold , fontSize: 20),) ,
                    const SizedBox(height: 1,) ,

                    Text("View an manage all your claims" , style: const TextStyle(color: Colors.grey , fontWeight: FontWeight.bold , fontSize: 12),) ,

                    const SizedBox(height: 15,) ,

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            if (value.length < 4) {
                              filteredClaims = claims;
                            } else {
                              filteredClaims = claims.where((claim) {
                                return claim.policyno.toLowerCase().contains(value.toLowerCase()) ||
                                    claim.name.toLowerCase().contains(value.toLowerCase()) ||
                                    claim.damage.toLowerCase().contains(value.toLowerCase()) ||
                                    claim.status.toLowerCase().contains(value.toLowerCase());
                              }).toList();
                            }
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,

                          hintText: "Search by ID, name, damage type or status...",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 11,
                          ),

                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF607D8B),
                            size: 20,
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF90A4AE),
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Text("Type at least 4 characters to search" , style: const TextStyle(color: Colors.grey , fontWeight: FontWeight.bold , fontSize: 10),) ,


                    const SizedBox(height: 15,) ,

                    Expanded(child:

                    ListView.builder(itemCount : filteredClaims.length ,itemBuilder: (context, index) {
                      return Card(
                        color:  Colors.white,
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: SizedBox(
                          height: 95,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [

                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: filteredClaims[index].damage == "Vehicle Damage"
                                        ? const Color(0xFFE8F5F1)
                                        : filteredClaims[index].damage == "Glass Damage"
                                        ? const Color(0xFFE3F2FD)
                                        : const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    filteredClaims[index].damage == "Vehicle Damage"
                                        ? Icons.directions_car
                                        : filteredClaims[index].damage == "Glass Damage"
                                        ? Icons.window
                                        : Icons.car_crash,
                                    size: 28,
                                    color: filteredClaims[index].damage == "Vehicle Damage"
                                        ? const Color(0xFF00796B)
                                        : filteredClaims[index].damage == "Glass Damage"
                                        ? const Color(0xFF1565C0)
                                        : const Color(0xFFEF6C00),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredClaims[index].policyno,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF17213C),
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        filteredClaims[index].name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        children:  [
                                          Icon(
                                            Icons.directions_car,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            filteredClaims[index].damage ,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: filteredClaims[index].status == "Approved"
                                            ? const Color(0xFFE8F5E9)
                                            : filteredClaims[index].status == "Pending"
                                            ? const Color(0xFFFFF8E1)
                                            : filteredClaims[index].status == "In Review"
                                            ? const Color(0xFFE3F2FD)
                                            : const Color(0xFFFFEBEE),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            filteredClaims[index].status == "Approved"
                                                ? Icons.check_circle
                                                : filteredClaims[index].status == "Pending"
                                                ? Icons.schedule
                                                : filteredClaims[index].status == "In Review"
                                                ? Icons.hourglass_top
                                                : Icons.cancel,
                                            size: 13,
                                            color: filteredClaims[index].status == "Approved"
                                                ? const Color(0xFF2E7D32)
                                                : filteredClaims[index].status == "Pending"
                                                ? const Color(0xFFF57F17)
                                                : filteredClaims[index].status == "In Review"
                                                ? const Color(0xFF1565C0)
                                                : const Color(0xFFC62828),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            filteredClaims[index].status,
                                            style: TextStyle(
                                              color: filteredClaims[index].status == "Approved"
                                                  ? const Color(0xFF2E7D32)
                                                  : filteredClaims[index].status == "Pending"
                                                  ? const Color(0xFFF57F17)
                                                  : filteredClaims[index].status == "In Review"
                                                  ? const Color(0xFF1565C0)
                                                  : const Color(0xFFC62828),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Color(0xFF78909C),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ) ;
                    },)
                    ) ,
                  ],
                ),)

        );
  }
}