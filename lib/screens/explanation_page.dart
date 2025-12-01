import 'package:flutter/material.dart';

/// A page that displays detailed explanation of a material.
///
/// This widget shows the title and full content of a selected topic.
class ExplanationPage extends StatelessWidget {
  /// The title of the material.
  final String title;

  /// The detailed content of the material.
  final String content;

  /// Creates an instance of [ExplanationPage].
  ///
  /// - [title]: The title of the material to display.
  /// - [content]: The content description to display.
  const ExplanationPage({
    super.key,
    required this.title,
    required this.content,
  });

  /// Builds the widget tree for the explanation page.
  ///
  /// - [context]: The build context.
  ///
  /// Returns a [Scaffold] widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.6, // Improves readability
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
