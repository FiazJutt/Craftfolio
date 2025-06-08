import 'package:craftfolio/screens/templates/templatespage.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:craftfolio/models/user_resume_info.dart';
import 'package:craftfolio/core/services/firebase_service.dart';
import 'dart:typed_data';
import 'dart:convert';

class TemplateDetailPage extends StatefulWidget {
  final ResumeTemplateInfo templateInfo;
  final List<UserResumeInfo> userProfiles;

  const TemplateDetailPage({
    Key? key,
    required this.templateInfo,
    required this.userProfiles,
  }) : super(key: key);

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  UserResumeInfo? selectedProfile;
  bool showPreview = false;

  // Static preview info for initial preview
  static final UserResumeInfo staticPreviewInfo = UserResumeInfo(
    fullName: "Alex Carter",
    currentPosition: "Mobile App Developer",
    street: "789 App Street",
    address: "Austin, TX",
    country: "USA",
    phoneNumber: "+1 737 4567890",
    email: "alex.carter@devmail.com",
    bio:
    "Creative and detail-oriented Mobile App Developer with 6+ years of experience in designing, developing, and deploying cross-platform mobile applications using Flutter and native tools. Passionate about performance, clean architecture, and seamless user experiences.",
    profileImageBytes: null,
    workExperiences: [
      WorkExperience(
        title: "Mobile App Developer",
        company: "DigitalWave Inc.",
        location: "Austin, TX",
        period: "2020 - Present",
        description:
        "Developed and maintained multiple Flutter applications for e-commerce and social platforms. Integrated third-party APIs, improved UI/UX, and optimized performance for both Android and iOS platforms.",
      ),
      WorkExperience(
        title: "Junior Mobile Developer",
        company: "AppNest Labs",
        location: "Dallas, TX",
        period: "2017 - 2020",
        description:
        "Worked on several Android native projects and transitioned into Flutter development. Collaborated with designers and backend developers to deliver responsive and scalable mobile solutions.",
      ),
    ],
    educationEntries: [
      EducationEntry(
        degree: "Master of Science in Mobile Computing",
        institution: "University of Texas at Austin",
        period: "2015 - 2017",
        description:
        "Focused on mobile technologies, UI design patterns, and platform-specific performance optimization. Completed a thesis on cross-platform frameworks.",
      ),
      EducationEntry(
        degree: "Bachelor of Science in Computer Science",
        institution: "Texas State University",
        period: "2011 - 2015",
        description:
        "Studied core computer science concepts including algorithms, data structures, and software engineering. Participated in mobile app development club.",
      ),
    ],
    skills: [
      SkillEntry(name: "Flutter", level: 5),
      SkillEntry(name: "Dart", level: 5),
      SkillEntry(name: "Kotlin", level: 4),
      SkillEntry(name: "Swift", level: 3),
      SkillEntry(name: "Firebase", level: 4),
      // SkillEntry(name: "UI/UX Implementation", level: 4),
    ],
    hobbies: [
      "App development",
      "Web development",
      "UI/UX",
      "Cycling",
      "Tech meetups"
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateInfo.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Always show preview, using static info if no profile selected
          const SizedBox(height: 24),
          Expanded(
            child: PdfPreview(
              build: (format) async => widget.templateInfo
                  .buildTemplate(
                selectedProfile ?? staticPreviewInfo,
              )
                  .save(),
              canChangePageFormat: false,
              canChangeOrientation: false,
              allowPrinting: true,
              allowSharing: true,
              canDebug: false,
              pdfFileName:
              // '${widget.templateInfo.name.replaceAll(' ', '_').toLowerCase()}_${(selectedProfile ?? staticPreviewInfo).fullName.replaceAll(' ', '_')}_resume.pdf',
              '${(selectedProfile ?? staticPreviewInfo).fullName.replaceAll(' ', '_')}_resume.pdf',
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0), // adjust values as needed
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.person_search),
          label: Text(selectedProfile == null ? 'Select Info' : 'Edit Info'),
          onPressed: () async {
            await _showProfileSelectionDialog();
          },
        ),
      ),
    );
  }

  // Method to show profile selection dialog (replaces _ProfilePickerSheet)
  Future<void> _showProfileSelectionDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: FirebaseService().getUserInfos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                    child: Text(
                      'Error loading profiles: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              final profilesRaw = snapshot.data ?? [];
              final profiles = profilesRaw.map(_mapToUserResumeInfo).toList();
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A237E).withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Dialog Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A237E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    // Profiles List or Empty State
                    if (profiles.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person_off,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'No profiles found.\nCreate a profile first.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() {
                                    selectedProfile = profile;
                                    showPreview = true;
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Selected profile: ${profile.fullName.isNotEmpty ? profile.fullName : 'Profile'}'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color(0xFF1A237E)
                                            .withOpacity(0.1),
                                        backgroundImage:
                                        profile.profileImageBytes != null
                                            ? MemoryImage(
                                            profile.profileImageBytes!)
                                            : null,
                                        child: profile.profileImageBytes == null
                                            ? const Icon(
                                          Icons.person,
                                          color: Color(0xFF1A237E),
                                          size: 30,
                                        )
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      // Profile Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profile.fullName.isNotEmpty
                                                  ? profile.fullName
                                                  : 'No Name',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF1A237E),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              profile.currentPosition.isNotEmpty
                                                  ? profile.currentPosition
                                                  : 'No Position',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.email,
                                                  size: 12,
                                                  color: Colors.grey[500],
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    profile.email.isNotEmpty
                                                        ? profile.email
                                                        : 'No Email',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[500],
                                                    ),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (profile
                                                .phoneNumber.isNotEmpty) ...[
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    size: 12,
                                                    color: Colors.grey[500],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    profile.phoneNumber,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      // Selection indicator
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF1A237E),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Helper: Convert Map<String, dynamic> from Firebase to UserResumeInfo
  UserResumeInfo _mapToUserResumeInfo(Map<String, dynamic> data) {
    // Use top-level keys for personal info, as returned by getUserInfos
    final work = (data['experience'] as List?) ?? [];
    final education = (data['educationDetails'] as List?) ?? [];
    final skills = (data['languages'] as List?) ?? [];
    final hobbies = (data['hobbies'] as List?)?.cast<String>() ?? [];

    Uint8List? profileImageBytes;
    if (data['profileImageBytes'] != null) {
      profileImageBytes = data['profileImageBytes'];
    } else if (data['profileImageBase64'] != null) {
      try {
        profileImageBytes = base64Decode(data['profileImageBase64']);
      } catch (_) {}
    }

    return UserResumeInfo(
      fullName: data['fullName'] ?? '',
      currentPosition: data['currentPosition'] ?? '',
      street: data['street'] ?? '',
      address: data['address'] ?? '',
      country: data['country'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageBytes: profileImageBytes,
      workExperiences: work
          .map<WorkExperience>((w) => WorkExperience(
        title: w['title'] ?? '',
        company: w['company'] ?? '',
        location: w['location'] ?? '',
        period: w['period'] ?? '',
        description: w['description'] ?? '',
      ))
          .toList(),
      educationEntries: education
          .map<EducationEntry>((edu) => EducationEntry(
        degree: edu['degree'] ?? '',
        institution: edu['institution'] ?? '',
        period: edu['period'] ?? '',
        description: edu['description'] ?? '',
      ))
          .toList(),
      skills: skills
          .map<SkillEntry>((s) => SkillEntry(
        name: s['name'] ?? (s['language'] ?? ''),
        level: (s['level'] is int)
            ? s['level']
            : int.tryParse(s['level']?.toString() ?? '3') ?? 3,
      ))
          .toList(),
      hobbies: hobbies,
    );
  }
}
