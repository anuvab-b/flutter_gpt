import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gpt/common/colors.dart';
import 'package:flutter_gpt/feature_box.dart';
import 'package:flutter_gpt/openai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  String lastWords = "";
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: BounceInDown(
          child: const Text(
            "Flutter GPT",
            style: TextStyle(fontFamily: "Cera Pro"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(children: [
                Center(
                    child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: AppColours.assistantCircleColor,
                      shape: BoxShape.circle),
                )),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/virtualAssistant.png'))),
                )
              ]),
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40)
                      .copyWith(top: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColours.borderColor),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: Radius.zero)),
                  child: Text(
                    generatedContent == null
                        ? "Good Morning, what task can I do for you?"
                        : generatedContent!,
                    style: TextStyle(
                        color: AppColours.mainFontColor,
                        fontFamily: "Cera Pro",
                        fontSize: generatedContent == null ? 25 : 18),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(generatedImageUrl!)),
              ),
            SlideInLeft(
              child: Visibility(
                  visible:
                      generatedContent == null && generatedImageUrl == null,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(top: 10.0, left: 22.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Here are a few features",
                      style: TextStyle(
                          fontFamily: "Cera Pro",
                          color: AppColours.mainFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(children: [
                SlideInLeft(
                  delay: Duration(milliseconds: start),
                  child: const FeatureBox(
                    color: AppColours.firstSuggestionBoxColor,
                    headerText: "ChatGPT",
                    descriptionText:
                        "A smarter way to stay organized and informed with ChatGPT",
                  ),
                ),
                SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: AppColours.secondSuggestionBoxColor,
                      headerText: "Dall-E",
                      descriptionText:
                          "Get inspired and stay creative with your personal assistant powered by Dall-E",
                    )),
                SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                        color: AppColours.thirdSuggestionBoxColor,
                        headerText: "Smart Voice Assistant",
                        descriptionText:
                            "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT"))
              ]),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: AppColours.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains("https")) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              debugPrint(speech);
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
