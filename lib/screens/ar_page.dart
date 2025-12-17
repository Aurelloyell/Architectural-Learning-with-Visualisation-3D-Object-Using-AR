import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  // We now store File objects, not just strings
  List<File> _localModelFiles = [];
  File? _selectedModelFile;
  bool _isLoading = true;
  String? _statusMessage; // Shows "Checking updates..." or "Downloading..."

  final String _githubOwner = 'aurelloyell';
  final String _githubRepo = 'Architectural-Learning-with-Visualisation-3D-Object-Using-AR';
  final String _path = 'assets/3d';

  @override
  void initState() {
    super.initState();
    _syncModels();
  }

  // 1. Get local directory for saving models
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${directory.path}/models');
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return modelDir.path;
  }

  // 2. Main Sync Logic
  Future<void> _syncModels() async {
    setState(() => _statusMessage = "Checking for updates...");

    try {
      final localPath = await _getLocalPath();
      final localDir = Directory(localPath);

      // A. Fetch remote list from GitHub
      final Uri apiUrl = Uri.parse(
        'https://api.github.com/repos/$_githubOwner/$_githubRepo/contents/$_path',
      );
      
      final response = await http.get(apiUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Filter for 3D models
        final remoteModels = data.where((file) {
          final name = file['name'].toString().toLowerCase();
          return name.endsWith('.glb') || name.endsWith('.gltf');
        }).toList();

        // B. Check and Download each model
        for (var model in remoteModels) {
          final String name = model['name'];
          final String downloadUrl = model['download_url'];
          // Use SHA to detect changes if you wanted robust syncing,
          // but for now we just check existence.

          final File localFile = File('$localPath/$name');

          if (!await localFile.exists()) {
            await _downloadFile(downloadUrl, localFile, name);
          }
        }
      } 
      
      // C. Load all files from the local directory
      final List<FileSystemEntity> files = localDir.listSync();
      final List<File> glbFiles = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.glb') || file.path.endsWith('.gltf'))
          .toList();

      if (mounted) {
        setState(() {
          _localModelFiles = glbFiles;
          if (_localModelFiles.isNotEmpty) {
            _selectedModelFile = _localModelFiles.first;
          }
          _isLoading = false;
          _statusMessage = null;
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = "Error: $e";
          _isLoading = false;
        });
      }
    }
  }

  // Helper to download a file
  Future<void> _downloadFile(String url, File targetFile, String name) async {
    if (mounted) setState(() => _statusMessage = "Downloading $name...");
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await targetFile.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      debugPrint("Error downloading $name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Visualisasi AR (Offline-Ready)'),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 20
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            return Row(
              children: [
                Container(
                  width: 120,
                  color: Colors.black.withOpacity(0.5),
                  child: SafeArea(child: _buildModelSelector(isVertical: true)),
                ),
                Expanded(child: _buildARViewer()),
              ],
            );
          }

          return Stack(
            children: [
              _buildARViewer(),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 120,
                  child: _buildModelSelector(),
                ),
              ),
              // Status Indicator at the top
              if (_statusMessage != null)
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusMessage!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildARViewer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.grey[900]!, const Color(0xFF000000)],
          radius: 1.2,
          center: Alignment.center,
        ),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _selectedModelFile == null
              ? const Center(child: Text('No models downloaded yet.', style: TextStyle(color: Colors.white)))
              : ModelViewer(
                  // Use 'file://' prefix for local files explicitly
                  key: ValueKey(_selectedModelFile!.path), 
                  src: 'file://${_selectedModelFile!.path}',
                  alt: 'AR Model',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                ),
    );
  }

  Widget _buildModelSelector({bool isVertical = false}) {
    if (_localModelFiles.isEmpty) return const SizedBox();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
      itemCount: _localModelFiles.length,
      itemBuilder: (context, index) {
        final File file = _localModelFiles[index];
        final String filePath = file.path;
        final bool isSelected = _selectedModelFile?.path == filePath;

        // Extract filename from path for display
        final String filename = filePath.split('/').last
            .replaceAll('.glb', '')
            .replaceAll('.gltf', '')
            .replaceAll('_', ' ');

        return GestureDetector(
          onTap: () => setState(() => _selectedModelFile = file),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isVertical ? null : 80,
            height: isVertical ? 80 : null,
            margin: isVertical 
                ? const EdgeInsets.only(bottom: 16) 
                : const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 3) : null,
              boxShadow: isSelected 
                  ? [BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 15)] 
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.view_in_ar_rounded, 
                  color: isSelected ? Colors.black87 : Colors.white70,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  filename,
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}