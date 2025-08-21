import 'package:flutter/material.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ErrorFallback extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorFallback({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
