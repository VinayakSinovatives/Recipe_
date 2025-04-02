import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddIngredients extends StatefulWidget {
  const AddIngredients({super.key});

  @override
  State<AddIngredients> createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  List<TextEditingController> textControllers = [];
  List<QueryDocumentSnapshot>? recipes = [];
  FocusNode? textFieldFocusNode;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  Timer? _listeningTimer;

  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _initializeOverlay();
    checkMicrophoneAvailability();
  }

  void _initializeOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(children: [
        Container(
          color: Colors.black.withOpacity(0.9),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _buildMicWaveBars(),
        )
      ]),
    );
  }

  Widget _buildMicWaveBars() {
    return const Center(
      child: SpinKitWave(
        color: Colors.blue,
        size: 75.0,
      ),
    );
  }

  void _showOverlay() {
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    _overlayEntry.remove();
  }

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void checkMicrophoneAvailability() async {
    bool isMicAvailable = await initSpeech();
    if (!isMicAvailable) {
      showMicNotAvailableMessage();
    }
  }

  void showMicNotAvailableMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Mic is not available"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startListening() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("Microphone permission not granted");
      return;
    }

    debugPrint("**********Start Listening**********");

    bool available = await _speech.initialize(onError: (val) {
      setState(() => _isListening = false);
    }, onStatus: (val) {
      if (val == "notListening") {
        setState(() => _isListening = false);
        _hideOverlay();
      }
    });

    if (available) {
      setState(() => _isListening = true);
      _showOverlay();
      _speech.listen(onResult: (result) {
        if (result.finalResult) {
          setState(() {
            textControllers
                .add(TextEditingController(text: result.recognizedWords));
            _isListening = false;
            _hideOverlay();
          });
        }
      });
    }
  }

  void stopListening() {
    _speech.stop();
    _listeningTimer?.cancel();
    setState(() => _isListening = false);
    _hideOverlay();
  }

  List<CustomTextField>? globaller = [];
  CustomTextField adding(int index) {
    CustomTextField aux = CustomTextField(
      controller: textControllers[index],
      focusNode:
          index == textControllers.length - 1 ? textFieldFocusNode : null,
      deleted: false,
    );
    globaller!.add(aux);
    return aux;
  }

  //here happens the search-web scraping
  Future<List<QueryDocumentSnapshot>?> webscraping(
      List<String> ingredients) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('food').get();
    Map<QueryDocumentSnapshot, int> choosingelements = {};
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      choosingelements[document] = 0;
      for (String titling in ingredients) {
        //checking which recipes have the same title as thos the user selected
        if ((data['ingredients'].toLowerCase())
            .contains(titling.toLowerCase())) {
          choosingelements[document] = (choosingelements[document] ?? 0) + 1;
        }
      }
    }

    //Take the 5 closest
    List<QueryDocumentSnapshot> sortedKeys = choosingelements.keys.toList()
      ..sort((a, b) => choosingelements[b]!.compareTo(choosingelements[a]!));

    // Get the top 5 keys
    List<QueryDocumentSnapshot> top5Keys = sortedKeys.take(5).toList();

    return top5Keys;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.green,
          elevation: 0,
        ),
        //backgroundColor: Colors.transparent,
        drawer: const Menu(),
        body: PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              Navigator.pushNamedAndRemoveUntil(
                  context, homeRoute, (r) => false);
            },
            child: Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.background,
                ))),
                Positioned(
                  top: 105,
                  child: Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: const Text(
                            'Insert your available ingredients!',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 330,
                        height: 231,
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                List.generate(textControllers.length, (index) {
                              return Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          controller: textControllers[index],
                                          focusNode: index ==
                                                  textControllers.length - 1
                                              ? textFieldFocusNode
                                              : null,
                                          deleted: false,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            textControllers.removeAt(index);
                                          });
                                        },
                                      )
                                    ],
                                  ));
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Button(
                                type: ButtonType.write,
                                label: 'Write',
                                onPressed: () {
                                  setState(() {
                                    textControllers
                                        .add(TextEditingController());
                                    textFieldFocusNode = FocusNode();
                                  });
                                }),
                            const SizedBox(width: 34),
                            Button(
                                type: ButtonType.speak,
                                label: 'Voice',
                                onPressed: () {
                                  _isListening
                                      ? stopListening()
                                      : startListening();
                                }),
                          ])),
                      const SizedBox(height: 50),
                      Center(
                          child: Button(
                              type: ButtonType.find,
                              label: 'Find Recipes',
                              onPressed: () async {
                                List<String> ingredients = textControllers
                                    .map((controller) => controller.text.trim())
                                    .where((text) => text.isNotEmpty)
                                    .toList();
                                if (ingredients.isEmpty) {
                                  // Show an error message
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'You must provide ingredients first.'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  List<QueryDocumentSnapshot>? fetchedRecipes =
                                      await webscraping(ingredients);

                                  if (fetchedRecipes != null &&
                                      fetchedRecipes.isNotEmpty) {
                                    recipes = fetchedRecipes;
                                    Navigator.of(context).pushNamed(
                                      recipesRoute,
                                      arguments: recipes,
                                    );
                                  } else {
                                    recipes = [];
                                  }
                                }
                              }))
                    ],
                  ),
                ),
              ],
            )));
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    _speech.stop(); // Stop any ongoing speech recognition
    _speech.cancel(); // Cancel any ongoing speech recognition
    _hideOverlay();
    super.dispose();
  }
}
