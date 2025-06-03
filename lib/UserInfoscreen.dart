import 'package:craftfolio/UserInfo_wizard.dart';
import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  Future<void> _loadProfiles() async {
    try {
      final profiles = await _firebaseService.getAllProfiles();
      if (mounted) {
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profiles: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadProfiles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Method to add a new profile
  Future<void> _addNewProfile() async {
    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ProfileWizard()),
    );

    // Profile is saved automatically, just reload the list
    await _loadProfiles();
  }

  // Method to edit an existing profile
  Future<void> _editProfile(Map<String, dynamic> profile, int index, {int initialStep = 0}) async {
    // Create a deep copy of the profile data
    final profileCopy = Map<String, dynamic>.from(profile);
    
    // Deep copy arrays
    if (profile['experience'] != null) {
      profileCopy['experience'] = (profile['experience'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (profile['educationDetails'] != null) {
      profileCopy['educationDetails'] = (profile['educationDetails'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (profile['languages'] != null) {
      profileCopy['languages'] = (profile['languages'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (profile['hobbies'] != null) {
      profileCopy['hobbies'] = List<String>.from(profile['hobbies'] as List);
    }

    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileWizard(
          initialData: profileCopy,
          initialStep: initialStep,
        ),
      ),
    );

    // Profile is saved automatically, just reload the list
    await _loadProfiles();
  }

  // Method to delete a profile
  Future<void> _deleteProfile(String profileId) async {
    try {
      await _firebaseService.deleteProfile(profileId);
      await _loadProfiles(); // Reload profiles from Firebase
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile deleted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting profile: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A237E).withOpacity(0.9),
              const Color(0xFF0D47A1),
              const Color(0xFF1565C0).withOpacity(0.8),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _profiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No profiles yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the button below to create your first profile',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: _profiles.length,
                      itemBuilder: (context, index) {
                        final profile = _profiles[index];
                        print('Rendering profile ${index}: Image type: ${profile['profileImageBytes']?.runtimeType}, has image: ${profile['profileImageBytes'] != null}');
                        return Card(
                          color: Colors.white.withOpacity(0.95),
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: InkWell(
                            onTap: () => _editProfile(profile, index),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Profile Image
                                  Builder(builder: (context) {
                                    Widget imageWidget;
                                    try {
                                      if (profile['profileImageBytes'] != null) {
                                        print('Profile ${profile['fullName']}: Image type: ${profile['profileImageBytes'].runtimeType}');
                                        if (profile['profileImageBytes'] is Uint8List) {
                                          final bytes = profile['profileImageBytes'] as Uint8List;
                                          print('Displaying image with byte length: ${bytes.length}');
                                          if (bytes.isNotEmpty) {
                                            imageWidget = CircleAvatar(
                                              radius: 35,
                                              backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                                              backgroundImage: MemoryImage(bytes),
                                              onBackgroundImageError: (exception, stackTrace) {
                                                print('Error loading image: $exception');
                                              },
                                            );
                                            return imageWidget;
                                          }
                                        } else if (profile['profileImageBytes'] is String) {
                                          // Try to decode string if it's a base64 string that wasn't properly decoded
                                          try {
                                            final bytes = base64Decode(profile['profileImageBytes'] as String);
                                            print('Manually decoded base64 string to ${bytes.length} bytes');
                                            imageWidget = CircleAvatar(
                                              radius: 35,
                                              backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                                              backgroundImage: MemoryImage(bytes),
                                              onBackgroundImageError: (exception, stackTrace) {
                                                print('Error loading manually decoded image: $exception');
                                              },
                                            );
                                            return imageWidget;
                                          } catch (e) {
                                            print('Failed to manually decode base64 string: $e');
                                          }
                                        }
                                        throw Exception('Invalid or empty profile image data');
                                      } else {
                                        throw Exception('No profile image data');
                                      }
                                    } catch (e) {
                                      print('Error displaying profile image: $e');
                                      imageWidget = CircleAvatar(
                                        radius: 35,
                                        backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                                        child: const Icon(
                                          Icons.person,
                                          color: Color(0xFF1A237E),
                                          size: 40,
                                        ),
                                      );
                                    }
                                    return imageWidget;
                                  }),
                                  const SizedBox(width: 16),
                                  // Profile Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          profile['fullName'] ?? 'Profile',
                                          style: const TextStyle(
                                            color: Color(0xFF1A237E),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          profile['currentPosition'] ?? 'No profession added',
                                          style: TextStyle(
                                            color: const Color(0xFF1A237E).withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                profile['email'] ?? 'No email added',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Edit and Delete buttons
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Color(0xFF1A237E),
                                        ),
                                        onPressed: () => _editProfile(profile, index, initialStep: 0),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteProfile(profile['id']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProfile,
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Profile', style: TextStyle(color: Colors.white)),
        elevation: 4,
      ),
    );
  }
}
