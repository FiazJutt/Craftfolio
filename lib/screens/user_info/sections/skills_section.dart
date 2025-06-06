import 'package:craftfolio/core/custom_text_field.dart';
import 'package:flutter/material.dart';

class SkillsSection extends StatefulWidget {
  final List<Map<String, dynamic>>? initialData;
  final Function(List<Map<String, dynamic>>) onDataChanged;

  const SkillsSection({
    Key? key,
    this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  // Skills (languages with proficiency)
  List<Map<String, dynamic>> _skills = [];
  final _skillNameController = TextEditingController();
  final _skillLevelController = TextEditingController(text: '3');
  int _skillLevel = 3; // Default skill level (1-5)

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _skills = List<Map<String, dynamic>>.from(widget.initialData!);
    }
  }

  void _notifyParent() {
    widget.onDataChanged(_skills);
  }

  void _addSkill() {
    if (_skillNameController.text.isNotEmpty) {
      setState(() {
        _skills.add({
          'name': _skillNameController.text,
          'level': _skillLevel,
        });
        _skillNameController.clear();
        _skillLevel = 3;
        _skillLevelController.text = '3';

        _notifyParent();
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
      _notifyParent();
    });
  }

  @override
  void dispose() {
    // Skills
    _skillNameController.dispose();
    _skillLevelController.dispose();

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
                'Skills',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.add_circle, color: Colors.white, size: 28),
                onPressed: _addSkill,
                tooltip: 'Add skill',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Display existing skills
          if (_skills.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _skills.length,
              itemBuilder: (context, index) {
                final skill = _skills[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skill['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: skill['level'] / 5,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level: ${skill['level']}/5',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70),
                        onPressed: () => _removeSkill(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // Add new skill
          CustomTextField(
            controller: _skillNameController,
            hintText: 'Skill Name (e.g. Flutter, JavaScript)',
            prefixIcon: Icons.code,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _skillLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_skillLevel',
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.3),
                  onChanged: (value) {
                    setState(() {
                      _skillLevel = value.toInt();
                      _skillLevelController.text = _skillLevel.toString();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_skillLevel/5',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter skill name and set proficiency level, then click + to add',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
