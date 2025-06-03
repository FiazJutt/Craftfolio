import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'UserInfoSections/index.dart';
import 'services/firebase_service.dart';

class ProfileWizard extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final int initialStep;

  const ProfileWizard({Key? key, this.initialData, this.initialStep = 0})
      : super(key: key);

  @override
  State<ProfileWizard> createState() => _ProfileWizardState();
}

class _ProfileWizardState extends State<ProfileWizard> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;
  final FirebaseService _firebaseService = FirebaseService();

  // Text controllers for personal details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

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
    _step = widget.initialStep;
    if (widget.initialData != null) {
      _profileData = {};

      // Copy personal details
      _profileData['fullName'] = widget.initialData!['fullName'] ?? '';
      _profileData['currentPosition'] =
          widget.initialData!['currentPosition'] ?? '';
      _profileData['street'] = widget.initialData!['street'] ?? '';
      _profileData['address'] = widget.initialData!['address'] ?? '';
      _profileData['country'] = widget.initialData!['country'] ?? '';
      _profileData['phoneNumber'] = widget.initialData!['phoneNumber'] ?? '';
      _profileData['email'] = widget.initialData!['email'] ?? '';
      _profileData['bio'] = widget.initialData!['bio'] ?? '';
      _profileData['profileImageBytes'] =
          widget.initialData!['profileImageBytes'];
      _profileData['id'] = widget.initialData!['id'];

      // Initialize text controllers with existing data
      _nameController.text = _profileData['fullName'];
      _positionController.text = _profileData['currentPosition'];
      _streetController.text = _profileData['street'];
      _addressController.text = _profileData['address'];
      _countryController.text = _profileData['country'];
      _phoneController.text = _profileData['phoneNumber'];
      _emailController.text = _profileData['email'];
      _bioController.text = _profileData['bio'];

      // Copy and ensure proper typing for arrays
      try {
        _profileData['experience'] = widget.initialData!['experience'] != null
            ? (widget.initialData!['experience'] as List)
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : <Map<String, dynamic>>[];

        _profileData['educationDetails'] =
            widget.initialData!['educationDetails'] != null
                ? (widget.initialData!['educationDetails'] as List)
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList()
                : <Map<String, dynamic>>[];

        _profileData['languages'] = widget.initialData!['languages'] != null
            ? (widget.initialData!['languages'] as List)
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : <Map<String, dynamic>>[];

        _profileData['hobbies'] = widget.initialData!['hobbies'] != null
            ? List<String>.from(widget.initialData!['hobbies'] as List)
            : <String>[];
      } catch (e) {
        print('Error copying arrays: $e');
        // Initialize with empty arrays if there's an error
        _profileData['experience'] = <Map<String, dynamic>>[];
        _profileData['educationDetails'] = <Map<String, dynamic>>[];
        _profileData['languages'] = <Map<String, dynamic>>[];
        _profileData['hobbies'] = <String>[];
      }
    }
  }

  Future<void> _updatePersonalDetails(Map<String, dynamic> data) async {
    print('Updating personal details with data: ${data.keys}');
    
    // Handle image data specifically
    if (data['profileImageBytes'] != null) {
      final imageData = data['profileImageBytes'];
      print('Image data received, type: ${imageData.runtimeType}, size: ${imageData is Uint8List ? imageData.length : 'unknown'} bytes');
      
      // Update only if we have valid image data
      setState(() {
        _profileData['profileImageBytes'] = imageData;
      });
    }
    
    // Update other personal details
    setState(() {
      _profileData.addAll({
        'fullName': data['fullName'],
        'currentPosition': data['currentPosition'],
        'street': data['street'],
        'address': data['address'],
        'country': data['country'],
        'phoneNumber': data['phoneNumber'],
        'email': data['email'],
        'bio': data['bio'],
      });
      _formKey.currentState?.save();
    });

    // Save to Firebase immediately when personal details change
    try {
      print('Saving personal details to Firebase...');
      print('Profile data keys before save: ${_profileData.keys}');
      print('Has image: ${_profileData['profileImageBytes'] != null}');
      
      if (_profileData['id'] != null) {
        await _firebaseService.updateProfileData(_profileData['id'], _profileData);
      } else {
        await _firebaseService.saveProfileData(_profileData);
      }
      print('Personal details saved successfully');
    } catch (e) {
      print('Error saving personal details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes: ${e.toString()}'))
        );
      }
    }
  }

  Future<void> _updateWorkExperience(List<Map<String, dynamic>> data) async {
    setState(() {
      _profileData['experience'] = List<Map<String, dynamic>>.from(data);
      _formKey.currentState?.save();
    });

    // Silently save to Firebase
    try {
      if (_profileData['id'] != null) {
        await _firebaseService.updateProfileData(
            _profileData['id'], _profileData);
      } else {
        await _firebaseService.saveProfileData(_profileData);
      }
    } catch (e) {
      // Only show error messages
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving progress: ${e.toString()}')));
      }
    }
  }

  Future<void> _updateEducation(List<Map<String, dynamic>> data) async {
    setState(() {
      _profileData['educationDetails'] = List<Map<String, dynamic>>.from(data);
      _formKey.currentState?.save();
    });

    // Silently save to Firebase
    try {
      if (_profileData['id'] != null) {
        await _firebaseService.updateProfileData(
            _profileData['id'], _profileData);
      } else {
        await _firebaseService.saveProfileData(_profileData);
      }
    } catch (e) {
      // Only show error messages
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving progress: ${e.toString()}')));
      }
    }
  }

  Future<void> _updateSkills(List<Map<String, dynamic>> data) async {
    setState(() {
      _profileData['languages'] = List<Map<String, dynamic>>.from(data);
      _formKey.currentState?.save();
    });

    // Silently save to Firebase
    try {
      if (_profileData['id'] != null) {
        await _firebaseService.updateProfileData(
            _profileData['id'], _profileData);
      } else {
        await _firebaseService.saveProfileData(_profileData);
      }
    } catch (e) {
      // Only show error messages
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving progress: ${e.toString()}')));
      }
    }
  }

  Future<void> _updateHobbies(List<String> data) async {
    setState(() {
      _profileData['hobbies'] = List<String>.from(data);
      _formKey.currentState?.save();
    });

    // Silently save to Firebase
    try {
      if (_profileData['id'] != null) {
        await _firebaseService.updateProfileData(
            _profileData['id'], _profileData);
      } else {
        await _firebaseService.saveProfileData(_profileData);
      }
    } catch (e) {
      // Only show error messages
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving progress: ${e.toString()}')));
      }
    }
  }

  Future<void> _nextStep() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print('Moving to next step. Profile data keys: ${_profileData.keys}');
        print('Has image: ${_profileData['profileImageBytes'] != null}');
        
        // Silently save progress
        if (_profileData['id'] != null) {
          await _firebaseService.updateProfileData(
              _profileData['id'], _profileData);
        } else {
          // This is a new profile
          await _firebaseService.saveProfileData(_profileData);
        }

        setState(() {
          _step++;
        });
      } catch (e) {
        print('Error in _nextStep: $e');
        // Only show error messages
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error saving progress: ${e.toString()}')));
        }
      }
    }
  }

  void _prevStep() {
    setState(() {
      _step--;
    });
  }

  Future<void> _finish() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print('Finishing profile. Profile data keys: ${_profileData.keys}');
        print('Has image: ${_profileData['profileImageBytes'] != null}');
        
        // Final save before finishing
        if (_profileData['id'] != null) {
          await _firebaseService.updateProfileData(
              _profileData['id'], _profileData);
        } else {
          await _firebaseService.saveProfileData(_profileData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')));
        }

        // Return a copy of the data to prevent modifications
        Navigator.of(context).pop(Map<String, dynamic>.from(_profileData));
      } catch (e) {
        print('Error in _finish: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving profile: ${e.toString()}')));
        }
      }
    }
  }

  // Build step indicator showing current progress
  Widget _buildStepIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStepLabel(0, 'Personal'),
            const SizedBox(width: 16),
            _buildStepLabel(1, 'Work'),
            const SizedBox(width: 16),
            _buildStepLabel(2, 'Education'),
            const SizedBox(width: 16),
            _buildStepLabel(3, 'Skills'),
            const SizedBox(width: 16),
            _buildStepLabel(4, 'Hobbies'),
          ],
        ),
      ),
    );
  }

  Widget _buildStepLabel(int step, String label) {
    final isCurrentStep = _step == step;
    return InkWell(
      onTap: () {
        setState(() {
          _step = step;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentStep
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrentStep ? Colors.white : Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isCurrentStep ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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
                        onPressed: _finish,
                        icon: const Icon(Icons.check),
                        label: const Text('Save Profile'),
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

  // Build the current step's content based on _step index
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
          onDataChanged: (data) {
            setState(() {
              _profileData['fullName'] = data['fullName'];
              _profileData['currentPosition'] = data['currentPosition'];
              _profileData['street'] = data['street'];
              _profileData['address'] = data['address'];
              _profileData['country'] = data['country'];
              _profileData['phoneNumber'] = data['phoneNumber'];
              _profileData['email'] = data['email'];
              _profileData['bio'] = data['bio'];
              _formKey.currentState?.save();
            });

            // Silently save to Firebase
            try {
              if (_profileData['id'] != null) {
                _firebaseService.updateProfileData(
                    _profileData['id'], _profileData);
              } else {
                _firebaseService.saveProfileData(_profileData);
              }
            } catch (e) {
              // Only show error messages
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error saving progress: ${e.toString()}')));
              }
            }
          },
        );
      case 1:
        return WorkExperienceSection(
          initialData: _profileData['experience'] != null
              ? List<Map<String, dynamic>>.from(_profileData['experience'])
              : [],
          onDataChanged: _updateWorkExperience,
        );
      case 2:
        return EducationSection(
          initialData: _profileData['educationDetails'] != null
              ? List<Map<String, dynamic>>.from(
                  _profileData['educationDetails'])
              : [],
          onDataChanged: _updateEducation,
        );
      case 3:
        return SkillsSection(
          initialData: _profileData['languages'] != null
              ? List<Map<String, dynamic>>.from(_profileData['languages'])
              : [],
          onDataChanged: _updateSkills,
        );
      case 4:
        return HobbiesSection(
          initialData: _profileData['hobbies'] != null
              ? List<String>.from(_profileData['hobbies'])
              : [],
          onDataChanged: _updateHobbies,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
