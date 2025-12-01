import 'package:flutter/material.dart';

/// The home page of the application.
///
/// This page displays the welcome message, a hero image, and navigation
/// buttons to the other sections of the app: Material Page and AR Page.
class HomePage extends StatelessWidget {
  /// Creates an instance of [HomePage].
  const HomePage({super.key});

  /// Builds the widget tree for the home page.
  ///
  /// - [context]: The build context.
  ///
  /// Returns a [Scaffold] widget.
  @override
  Widget build(BuildContext context) {
    // We use a SafeArea to avoid the UI being obscured by system notches or bars.
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Aligns children to the start and end of the column.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'ARsitektur',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              
              // Image Placeholder Section
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  // You can add an image here later
                  image: const DecorationImage(
                    image: AssetImage('assets/images/arsitektur_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: const Center(
                //   child: Text(
                //     'ARsitektur Image',
                //     style: TextStyle(color: Colors.black45, fontSize: 18),
                //   ),
                // ),
              ),

              // Navigation Buttons Section
              Column(
                children: [
                  _buildNavButton(
                    context: context,
                    icon: Icons.menu_book_rounded,
                    label: 'Materi Page',
                    onTap: () {
                      // Navigate to the Materi page when tapped.
                      Navigator.pushNamed(context, '/materi');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNavButton(
                    context: context,
                    icon: Icons.view_in_ar_rounded,
                    label: 'AR Page',
                    onTap: () {
                      // Navigate to the AR page when tapped.
                      Navigator.pushNamed(context, '/ar');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a navigation button widget.
  ///
  /// This helper method creates a consistent button style for navigation.
  ///
  /// - [context]: The build context used to access theme data.
  /// - [icon]: The icon to display on the button.
  /// - [label]: The text label for the button.
  /// - [onTap]: The callback function to execute when the button is tapped.
  ///
  /// Returns a [Widget] representing the navigation button.
  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context).colorScheme;
    return Material(
      color: theme.secondary, // Light teal background
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.primary, // Darker teal icon
              ),
              const SizedBox(width: 20),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
