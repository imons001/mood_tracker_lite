import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  // don't read .env at load time — read it inside the constructor
  late final String apiKey;

  OpenAIService() {
    apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('❌ Missing OPENAI_API_KEY in .env file');
    }
  }

  // this function generates the gentle reflection
  Future<String> getMoodFeedback({
    required String mood,
    required String journalText,
  }) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a kind and empathetic mood companion. Reflect gently and briefly "
                      "on the user's emotional state. Use a warm tone, never too formal."
            },
            {
              "role": "user",
              "content":
                  "Mood: $mood\nJournal Entry: $journalText\nGive one short reflective message.",
            },
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error connecting to OpenAI: $e';
    }
  }
}
