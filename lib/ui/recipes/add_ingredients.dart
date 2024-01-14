import 'package:reciperator/app/buttons.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:reciperator/app/colors.dart';
import 'package:reciperator/ui/home/menu.dart';
import 'package:reciperator/app/text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddIngredients extends StatefulWidget {
  const AddIngredients({super.key});

  @override
  State<AddIngredients> createState() => _AddIngredientsState();
}

class _AddIngredientsState extends State<AddIngredients> {
  List<TextEditingController> textControllers = [];
  FocusNode? textFieldFocusNode;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      // Handle the case where speech recognition is not available
    }
  }

  void startListening() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle the case where the user does not grant permission
      print("Microphone permission not granted");
      return;
    }
    _speech.listen(onResult: (result) {
      if (result.finalResult) {
        setState(() {
          textControllers.add(TextEditingController(text: result.recognizedWords));
        });
      }
    });
    setState(() => _isListening = true);
  }

  void stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
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
        body: Stack(
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
                            child: CustomTextField(
                              controller: textControllers[index],
                              focusNode: index == textControllers.length - 1
                                  ? textFieldFocusNode
                                  : null,
                            ),
                          );
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
                                textControllers.add(TextEditingController());
                                textFieldFocusNode = FocusNode();
                              });
                            }),
                        const SizedBox(width: 34),
                        Button(
                            type: ButtonType.speak,
                            label: 'Voice',
                            onPressed: _isListening ? stopListening : startListening),
                      ])),
                  const SizedBox(height: 50),
                  Center(
                      child: Button(
                          type: ButtonType.find,
                          label: 'Find Recipes',
                          onPressed: () {
                            Navigator.pushNamed(context, recipesRoute);
                          }))
                ],
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    textControllers.forEach((controller) => controller.dispose());
    _speech.stop(); // Stop any ongoing speech recognition
    _speech.cancel(); // Cancel any ongoing speech recognition
    super.dispose();
  }
}
