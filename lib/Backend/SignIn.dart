// ignore_for_file: file_names, await_only_futures, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trinit/Backend/GetUserDetails.dart';
import 'package:trinit/modal/Users.dart';

class SignsIn {
  FirebaseAuth auth = FirebaseAuth.instance;

  var error;

  Future<int> signin(String mail, String pass) async {
    FirebaseDatabase db = FirebaseDatabase.instance;
    try {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(mail);
      bool ph = RegExp("^([0-9]{10})").hasMatch(mail);
      if (pass.length <= 5) {
        Fluttertoast.showToast(msg: "Wrong Password!!");
        return 0;
      }
      if (emailValid) {
        try {
          await auth.signInWithEmailAndPassword(email: mail, password: pass);
        } on FirebaseAuthException {
          Fluttertoast.showToast(msg: "Wrong Credentials");
          return 0;
        }
      }else if (ph) {
        String path = "Phone_Mail/+91" + mail;
        DataSnapshot s = await db.ref(path).get();
        mail = s.value as String;
        try {
          await auth.signInWithEmailAndPassword(email: mail, password: pass);
        } on FirebaseAuthException {
          Fluttertoast.showToast(msg: "Wrong Credentials");
          return 0;
        }
      }
      else {
        Fluttertoast.showToast(msg: "Invalid Credentials!!");
        return 0;
      }
      if (auth.currentUser != null) {
        String path = "AccountType/"+auth.currentUser!.uid;
        DataSnapshot s = await db.ref(path).get();
        String type = s.value.toString();
        if(type=="NGO"){
          path="Ngo/"+auth.currentUser!.uid+"/verified";
          DataSnapshot s = await db.ref(path).get();
          String verified = s.value.toString();
          if(verified!="true"){
            Fluttertoast.showToast(msg: "Account in Verification Stage!!");
            await auth.signOut();
            return 0;
          }
          

        }
        await GetUserDetails().getUserDetails(type);
        Fluttertoast.showToast(msg: "SignedIn successfully!!");
        return 1;
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }

    return 1;
  }
}
