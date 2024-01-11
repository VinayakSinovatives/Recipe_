import 'package:flutter/material.dart';
import 'package:reciperator/app/myprofile_fields.dart';
import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/app/test_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/ui/home/home_page.dart'; 

//The basic Signup Page
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}


//The following code in comments needs to be called every time we wanna access the database
class _MyProfilePageState extends State<MyProfilePage> {
  //Controllers to handle the text input from the user
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  String _email = 'Insert email';
  String _phone = 'Insert phone';
  String _country = 'Select country';
  String aux = 'Select country';
  String _name = ' ';
  String _image = 'Select image';
  bool checked = false;

  //initialize the controllers
  @override 
  void initState() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  // Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  //Checking with what to fill these textboxes
  Future<void> checkexisted() async {
    //Detecting the user we are refering to
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    //checking if a user is online
    if (user != null) {
      String uid = user.uid;

      try{  
        //Finding the correspondent entity to the online user
        checked = true;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot userSnapshot = await firestore.collection('users').doc(uid).get();
        //Checking if there is one (it always is, just for safety reasons)
        if (userSnapshot.exists){
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          if(userData['email'] != ""){
            _email = userData['email'];
          }
          debugPrint(_email);
          if(userData['phone'] != ""){
            _phone = userData['phone'];
          }
          debugPrint(_phone);
          if(userData['image'] != ""){
            _image = userData['image'];
          }
          debugPrint(_image);
          if(userData['country'] != ""){
            _country = userData['country'];
          }
          _name = userData['login_id'];

                  debugPrint("Email: $_email");
        }
      }
      catch (e) {
        debugPrint('Error getting user document: $e');
        return;
      }
    }
  }

  //In case changes are done, this functions makes them
  Future<void> commitchanges() async {
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        if(emailController.text.isNotEmpty){
          final email = emailController.text;
          FirebaseFirestore.instance.collection('users').doc(uid).update({'email': email});
        }
        if(phoneController.text.isNotEmpty){
          final phone = phoneController.text;
          FirebaseFirestore.instance.collection('users').doc(uid).update({'phone': phone});
        }
        if(aux != "Select country"){
          FirebaseFirestore.instance.collection('users').doc(uid).update({'country': aux});
        }
      }
    }
    catch(e){
      debugPrint("Error while updating");
    }
  }

  @override
  Widget build(BuildContext context) {
    //Percentage stuff, to cover a percentage of the screen 
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return 
      GestureDetector(
      onTap: () {
        hideKeyboard(context); // Hide keyboard when tapping outside of widgets
      },
      child: buildBackground(
          Scaffold(
            resizeToAvoidBottomInset: false,
            //The top bar part of the code
            appBar: AppBar(
              title: const Text(
                'Profile', 
                style: TextStyle(fontSize: 30)
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ), 
            //The main body of the code
            //First, i want everything to be in the center
            drawer: const Menu(),
            body: FutureBuilder(
              future: checked ? null : checkexisted(),
              builder: (context, snapshot) {
                return Center(
                  child: 
                    //Everything will be within this main column, so all components will be children of this
                    Column(
                      children:[
                        SizedBox(height: 0.05*h),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                          },
                          child: Stack(
                            children: [
                              ClipOval(
                                child:
                                  Image.network(
                                    "https://picsum.photos/200/300",
                                    width: w*0.1,
                                    height: h*0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        //-----------Leave some space from the upper part-----------
                        SizedBox(height: 0.05*h),
                        //-----------"Welcome" text-----------
                        Text(
                          _name, 
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          )
                        ),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Email field-----------
                        ProfileCustomTextfield(text: _email, width: w, mycontroller: emailController),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //-----------Phone field-----------
                        ProfileCustomTextfield(text: _phone, width: w, mycontroller: phoneController),
                        //-----------Some space-----------
                        SizedBox(height: 0.02*h),
                        //Select country dropdown box
                        GestureDetector(
                          onTap: () async {
                            showCountryPicker(
                              context: context,
                              // Optional: Exclude specific countries
                              exclude: <String>['KN', 'MF'],
                              favorite: <String>['SE'],
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() {
                                  _country = country.displayName;
                                });
                              },
                              onClosed: (){
                                  aux = _country;
                              },
                              countryListTheme: CountryListThemeData(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                searchTextStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 2 / 3 * w,
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.purple[700]!,
                                width: 1.0,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  aux == 'Select country' ? _country : aux,
                                  style: TextStyle(
                                    color: _country == 'Select country'
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        //-----------Some space-----------
                        SizedBox(height: 0.04*h),
                        //-----------Commit changes-----------
                        Button (type: 'Miltos', label:'Change', onPressed: () async {
                          await commitchanges();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyProfilePage()));
                        }),
                      ],
                    )
                  ); 
              }
            ) 
        )
      )
    );
  }
}



