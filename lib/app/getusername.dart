import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getCurrentUserUsername() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users') .doc(user.uid) .get();
      if (userDoc.exists) {
       
        String? username = userDoc['username'];
        return username;
      } 
      else {
        
        print("User document not found in Firestore");
        return null;
      }
    } else {
      // No user is logged in
      print("No user logged in");
      return null;
    }
  } catch (e) {
    // Handle any errors
    print(e.toString());
    return null;
  }
}