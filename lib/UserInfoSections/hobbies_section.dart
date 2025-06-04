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

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _hobbies = List<String>.from(widget.initialData!);
    }
  }

  void _notifyParent() {
    widget.onDataChanged(_hobbies);
  }

  void _addHobby() {
    if (_hobbyController.text.trim().isNotEmpty) {
      setState(() {
        _hobbies.add(_hobbyController.text.trim());
        _hobbyController.clear();
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
    _hobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 16),
          
          // Display existing hobbies
          if (_hobbies.isNotEmpty) ...[          
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hobbies.asMap().entries.map((entry) {
                final index = entry.key;
                final hobby = entry.value;
                return Chip(
                  label: Text(hobby),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white),
                  deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white70),
                  onDeleted: () => _removeHobby(index),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Add new hobby
          CustomTextField(
            controller: _hobbyController,
            hintText: 'Add a hobby or interest',
            prefixIcon: Icons.favorite_border,
          ),
          const SizedBox(height: 16),
          const Text(
            'Examples: Reading, Photography, Traveling, Cooking, Sports, Music, etc.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
