import 'package:craftfolio/custom_text_field.dart';
import 'package:flutter/material.dart';

class HobbiesSection extends StatefulWidget {
  final List<String>? initialData;
  final Function(List<String>) onDataChanged;

  const HobbiesSection({
    Key? key,
    this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<HobbiesSection> createState() => _HobbiesSectionState();
}

class _HobbiesSectionState extends State<HobbiesSection> {
  // Hobbies
  List<String> _hobbies = [];
  final _hobbyController = TextEditingController();
  String? _unfinishedHobby;

  void _onTextFieldChanged() {
    _unfinishedHobby = _hobbyController.text;
    _notifyParent();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to hobby controller
    _hobbyController.addListener(_onTextFieldChanged);

    if (widget.initialData != null) {
      // Extract hobbies and unfinished entry if present
      if (widget.initialData!.isNotEmpty && widget.initialData!.last.startsWith('__unfinished__:')) {
        _unfinishedHobby = widget.initialData!.last.substring('__unfinished__:'.length);
        _hobbyController.text = _unfinishedHobby!;
        _hobbies = List<String>.from(widget.initialData!.take(widget.initialData!.length - 1));
      } else {
        _hobbies = List<String>.from(widget.initialData!);
      }
    }
  }

  void _notifyParent() {
    List<String> dataToSave = List.from(_hobbies);
    
    // If there's an unfinished hobby, add it with a special prefix
    if (_unfinishedHobby != null && _unfinishedHobby!.isNotEmpty) {
      dataToSave.add('__unfinished__:$_unfinishedHobby');
    }
    
    widget.onDataChanged(dataToSave);
  }

  void _addHobby() {
    if (_hobbyController.text.isNotEmpty) {
      setState(() {
        _hobbies.add(_hobbyController.text);
        _hobbyController.clear();
        _unfinishedHobby = null;
        _notifyParent();
      });
    }
  }

  void _removeHobby(int index) {
    setState(() {
      _hobbies.removeAt(index);
      _notifyParent();
    });
  }

  @override
  void dispose() {
    // Remove listener
    _hobbyController.removeListener(_onTextFieldChanged);
    // Dispose controller
    _hobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hobbies & Interests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
                    onPressed: _addHobby,
                    tooltip: 'Add hobby',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Display existing hobbies
            if (_hobbies.isNotEmpty) ...[          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _hobbies.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hobby = entry.value;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              hobby,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => _removeHobby(index),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Add new hobby
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _hobbyController,
                    hintText: 'Add a hobby or interest',
                    prefixIcon: Icons.favorite_border,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Examples: Reading, Photography, Traveling, Cooking, Sports, Music, etc.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
