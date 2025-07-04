import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
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
      
      final modelPaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/3d/'))
          .where((String key) => key.toLowerCase().endsWith('.glb')) // model_viewer_plus works best with .glb
          .toList();

      setState(() {
        _modelAssets = modelPaths;
        // Pre-select the first model if the list is not empty.
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

  // Formats asset path to a readable name.
  String _formatAssetName(String path) {
    return path
        .split('/')
        .last
        .replaceAll('.glb', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Model Display'),
        // The back button is automatically added by the Navigator.
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The main 3D model viewer display area
          AspectRatio(
            aspectRatio: 1.1, // A nice ratio for the viewer
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                // Optional: add a border
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                      : _selectedModel == null
                          ? const Center(child: Text('No models found. Please add .glb files to assets/3d.'))
                          : ModelViewer(
                              // Use a key to force the widget to reload when the model changes
                              key: ValueKey(_selectedModel),
                              src: 'assets/$_selectedModel',
                              alt: 'A 3D model of ${_formatAssetName(_selectedModel!)}',
                              ar: true, // Enable the AR button
                              autoRotate: true,
                              cameraControls: true,
                            ),
            ),
          ),
          
          // Title for the selector grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Select a Model',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // *** NEW: Vertically scrolling grid of models ***
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 models per row
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9, // Adjust for aesthetics
                ),
                itemCount: _modelAssets.length,
                itemBuilder: (context, index) {
                  return _buildModelTile(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for building each model tile in the grid.
  Widget _buildModelTile(BuildContext context, int index) {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_in_ar_outlined,
              size: 48,
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                modelName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
