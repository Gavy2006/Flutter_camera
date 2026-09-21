

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_screen/Manager/manager.dart';

class firebasemanager{

  final firebase = FirebaseFirestore.instance ;

  Future<void> addData(
      String id ,
      Map<String , dynamic> data ,
      ) async{

    await firebase.collection('data')
        .doc(id)
        .set(data , SetOptions(merge: true)) ;

}



  Future<void> syncToFirestore() async {

    final policy = await manager().returndetails();
    final damage = await manager().returndescribe();

    print("POLICY: $policy");
    print("DAMAGE: $damage");

    if (policy.isEmpty || damage.isEmpty) {
      print("SQLite data empty");
      return;
    }

    await FirebaseFirestore.instance
        .collection('claims')
        .add({
      'name': policy.first['name'],
      'policyNo': policy.first['policyno'],
      'damageType': damage.first['damageType'],
      'description': damage.first['describe'],
      'date': damage.first['date'],
      'location': damage.first['Location'],
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("Firestore write successful");
  }

}