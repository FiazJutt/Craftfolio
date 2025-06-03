import 'package:craftfolio/custom_text_field.dart';
import 'package:flutter/material.dart';

class EducationSection extends StatefulWidget {
  final List<Map<String, dynamic>>? initialData;
  final Function(List<Map<String, dynamic>>) onDataChanged;

  const EducationSection({
    Key? key,
    this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  List<Map<String, dynamic>> _educationList = [];
  final _degreeController = TextEditingController();
  final _institutionController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _onTextFieldChanged() {
    _notifyParent();
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all text controllers
    _degreeController.addListener(_onTextFieldChanged);
    _institutionController.addListener(_onTextFieldChanged);
    _yearController.addListener(_onTextFieldChanged);
    _descriptionController.addListener(_onTextFieldChanged);

    if (widget.initialData != null) {
      _educationList = List<Map<String, dynamic>>.from(widget.initialData!);
      // If there's an unfinished entry, load it into the form
      if (_educationList.isNotEmpty && _educationList.last['isUnfinished'] == true) {
        final unfinished = _educationList.removeLast();
        _degreeController.text = unfinished['degree'] ?? '';
        _institutionController.text = unfinished['institution'] ?? '';
        _yearController.text = unfinished['year'] ?? '';
        _descriptionController.text = unfinished['description'] ?? '';
      }
    }
  }

  void _notifyParent() {
    List<Map<String, dynamic>> dataToSave = List.from(_educationList);
    
    // If there's data in any of the input fields, save it as an unfinished entry
    if (_degreeController.text.isNotEmpty || 
        _institutionController.text.isNotEmpty ||
        _yearController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      dataToSave.add({
        'degree': _degreeController.text,
        'institution': _institutionController.text,
        'year': _yearController.text,
        'description': _descriptionController.text,
        'isUnfinished': true,
      });
    }
    
    widget.onDataChanged(dataToSave);
  }

  void _addEducation() {
    if (_degreeController.text.isNotEmpty && 
        _institutionController.text.isNotEmpty) {
      setState(() {
        _educationList.add({
          'degree': _degreeController.text,
          'institution': _institutionController.text,
          'year': _yearController.text,
          'description': _descriptionController.text,
          'isUnfinished': false,
        });
        
        // Clear controllers
        _degreeController.clear();
        _institutionController.clear();
        _yearController.clear();
        _descriptionController.clear();
        
        _notifyParent();
      });
    }
  }

  void _removeEducation(int index) {
    setState(() {
      _educationList.removeAt(index);
      _notifyParent();
    });
  }

  @override
  void dispose() {
    // Remove listeners from all text controllers
    _degreeController.removeListener(_onTextFieldChanged);
    _institutionController.removeListener(_onTextFieldChanged);
    _yearController.removeListener(_onTextFieldChanged);
    _descriptionController.removeListener(_onTextFieldChanged);

    // Dispose all controllers
    _degreeController.dispose();
    _institutionController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
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
                'Education',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
                onPressed: _addEducation,
                tooltip: 'Add education',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List of existing education entries
          if (_educationList.isNotEmpty) ...[          
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _educationList.length,
              itemBuilder: (context, index) {
                final edu = _educationList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${edu['degree']} at ${edu['institution']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white70, size: 20),
                              onPressed: () => _removeEducation(index),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        if (edu['period'] != null && edu['period'].isNotEmpty) ...[                        
                          const SizedBox(height: 4),
                          Text(
                            edu['period'],
                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                        if (edu['description'] != null && edu['description'].isNotEmpty) ...[                        
                          const SizedBox(height: 8),
                          Text(
                            edu['description'],
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(color: Colors.white30),
          ],
          
          // Form for adding new education
          CustomTextField(
            controller: _degreeController,
            hintText: 'Degree/Certificate',
            prefixIcon: Icons.workspace_premium_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _institutionController,
            hintText: 'School/University',
            prefixIcon: Icons.school_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _yearController,
            hintText: 'Period (e.g., Sep 2018 - Jun 2022)',
            prefixIcon: Icons.date_range_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _descriptionController,
            hintText: 'Description (courses, achievements)',
            prefixIcon: Icons.description_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Fill in the details and click + to add an education entry',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
