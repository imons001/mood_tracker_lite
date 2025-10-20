import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  late final String apiKey;
  late final String? projectId;

  OpenAIService() {
    apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    projectId = dotenv.env['OPENAI_PROJECT_ID'];

    // Debugging prints
    print(
        '🔑 Loaded API Key: ${apiKey.isNotEmpty ? "✅ (exists)" : "❌ (missing)"}');
    print('📁 Loaded Project ID: ${projectId ?? "❌ (none)"}');

    if (apiKey.isEmpty) {
      throw Exception('❌ Missing OPENAI_API_KEY in .env file');
    }
  }

  Future<String> getMoodFeedback({
    required String mood,
    required String journalText,
  }) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    try {
      // Build headers dynamically
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      // Add lowercase project header for sk-proj keys
      if (apiKey.startsWith('sk-proj-') &&
          projectId != null &&
          projectId!.isNotEmpty) {
        headers['openai-project'] = projectId!;
      }

      print('🌐 Sending request to OpenAI with headers: $headers');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
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
                  "Mood: $mood\nJournal Entry: $journalText\nGive one short reflective message."
            },
          ]
        }),
      );

      // Debug: show status and body
      print('📩 Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        // If not 200, show the full reason from the API
        final errorBody = jsonDecode(response.body);
        final errorMsg =
            errorBody['error']?['message'] ?? response.reasonPhrase;
        return 'Error ${response.statusCode}: $errorMsg';
      }
    } catch (e) {
      return 'Error connecting to OpenAI: $e';
    }
  }
}
