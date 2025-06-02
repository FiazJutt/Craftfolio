import 'package:craftfolio/UserInfo_wizard.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize profiles from constructor parameter or empty list
    _profiles = widget.initialProfiles ?? [];
  }

  // Method to add a new profile
  void _addNewProfile() async {
    // Navigate to the ProfileWizard page instead of showing a modal
    final newProfile = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ProfileWizard()),
    );

    if (newProfile != null) {
      setState(() {
        _profiles.add(newProfile);
      });
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
      setState(() {
        _profiles[index] = updatedProfile;
      });
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
        child: _profiles.isEmpty
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
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
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
              return Card(
                color: Colors.white.withOpacity(0.95),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _editProfile(profile, index),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Profile Image - Option 1: Using CircleAvatar
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                          backgroundImage: profile['profileImageBytes'] != null
                              ? MemoryImage(profile['profileImageBytes'])
                              : null,
                          child: profile['profileImageBytes'] == null
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['name'] ?? 'Profile',
                                style: const TextStyle(
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile['profession'] ?? 'No profession added',
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
                                  Text(
                                    profile['email'] ?? 'No email added',
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
                        // Edit button
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF1A237E),
                          ),
                          onPressed: () => _editProfile(profile, index),
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