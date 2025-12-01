import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();

  // Helper method exposed for testing
  static String formatAssetName(String path) {
    return path
        .split('/')
        .last
        // *** FIX: Remove both .glb and .gltf extensions for cleaner names. ***
        .replaceAll(RegExp(r'\.glb$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\.gltf$', caseSensitive: false), '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}

class _ArPageState extends State<ArPage> {
  // Asset lists and selections
  List<String> _modelAssets = [];
  String? _selectedModel;
  
  // UI state
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModelAssets();
  }

  // Loads the list of 3D models from the assets folder.
  Future<void> _loadModelAssets() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      // *** FIX: Updated to detect both .glb and .gltf model files. ***
      final modelPaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/3d/'))
          .where((String key) => key.toLowerCase().endsWith('.glb') || key.toLowerCase().endsWith('.gltf'))
          .toList();

      setState(() {
        _modelAssets = modelPaths;
        if (_modelAssets.isNotEmpty) {
          _selectedModel = _modelAssets.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load 3D models: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Model Display'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            return Row(
              children: [
                // Model Selector on the left for landscape
                SizedBox(
                  width: 140,
                  child: _buildModelSelector(isVertical: true),
                ),
                // Main 3D model viewer
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage != null
                            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                            : _selectedModel == null
                                ? const Center(child: Text('No models found in assets/3d.'))
                                : ModelViewer(
                                    key: ValueKey(_selectedModel),
                                    src: _selectedModel!,
                                    alt: 'A 3D model of ${ArPage.formatAssetName(_selectedModel!)}',
                                    ar: true,
                                    autoRotate: true,
                                    cameraControls: true,
                                  ),
                  ),
                ),
              ],
            );
          }

          // Portrait layout
          return Column(
            children: [
              // The main 3D model viewer display area
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                          : _selectedModel == null
                              ? const Center(child: Text('No models found in assets/3d.'))
                              : ModelViewer(
                                  key: ValueKey(_selectedModel),
                                  src: _selectedModel!,
                                  alt: 'A 3D model of ${ArPage.formatAssetName(_selectedModel!)}',
                                  ar: true,
                                  autoRotate: true,
                                  cameraControls: true,
                                ),
                ),
              ),

              // The horizontally scrolling model selector UI at the bottom
              SizedBox(
                height: 150,
                child: _buildModelSelector(),
              ),
            ],
          );
        },
      ),
    );
  }

  // The list to select different models.
  Widget _buildModelSelector({bool isVertical = false}) {
    if (_isLoading) {
      return const SizedBox(height: 140);
    }
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[850], // Dark background like the old design
      child: _modelAssets.isEmpty
          ? const Center(
              child: Text(
                'No models available.',
                style: TextStyle(color: Colors.white),
              ),
            )
          // This ListView provides the scrolling for the models.
          : ListView.builder(
              scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
              itemCount: _modelAssets.length,
              itemBuilder: (context, index) {
                final modelAsset = _modelAssets[index];
                final modelName = ArPage.formatAssetName(modelAsset);
                final isSelected = _selectedModel == modelAsset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedModel = modelAsset;
                    });
                  },
                  child: Container(
                    width: isVertical ? null : 110, // Fixed width for horizontal items
                    height: isVertical ? 110 : null, // Fixed height for vertical items
                    margin: isVertical
                        ? const EdgeInsets.only(bottom: 12.0)
                        : const EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.white.withOpacity(0.8) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.view_in_ar_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            modelName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
