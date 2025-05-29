import 'package:craftfolio/profile_wizard.dart';
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
        child: SafeArea(
          child: _profiles.isEmpty
              ? Center(
            child: Text(
              'No profiles yet. Tap + to add.',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          )
              : ListView.builder(
            itemCount: _profiles.length,
            itemBuilder: (context, index) {
              final profile = _profiles[index];
              return Card(
                color: Colors.white.withOpacity(0.95),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1A237E),
                    backgroundImage: profile['profileImageBytes'] != null
                        ? MemoryImage(profile['profileImageBytes'])
                        : null,
                    child: profile['profileImageBytes'] == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    profile['name'] ?? 'Profile',
                    style: const TextStyle(
                      color: Color(0xFF1A237E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    profile['profession'] ?? '',
                    style: const TextStyle(color: Color(0xFF1A237E)),
                  ),
                  onTap: () async {
                    final updatedProfile = await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ProfileWizard(
                        initialData: profile,
                      ),
                    );
                    if (updatedProfile != null) {
                      setState(() {
                        _profiles[index] = updatedProfile;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProfile = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const ProfileWizard(),
          );
          if (newProfile != null) {
            setState(() {
              _profiles.add(newProfile);
            });
          }
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
