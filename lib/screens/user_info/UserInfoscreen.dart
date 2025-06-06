import 'package:craftfolio/screens/user_info/userinfo_wizard.dart';
import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  // Add constructor parameters if needed
  final List<Map<String, dynamic>>? initialProfiles;

  const ProfilePage({
    Key? key,
    this.initialProfiles,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    // Initialize profiles from constructor parameter or load from Firebase
    if (widget.initialProfiles != null) {
      _profiles = widget.initialProfiles!;
      _isLoading = false;
    } else {
      _loadProfiles();
    }
  }

  // Load profiles from Firebase
  Future<void> _loadProfiles() async {
    try {
      final profiles = await _firebaseService.getUserInfos();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profiles: ${e.toString()}')));
    }
  }

  // Method to add a new profile
  void _addNewProfile() async {
    // Navigate to the ProfileWizard page
    final newProfile = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ProfileWizard()),
    );

    if (newProfile != null) {
      // Refresh the profiles list from Firebase
      _loadProfiles();
    }
  }

  // Method to edit an existing profile
  void _editProfile(Map<String, dynamic> profile, int index) async {
    // Navigate to the ProfileWizard page with initial data
    final updatedProfile = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileWizard(initialData: profile),
      ),
    );

    if (updatedProfile != null) {
      // Refresh the profiles list from Firebase
      _loadProfiles();
    }
  }

  // Method to delete a profile
  Future<void> _deleteProfile(String infoId, int index) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete this profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firebaseService.deleteUserInfo(infoId);
        _loadProfiles(); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting profile: ${e.toString()}')));
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
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _profiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_alt_1,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No profiles yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to create your first profile',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadProfiles,
                    color: const Color(0xFF1A237E),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: _profiles.length,
                        itemBuilder: (context, index) {
                          final profile = _profiles[index];
                          return Card(
                            color: Colors.white.withOpacity(0.95),
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _editProfile(profile, index),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Profile Image
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: const Color(0xFF1A237E)
                                          .withOpacity(0.1),
                                      backgroundImage:
                                          profile['profileImageBytes'] != null
                                              ? MemoryImage(
                                                  profile['profileImageBytes'])
                                              : null,
                                      child:
                                          profile['profileImageBytes'] == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Color(0xFF1A237E),
                                                  size: 40,
                                                )
                                              : null,
                                    ),
                                    const SizedBox(width: 16),
                                    // Profile Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            profile['currentPosition'] ??
                                                'No profession added',
                                            style: TextStyle(
                                              color: const Color(0xFF1A237E)
                                                  .withOpacity(0.7),
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
                                              Text(
                                                profile['email'] ??
                                                    'No email added',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Action buttons
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Edit button
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF1A237E),
                                          ),
                                          onPressed: () =>
                                              _editProfile(profile, index),
                                        ),
                                        // Delete button
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteProfile(
                                              profile['infoId'], index),
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
