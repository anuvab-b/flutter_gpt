import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gpt/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAPIKey"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        debugPrint("Success");
        String content =
            jsonDecode(response.body)["choices"][0]["message"]["content"];
        content = content.trim();
        switch (content) {
          case "Yes":
          case "yes":
          case "Yes.":
          case "yes.":
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return "An Internal Error Occurred";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      "role": "user",
      "content": prompt,
    });
    try {
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAPIKey"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        debugPrint("Success");
        String content =
            jsonDecode(response.body)["choices"][0]["message"]["content"];
        content = content.trim();
        messages.add({
          "role": "assistant",
          "content": content,
        });
        return content;
      }
      return "An Internal Error Occurred";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      "role": "user",
      "content": prompt,
    });
    try {
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/images/generation"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAPIKey"
          },
          body: jsonEncode({"prompt": prompt, "n": 1}));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        debugPrint("Success");
        String imageUrl =
            jsonDecode(response.body)["data"][0]["url"];
        imageUrl = imageUrl.trim();
        messages.add({
          "role": "assistant",
          "content": imageUrl,
        });
        return imageUrl;
      }
      return "An Internal Error Occurred";
    } catch (e) {
      return e.toString();
    }
    return "DALL-E";
  }
}
