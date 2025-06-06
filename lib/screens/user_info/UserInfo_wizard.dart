import 'package:flutter/material.dart';
import 'sections/index.dart';
import '../../core/services/firebase_service.dart';

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

  // Updated initState method for ProfileWizard
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _profileData = Map<String, dynamic>.from(widget.initialData!);

      // Ensure all required keys exist
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

      // IMPROVED: Handle hobbies with better cleaning
      _profileData['hobbies'] = _cleanHobbiesList(_profileData['hobbies']);
    }

    print('ProfileWizard initialized with hobbies: ${_profileData['hobbies']}');
    print('Hobbies data type: ${_profileData['hobbies'].runtimeType}');
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

  // Enhanced _cleanHobbiesList method for ProfileWizard
  List<String> _cleanHobbiesList(dynamic hobbiesData) {
    print(
        '_cleanHobbiesList called with: $hobbiesData (type: ${hobbiesData.runtimeType})');

    if (hobbiesData == null) {
      print('Hobbies data is null, returning empty list');
      return <String>[];
    }

    try {
      if (hobbiesData is List<String>) {
        final cleaned =
            hobbiesData.where((hobby) => hobby.trim().isNotEmpty).toList();
        print('Cleaned List<String>: $cleaned');
        return cleaned;
      } else if (hobbiesData is List) {
        final converted = hobbiesData
            .map((item) {
              if (item == null) return '';
              return item.toString().trim();
            })
            .where((hobby) => hobby.isNotEmpty)
            .toList();
        print('Converted List to List<String>: $converted');
        return converted;
      } else if (hobbiesData is String && hobbiesData.trim().isNotEmpty) {
        print('Converting single string to list: [${hobbiesData.trim()}]');
        return [hobbiesData.trim()];
      } else {
        print('Unexpected hobbies data type: ${hobbiesData.runtimeType}');
        print('Data content: $hobbiesData');
      }
    } catch (e) {
      print('Error cleaning hobbies data: $e');
    }

    print('Returning empty list as fallback');
    return <String>[];
  }

// Also, make sure your Firebase data structure is correct
// Check your Firebase Console to verify the hobbies are saved as:
// UsersData/userInfos/[userId]/[infoId]/hobbies: ["hobby1", "hobby2"]
// NOT as: hobbies: [{"name": "hobby1"}, {"name": "hobby2"}]

  // Updated _updateHobbies method
  void _updateHobbies(List<String> data) {
    final cleanedData = data.where((hobby) => hobby.trim().isNotEmpty).toList();
    print('ProfileWizard updating hobbies with: $cleanedData');
    setState(() {
      _profileData['hobbies'] = cleanedData;
      print('ProfileWizard updated hobbies: ${_profileData['hobbies']}');
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

  // Updated _finish method with better error handling
  void _finish() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      // Clean the profile data before saving
      final cleanedProfileData = Map<String, dynamic>.from(_profileData);

      // Ensure hobbies are cleaned
      cleanedProfileData['hobbies'] =
          _cleanHobbiesList(cleanedProfileData['hobbies']);

      print(
          'Saving cleaned profile data - hobbies: ${cleanedProfileData['hobbies']}');
      _profileData['hobbies'] = _cleanHobbiesList(_profileData['hobbies']);

      try {
        if (widget.initialData != null &&
            widget.initialData!.containsKey('infoId')) {
          // Update existing profile
          final String infoId = widget.initialData!['infoId'];
          await _firebaseService.updateUserInfo(infoId, cleanedProfileData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Save new profile
          await _firebaseService.saveUserInfo(cleanedProfileData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Return to previous screen with updated data
        Navigator.of(context).pop(cleanedProfileData);
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Build step indicator showing current progress
  Widget _buildStepIndicator() {
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
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF1A237E)),
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A237E),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
          initialData:
              _safelyConvertToListOfMaps(_profileData['educationDetails']),
          onDataChanged: _updateEducation,
        );
      case 3:
        return SkillsSection(
          initialData: _safelyConvertToListOfMaps(_profileData['languages']),
          onDataChanged: _updateSkills,
        );

      // Updated _buildCurrentStep method case 4
      case 4:
        print('Building hobbies section with data: ${_profileData['hobbies']}');
        final hobbiesData = _cleanHobbiesList(_profileData['hobbies']);
        return HobbiesSection(
          initialData: hobbiesData,
          onDataChanged: _updateHobbies,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
