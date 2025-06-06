import 'package:craftfolio/core/custom_text_field.dart';
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
  // Education - multiple entries
  List<Map<String, dynamic>> _educationEntries = [];
  final _educationTitleController =
      TextEditingController(); // Degree/Certificate
  final _educationInstitutionController =
      TextEditingController(); // Institution
  final _educationPeriodController = TextEditingController();
  final _educationDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _educationEntries = List<Map<String, dynamic>>.from(widget.initialData!);
    }
  }

  void _notifyParent() {
    widget.onDataChanged(_educationEntries);
  }

  void _addEducation() {
    if (_educationTitleController.text.isNotEmpty &&
        _educationInstitutionController.text.isNotEmpty) {
      setState(() {
        _educationEntries.add({
          'degree': _educationTitleController.text,
          'institution': _educationInstitutionController.text,
          'period': _educationPeriodController.text,
          'description': _educationDescriptionController.text,
        });

        // Clear controllers for next entry
        _educationTitleController.clear();
        _educationInstitutionController.clear();
        _educationPeriodController.clear();
        _educationDescriptionController.clear();

        _notifyParent();
      });
    }
  }

  void _removeEducation(int index) {
    setState(() {
      _educationEntries.removeAt(index);
      _notifyParent();
    });
  }

  @override
  void dispose() {
    // Education
    _educationTitleController.dispose();
    _educationInstitutionController.dispose();
    _educationPeriodController.dispose();
    _educationDescriptionController.dispose();

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
                icon:
                    const Icon(Icons.add_circle, color: Colors.white, size: 28),
                onPressed: _addEducation,
                tooltip: 'Add education',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of existing education entries
          if (_educationEntries.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _educationEntries.length,
              itemBuilder: (context, index) {
                final edu = _educationEntries[index];
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
                              icon: const Icon(Icons.delete,
                                  color: Colors.white70, size: 20),
                              onPressed: () => _removeEducation(index),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        if (edu['period'] != null &&
                            edu['period'].isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            edu['period'],
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                        if (edu['description'] != null &&
                            edu['description'].isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            edu['description'],
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
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
            controller: _educationTitleController,
            hintText: 'Degree/Certificate',
            prefixIcon: Icons.workspace_premium_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _educationInstitutionController,
            hintText: 'School/University',
            prefixIcon: Icons.school_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _educationPeriodController,
            hintText: 'Period (e.g., Sep 2018 - Jun 2022)',
            prefixIcon: Icons.date_range_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _educationDescriptionController,
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
