import 'package:flutter/material.dart';
import 'package:flutter_gpt/common/colors.dart';
import 'package:flutter_gpt/feature_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: const Text(
          "Flutter GPT",
          style: TextStyle(fontFamily: "Cera Pro"),
        ),
      ),
      body: Column(
        children: [
          Stack(children: [
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
                      image: AssetImage('assets/images/virtualAssistant.png'))),
            )
          ]),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(color: AppColours.borderColor),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
            child: const Text(
              "Good Morning, what task can I do for you?",
              style: TextStyle(
                  color: AppColours.mainFontColor,
                  fontFamily: "Cera Pro",
                  fontSize: 25),
            ),
          ),
          Container(
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
          ),
          Column(children: const [
            FeatureBox(
              color: AppColours.firstSuggestionBoxColor,
              headerText: "ChatGPT",
              descriptionText:
                  "A smarter way to stay organized and informed with ChatGPT",
            ),
            FeatureBox(
              color: AppColours.secondSuggestionBoxColor,
              headerText: "Dall-E",
              descriptionText:
                  "Get inspired and stay creative with your personal assistant powered by Dall-E",
            ),
            FeatureBox(
                color: AppColours.thirdSuggestionBoxColor,
                headerText: "Smart Voice Assistant",
                descriptionText:
                    "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT")
          ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColours.firstSuggestionBoxColor,
        onPressed: () {},
        child: const Icon(Icons.mic),
      ),
    );
  }
}
