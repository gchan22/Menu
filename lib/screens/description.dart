import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'finalized_description.dart';

class DescriptionScreen extends StatefulWidget {
  final String itemName;

  const DescriptionScreen({super.key, required this.itemName});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final List<TextEditingController> _descriptionControllers = [];

  @override
  void dispose() {
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTextBox() {
    setState(() {
      _descriptionControllers.add(TextEditingController());
    });
  }

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
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: _descriptionControllers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _descriptionControllers[index],
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Enter description...',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _descriptionControllers[index].dispose();
                                  _descriptionControllers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalizedDescriptionScreen(
                        itemName: widget.itemName,
                        descriptionRows: _descriptionControllers
                            .map((c) => c.text)
                            .where((t) => t.isNotEmpty)
                            .toList(),
                        showSample: false,
                      ),
                    ),
                  );
                },
                child: const Text('Exit'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTextBox,
        label: const Text('Add Description'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
