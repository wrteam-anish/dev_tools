import 'dart:convert';

String generateCurlCommand(Map<String, dynamic> data,
    {bool isMultipart = false}) {
  String url = data['url'] ?? '';
  String method = data['method'] ?? 'GET';
  Map<String, dynamic> body = data['body'] ?? {};
  List<String> headers = data['headers']?.split(',') ?? [];

  String curlCommand = 'curl -X $method $url';

  // Add headers
  for (var header in headers) {
    curlCommand += ' -H "$header"';
  }

  // Handle normal or multipart body (only for methods like POST, PUT)

  if (method != 'GET') {
    if (isMultipart) {
      body.forEach((key, value) {
        curlCommand += ' -F "$key=${Uri.encodeComponent(value.toString())}"';
      });
    } else if (body.isNotEmpty) {
      curlCommand += ' -d';
      curlCommand += ' "${jsonEncode(body)}"'; // Convert Map to JSON string
    }
  }

  return curlCommand;
}
