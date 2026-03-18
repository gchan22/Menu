import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasteboard/pasteboard.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/description_input_row.dart';
import 'finalized_description.dart';
import '../providers/description_provider.dart';

/// A wrapper to keep track of either a text controller or image data
class DescriptionItem {
  TextEditingController? controller;
  String? imageData; // Base64 encoded image string
  bool isImage;

  DescriptionItem({this.controller, this.imageData, this.isImage = false});
}

/// DescriptionScreen allows users to add and edit multiple text rows and images describing a specific food item.
class DescriptionScreen extends ConsumerStatefulWidget {
  final String itemName;
  final String category; // Used for navigation back to the correct category list

  const DescriptionScreen({
    super.key,
    required this.itemName,
    required this.category,
  });

  @override
  ConsumerState<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends ConsumerState<DescriptionScreen> {
  // A list of items to manage both dynamic text fields and images
  final List<DescriptionItem> _descriptionItems = [];

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing descriptions from global state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final existingRows = ref.read(descriptionProvider)[widget.itemName] ?? [];
      setState(() {
        for (var row in existingRows) {
          if (row.startsWith('IMAGE:')) {
            _descriptionItems.add(DescriptionItem(
              imageData: row.substring(6),
              isImage: true,
            ));
          } else {
            // Support legacy data without prefix or explicit TEXT: prefix
            final text = row.startsWith('TEXT:') ? row.substring(5) : row;
            _descriptionItems.add(DescriptionItem(
              controller: TextEditingController(text: text),
              isImage: false,
            ));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose all dynamic controllers to prevent memory leaks
    for (var item in _descriptionItems) {
      item.controller?.dispose();
    }
    super.dispose();
  }

  /// Saves all non-empty description rows to the Riverpod provider.
  void _saveData() {
    final List<String> rows = [];
    for (var item in _descriptionItems) {
      if (item.isImage && item.imageData != null) {
        rows.add('IMAGE:${item.imageData}');
      } else if (!item.isImage && item.controller != null) {
        rows.add('TEXT:${item.controller!.text}');
      }
    }
    ref.read(descriptionProvider.notifier).setDescriptionRows(
      widget.itemName,
      rows,
    );
  }

  /// Adds a new empty text field for a new description row.
  void _addTextBox() {
    setState(() {
      _descriptionItems.add(DescriptionItem(
        controller: TextEditingController(),
        isImage: false,
      ));
    });
    _saveData();
  }

  /// Adds a picture from clipboard (paste) or gallery.
  Future<void> _addPicture() async {
    // Try to get from pasteboard first (Copy & Paste)
    try {
      final imageBytes = await Pasteboard.image;
      if (imageBytes != null) {
        _processImage(imageBytes);
        return;
      }
    } catch (e) {
      // Pasteboard might fail on some platforms/scenarios
    }

    // Fallback to Image Picker
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      _processImage(bytes);
    }
  }

  void _processImage(Uint8List bytes) {
    final base64Image = base64Encode(bytes);
    setState(() {
      _descriptionItems.add(DescriptionItem(
        imageData: base64Image,
        isImage: true,
      ));
    });
    _saveData();
  }

  /// The screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Description'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
            child: Column(
              children: [
                // Item Name title
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Dynamic list of description input rows
                Expanded(
                  child: ListView.separated(
                    itemCount: _descriptionItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _descriptionItems[index];
                      if (item.isImage) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.memory(
                                  base64Decode(item.imageData!),
                                  fit: BoxFit.contain,
                                  height: 200,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _descriptionItems.removeAt(index);
                                  });
                                  _saveData();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return DescriptionInputRow(
                          controller: item.controller!,
                          onChanged: _saveData,
                          onDelete: () {
                            setState(() {
                              item.controller!.dispose();
                              _descriptionItems.removeAt(index);
                            });
                            _saveData();
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Exit button at the bottom center
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                label: 'Exit Editing',
                onPressed: () {
                  _saveData();
                  // Navigate to the finalized preview of the item description
                  final List<String> finalRows = [];
                  for (var item in _descriptionItems) {
                    if (item.isImage && item.imageData != null) {
                      finalRows.add('IMAGE:${item.imageData}');
                    } else if (!item.isImage && item.controller != null && item.controller!.text.isNotEmpty) {
                      finalRows.add('TEXT:${item.controller!.text}');
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalizedDescriptionScreen(
                        itemName: widget.itemName,
                        descriptionRows: finalRows,
                        showSample: false,
                        category: widget.category,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Floating action buttons
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_picture_fab',
            onPressed: _addPicture,
            label: const Text('+ Add Picture'),
            icon: const Icon(Icons.add_a_photo),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'add_description_fab',
            onPressed: _addTextBox,
            label: const Text('+ Add Description'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
