import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A page that displays 3D models using Augmented Reality (AR).
///
/// This widget allows users to view and interact with 3D models of
/// architectural structures. It supports loading models from assets
/// and displaying them in an AR view.
class ArPage extends StatefulWidget {
  /// Creates an instance of [ArPage].
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

/// The state for [ArPage].
class _ArPageState extends State<ArPage> {
  // Asset lists and selections
  List<String> _modelAssets = [];
  String? _selectedModel;
  
  // UI state
  bool _isLoading = true;
  String? _errorMessage;

  /// Initializes the state of the widget.
  ///
  /// This method triggers the loading of 3D model assets.
  @override
  void initState() {
    super.initState();
    _loadModelAssets();
  }

  /// Loads the list of 3D models from the assets folder.
  ///
  /// This method reads the asset manifest to find all files in the
  /// `assets/3d/` directory that have `.glb` or `.gltf` extensions.
  /// It updates the state with the list of found models.
  ///
  /// Returns a [Future] that completes when the assets are loaded.
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

  /// Formats the asset path to a readable name.
  ///
  /// This method takes the file path of a 3D model and converts it into
  /// a human-readable title by removing extensions and underscores, and
  /// capitalizing words.
  ///
  /// - [path]: The file path of the asset.
  ///
  /// Returns a formatted string representing the model name.
  String _formatAssetName(String path) {
    return path
        .split('/')
        .last
        // *** FIX: Remove both .glb and .gltf extensions for cleaner names. ***
        .replaceAll('.glb', '')
        .replaceAll('.gltf', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  /// Builds the widget tree for the AR page.
  ///
  /// - [context]: The build context.
  ///
  /// Returns a [Scaffold] containing the AR view and model selector.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Model Display'),
      ),
      body: Column(
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
                              alt: 'A 3D model of ${_formatAssetName(_selectedModel!)}',
                              ar: true,
                              autoRotate: true,
                              cameraControls: true,
                            ),
            ),
          ),
          
          // The horizontally scrolling model selector UI at the bottom
          _buildModelSelector(),
        ],
      ),
    );
  }

  /// Builds the horizontal list to select different models.
  ///
  /// This widget displays a list of available 3D models. Users can tap on
  /// an item to select it for viewing.
  ///
  /// Returns a [Widget] containing the model selector.
  Widget _buildModelSelector() {
    if (_isLoading) {
      return const SizedBox(height: 140);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.grey[850], // Dark background like the old design
      height: 150,
      child: _modelAssets.isEmpty
          ? const Center(
              child: Text(
                'No models available.',
                style: TextStyle(color: Colors.white),
              ),
            )
          // This ListView provides the horizontal scrolling for the models.
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: _modelAssets.length,
              itemBuilder: (context, index) {
                final modelAsset = _modelAssets[index];
                final modelName = _formatAssetName(modelAsset);
                final isSelected = _selectedModel == modelAsset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedModel = modelAsset;
                    });
                  },
                  child: Container(
                    width: 110, // Fixed width for each item
                    margin: const EdgeInsets.only(right: 12.0),
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
