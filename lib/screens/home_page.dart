import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            if (isLandscape) {
               return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    // Left side: Header and Nav Buttons
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                          const Spacer(),
                          _buildNavButton(
                            context: context,
                            icon: Icons.menu_book_rounded,
                            label: 'Materi Page',
                            onTap: () {
                              Navigator.pushNamed(context, '/materi');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildNavButton(
                            context: context,
                            icon: Icons.view_in_ar_rounded,
                            label: 'AR Page',
                            onTap: () {
                              Navigator.pushNamed(context, '/ar');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Right side: Image
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/arsitektur_image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Portrait Mode (Original Layout)
            return Padding(
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
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        // You can add an image here later
                        image: const DecorationImage(
                          image: AssetImage('assets/images/arsitektur_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
            );
          },
        ),
      ),
    );
  }

  // A helper widget to build the navigation buttons, reducing code repetition.
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
