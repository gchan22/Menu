import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasteboard/pasteboard.dart';
import '../widgets/backdrop.dart';
import '../models/description_item.dart';
import '../widgets/description_list_view.dart';
import '../widgets/description_exit_button.dart';
import '../widgets/description_fabs.dart';
import '../providers/description_provider.dart';

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
      final existingRows = ref.read(descriptionProvider).value?[widget.itemName] ?? [];
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
                DescriptionListView(
                  items: _descriptionItems,
                  onDelete: (index) {
                    setState(() {
                      final item = _descriptionItems[index];
                      if (!item.isImage) {
                        item.controller?.dispose();
                      }
                      _descriptionItems.removeAt(index);
                    });
                    _saveData();
                  },
                  onSave: _saveData,
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
              child: DescriptionExitButton(
                itemName: widget.itemName,
                category: widget.category,
                descriptionItems: _descriptionItems,
                onSave: _saveData,
              ),
            ),
          ),
        ],
      ),
      // Floating action buttons
      floatingActionButton: DescriptionFabs(
        onAddPicture: _addPicture,
        onAddDescription: _addTextBox,
      ),
    );
  }
}
