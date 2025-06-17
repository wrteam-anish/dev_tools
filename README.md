<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Dev Tools

A Flutter development toolkit that provides powerful debugging and monitoring capabilities for your Flutter applications. This package offers a comprehensive set of tools to help developers debug API calls, monitor console logs, and track application errors in real-time.

## Features

- **API Logger**: Monitor and inspect all API requests and responses
  - View detailed request/response information
  - Copy cURL commands for API calls
  - JSON response visualization
  - Request/response headers inspection
  - Query parameters tracking

- **Console Logger**: Track application errors and exceptions
  - Real-time error monitoring
  - Detailed error stack traces
  - Error history tracking

- **Debugger Overlay**: Easy access to debugging tools
  - Draggable debug button
  - Expandable debug panel
  - Tabbed interface for different debugging tools

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dev_tools:
    path: ../dev_tools  # Use the correct path to the package
```

## Usage

### 1. Initialize the Debugger

In your `main.dart` file, initialize the debugger:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          // Initialize debugger
          Debugger.init(context);
          return YourHomePage();
        },
      ),
    );
  }
}
```

### 2. Set up API Logging

To monitor API calls, add the API logger interceptor to your Dio client:

```dart
final dio = Dio();
dio.interceptors.add(ApiLogger.use());
```

### 3. Enable Console Logging

To track application errors and exceptions:

```dart
void main() {
  Console.use();  // Enable console logging
  runApp(MyApp());
}
```

## Features in Detail

### API Logger

The API Logger provides a comprehensive view of all API calls in your application:

- View request details including:
  - URL and method
  - Headers
  - Query parameters
  - Request body
- Inspect response data with JSON visualization
- Copy cURL commands for testing
- Track response status codes

### Console Logger

The Console Logger helps you track application errors:

- Real-time error monitoring
- Detailed error stack traces
- Error history with timestamps
- Easy-to-read error formatting

### Debugger Overlay

The debugger overlay provides easy access to all debugging tools:

- Draggable debug button that stays on top of your app
- Expandable debug panel with tabbed interface
- Quick access to API logs and console
- Non-intrusive design that doesn't interfere with app usage

## Additional Information

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Issues and Feedback

Please file issues and feature requests on the GitHub repository.

### License

This project is licensed under the MIT License - see the LICENSE file for details.
