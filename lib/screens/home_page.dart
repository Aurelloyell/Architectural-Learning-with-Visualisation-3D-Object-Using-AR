import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Modern gradient background
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8F9FA),
              const Color(0xFFE0E7FF).withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

              if (isLandscape) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                  child: Row(
                    children: [
                      // Left side
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(context),
                            const Spacer(),
                            _buildNavButton(
                              context: context,
                              icon: Icons.menu_book_rounded,
                              label: 'Learning Materials',
                              subLabel: 'Explore architectural concepts',
                              onTap: () => Navigator.pushNamed(context, '/materi'),
                              isPrimary: true,
                            ),
                            const SizedBox(height: 20),
                            _buildNavButton(
                              context: context,
                              icon: Icons.view_in_ar_rounded,
                              label: 'AR Visualization',
                              subLabel: 'View 3D models in space',
                              onTap: () => Navigator.pushNamed(context, '/ar'),
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Right side image
                      Expanded(
                        flex: 6,
                        child: _buildHeroImage(),
                      ),
                    ],
                  ),
                );
              }

              // Portrait Mode
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(context),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: _buildHeroImage(),
                      ),
                    ),
                    Column(
                      children: [
                        _buildNavButton(
                          context: context,
                          icon: Icons.menu_book_rounded,
                          label: 'Learning Materials',
                          subLabel: 'Explore architectural concepts',
                          onTap: () => Navigator.pushNamed(context, '/materi'),
                          isPrimary: true,
                        ),
                        const SizedBox(height: 16),
                        _buildNavButton(
                          context: context,
                          icon: Icons.view_in_ar_rounded,
                          label: 'AR Visualization',
                          subLabel: 'View 3D models in space',
                          onTap: () => Navigator.pushNamed(context, '/ar'),
                          isPrimary: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang,',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ARsitektur',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        )
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/arsitektur_image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subLabel,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isPrimary ? colors.primary : colors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isPrimary ? Colors.white : colors.secondary,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.primary.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: colors.primary.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}