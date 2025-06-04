import 'package:flutter/material.dart';
import 'UserInfoSections/index.dart';
import 'services/firebase_service.dart';

class ProfileWizard extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const ProfileWizard({Key? key, this.initialData}) : super(key: key);

  @override
  State<ProfileWizard> createState() => _ProfileWizardState();
}

class _ProfileWizardState extends State<ProfileWizard> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;
  bool _isSaving = false;
  final FirebaseService _firebaseService = FirebaseService();

  // Data storage for all sections
  Map<String, dynamic> _profileData = {
    'fullName': '',
    'currentPosition': '',
    'street': '',
    'address': '',
    'country': '',
    'phoneNumber': '',
    'email': '',
    'bio': '',
    'profileImageBytes': null,
    'experience': <Map<String, dynamic>>[],
    'educationDetails': <Map<String, dynamic>>[],
    'languages': <Map<String, dynamic>>[],
    'hobbies': <String>[],
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _profileData = Map<String, dynamic>.from(widget.initialData!);

      // Ensure all required keys exist in the data
      _profileData['fullName'] ??= '';
      _profileData['currentPosition'] ??= '';
      _profileData['street'] ??= '';
      _profileData['address'] ??= '';
      _profileData['country'] ??= '';
      _profileData['phoneNumber'] ??= '';
      _profileData['email'] ??= '';
      _profileData['bio'] ??= '';
      _profileData['profileImageBytes'] ??= null;
      _profileData['experience'] ??= <Map<String, dynamic>>[];
      _profileData['educationDetails'] ??= <Map<String, dynamic>>[];
      _profileData['languages'] ??= <Map<String, dynamic>>[];
      _profileData['hobbies'] ??= <String>[];
    }
  }

  void _updatePersonalDetails(Map<String, dynamic> data) {
    setState(() {
      _profileData.addAll(data);
    });
  }

  void _updateWorkExperience(List<Map<String, dynamic>> data) {
    setState(() {
      _profileData['experience'] = data;
    });
  }

  void _updateEducation(List<Map<String, dynamic>> data) {
    setState(() {
      _profileData['educationDetails'] = data;
    });
  }

  void _updateSkills(List<Map<String, dynamic>> data) {
    setState(() {
      _profileData['languages'] = data;
    });
  }

  void _updateHobbies(List<String> data) {
    setState(() {
      _profileData['hobbies'] = data;
    });
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _step++;
      });
    }
  }

  void _prevStep() {
    setState(() {
      _step--;
    });
  }

  void _finish() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });
      
      try {
        // Check if we're editing an existing profile or creating a new one
        if (widget.initialData != null && widget.initialData!.containsKey('infoId')) {
          // Update existing profile
          final String infoId = widget.initialData!['infoId'];
          await _firebaseService.updateUserInfo(infoId, _profileData);
        } else {
          // Save new profile
          await _firebaseService.saveUserInfo(_profileData);
        }
        
        // Return to previous screen with updated data
        Navigator.of(context).pop(_profileData);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: ${e.toString()}'))
        );
        
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Build step indicator showing current progress
  Widget _buildStepIndicator() {
    const totalSteps = 5; // Total number of steps
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepLabel(0, 'Personal'),
          const SizedBox(width: 20),
          _buildStepLabel(1, 'Work Experience'),
          const SizedBox(width: 20),
          _buildStepLabel(2, 'Education'),
          const SizedBox(width: 20),
          _buildStepLabel(3, 'Skills'),
          const SizedBox(width: 20),
          _buildStepLabel(4, 'Hobbies'),
        ],
      ),
    );
  }

  Widget _buildStepLabel(int step, String label) {
    return Text(
      label,
      style: TextStyle(
        color: _step == step ? Colors.white : Colors.white.withOpacity(0.7),
        fontWeight: _step == step ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialData != null ? 'Edit Profile' : 'Create Profile',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF303F9F)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Step indicators at the top
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildStepIndicator(),
              ),
              // Main content area (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: _buildCurrentStep(),
                ),
              ),
              // Navigation buttons at the bottom
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_step > 0)
                      ElevatedButton.icon(
                        onPressed: _prevStep,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A237E),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 100),
                    if (_step < 4)
                      ElevatedButton.icon(
                        onPressed: _nextStep,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A237E),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _finish,
                        icon: _isSaving 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A237E),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the current step's content based on _step index
  // Helper method to safely convert dynamic lists to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _safelyConvertToListOfMaps(dynamic data) {
    if (data == null) return [];
    
    try {
      if (data is List) {
        return data.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList();
      }
    } catch (e) {
      print('Error converting list data: $e');
    }
    
    return [];
  }
  
  // Helper method to safely convert dynamic lists to List<String>
  List<String> _safelyConvertToListOfStrings(dynamic data) {
    if (data == null) return [];
    
    try {
      if (data is List) {
        return data.map((item) => item.toString()).toList();
      }
    } catch (e) {
      print('Error converting list data: $e');
    }
    
    return [];
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return PersonalDetailsSection(
          initialData: {
            'fullName': _profileData['fullName'],
            'currentPosition': _profileData['currentPosition'],
            'street': _profileData['street'],
            'address': _profileData['address'],
            'country': _profileData['country'],
            'phoneNumber': _profileData['phoneNumber'],
            'email': _profileData['email'],
            'bio': _profileData['bio'],
            'profileImageBytes': _profileData['profileImageBytes'],
          },
          onDataChanged: _updatePersonalDetails,
        );
      case 1:
        return WorkExperienceSection(
          initialData: _safelyConvertToListOfMaps(_profileData['experience']),
          onDataChanged: _updateWorkExperience,
        );
      case 2:
        return EducationSection(
          initialData: _safelyConvertToListOfMaps(_profileData['educationDetails']),
          onDataChanged: _updateEducation,
        );
      case 3:
        return SkillsSection(
          initialData: _safelyConvertToListOfMaps(_profileData['languages']),
          onDataChanged: _updateSkills,
        );
      case 4:
        return HobbiesSection(
          initialData: _safelyConvertToListOfStrings(_profileData['hobbies']),
          onDataChanged: _updateHobbies,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
