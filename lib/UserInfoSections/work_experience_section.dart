import 'package:craftfolio/custom_text_field.dart';
import 'package:flutter/material.dart';

class WorkExperienceSection extends StatefulWidget {
  final List<Map<String, dynamic>>? initialData;
  final Function(List<Map<String, dynamic>>) onDataChanged;

  const WorkExperienceSection({
    Key? key,
    this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<WorkExperienceSection> createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  // Work history - multiple entries
  List<Map<String, dynamic>> _workExperiences = [];
  final _experienceTitleController = TextEditingController();
  final _experienceLocationController = TextEditingController();
  final _experiencePeriodController = TextEditingController();
  final _experiencePlaceController = TextEditingController();
  final _experienceDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _workExperiences = List<Map<String, dynamic>>.from(widget.initialData!);
    }
  }

  void _notifyParent() {
    widget.onDataChanged(_workExperiences);
  }

  void _addWorkExperience() {
    if (_experienceTitleController.text.isNotEmpty && 
        _experiencePlaceController.text.isNotEmpty) {
      setState(() {
        _workExperiences.add({
          'title': _experienceTitleController.text,
          'company': _experiencePlaceController.text,
          'location': _experienceLocationController.text,
          'period': _experiencePeriodController.text,
          'description': _experienceDescriptionController.text,
        });
        
        // Clear controllers for next entry
        _experienceTitleController.clear();
        _experiencePlaceController.clear();
        _experienceLocationController.clear();
        _experiencePeriodController.clear();
        _experienceDescriptionController.clear();
        
        _notifyParent();
      });
    }
  }

  void _removeWorkExperience(int index) {
    setState(() {
      _workExperiences.removeAt(index);
      _notifyParent();
    });
  }

  @override
  void dispose() {
    // Work experience
    _experienceTitleController.dispose();
    _experienceLocationController.dispose();
    _experiencePeriodController.dispose();
    _experiencePlaceController.dispose();
    _experienceDescriptionController.dispose();
    
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
                'Work Experience',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
                onPressed: _addWorkExperience,
                tooltip: 'Add work experience',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // List of existing work experiences
          if (_workExperiences.isNotEmpty) ...[          
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _workExperiences.length,
              itemBuilder: (context, index) {
                final exp = _workExperiences[index];
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
                                '${exp['title']} at ${exp['company']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white70, size: 20),
                              onPressed: () => _removeWorkExperience(index),
                              tooltip: 'Remove',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        if (exp['location'] != null && exp['location'].isNotEmpty) ...[                        
                          const SizedBox(height: 4),
                          Text(
                            exp['location'],
                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                        if (exp['period'] != null && exp['period'].isNotEmpty) ...[                        
                          const SizedBox(height: 4),
                          Text(
                            exp['period'],
                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                        if (exp['description'] != null && exp['description'].isNotEmpty) ...[                        
                          const SizedBox(height: 8),
                          Text(
                            exp['description'],
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
          
          // Form for adding new work experience
          CustomTextField(
            controller: _experienceTitleController,
            hintText: 'Job Title',
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _experiencePlaceController,
            hintText: 'Company',
            prefixIcon: Icons.business,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _experienceLocationController,
            hintText: 'Location',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _experiencePeriodController,
            hintText: 'Period (e.g., Jan 2020 - Present)',
            prefixIcon: Icons.date_range_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _experienceDescriptionController,
            hintText: 'Description',
            prefixIcon: Icons.description_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Fill in the details and click + to add a work experience',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
