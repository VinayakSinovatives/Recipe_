import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/app/menu_buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  
  Future<String?> findingname() async {
    //which user is online
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists){
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      return userData['login_id'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack( 
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin:Alignment.topCenter,
                end:Alignment.bottomCenter,
                colors: AppColors.menuBackground,
              )
            )
          ),
          ListView(
            padding: EdgeInsets.zero,
            children:  [
               DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
                child: FutureBuilder<String?>(
                  future: findingname(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } 
                    else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } 
                    else {
                      String? who = snapshot.data!;

                      return Center(
                        child: Text(
                          "Hi, $who!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          )
                        ),
                      );
                    }
                  }
                ),
              ),
              MenuButton(type: 'Home', text: 'Home Page', onTap: () {Navigator.pushNamed(context, homeRoute);}), 
              MenuButton(type: 'Profile', text: 'My Profile', onTap: () {Navigator.pushNamed(context, profileRoute);}),
              MenuButton(type: 'Reviews', text:'My Reviews', onTap: () {Navigator.pushNamed(context, reviewRoute);}), 
              MenuButton(type: 'LogOut', text: 'LogOut', onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, landing, (r) => false);
              })
            ],
          )        
        ]
      )
    );
  }
}



