import 'package:firebase_database/firebase_database.dart';

import '../modal/ngo.dart';

getNgoList() async {
  var ngoList = [];
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('Ngo').get();
  if (snapshot.exists) {
    for (var i in snapshot.children) {
      NGO ngo = NGO(
        name: i.child("name").value.toString(),
        acc_name: i.child("accountProof").child('accountName').value.toString(),
        ifsc: int.parse(i.child("accountProof").child('ifsc').value.toString()),
        acc_num: int.parse(
            i.child("accountProof").child('accountNo').value.toString()),
        community: [],
        impact: [],
        mission: i.child('mission').value.toString(),
        photo_link: i.child('mission').value.toString(),
        prev_work: i.child('mission').value.toString(),
      );
      ngoList.add(ngo);
    }
    return ngoList;
  } else {
    return [];
  }
}
