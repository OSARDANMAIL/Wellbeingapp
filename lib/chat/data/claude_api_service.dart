import 'dart:convert';
import 'package:http/http.dart' as http;

/* 
  Service class to handle Claude API requests 
*/
class ClaudeApiService {
  // API Constants
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _apiVersion = '2023-06-01';
  static const String _model = 'claude-3-opus-20240229';
  static const int _maxTokens = 1024;

  // Store the API key securely
  final String _apiKey;

  // Require API key
  ClaudeApiService({required String apiKey}) : _apiKey = apiKey;

  /*
   * Send a message to Claude API & return the response
   */
  Future<String> sendMessage(String content) async {
    try {
      // Make POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: _getRequestBody(content),
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Parse JSON response

        // Ensure 'content' is correctly extracted
        if (data.containsKey('content') && data['content'] is String) {
          return data['content']; // Return as a string
        } else if (data.containsKey('content') && data['content'] is List) {
          // Handle case where 'content' is a List of responses
          return data['content']
              .join("\n"); // Join multiple messages into a single string
        } else {
          throw Exception('Unexpected API response format: ${response.body}');
        }
      } else {
        throw Exception(
            'Failed to get response from Claude: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle any errors during API call
      throw Exception('API Error: $e');
    }
  }

  // Create required headers
  Map<String, String> _getHeaders() => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': _apiVersion,
      };

  // Format request body according to Claude API
  String _getRequestBody(String content) => jsonEncode({
        'model': _model,
        'max_tokens': _maxTokens,
        'messages': [
          {'role': 'user', 'content': content} // Properly sending user input
        ],
      });
}
