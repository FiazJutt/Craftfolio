import 'dart:typed_data';

class UserResumeInfo {
  // Personal
  final String fullName;
  final String currentPosition;
  final String street;
  final String address;
  final String country;
  final String phoneNumber;
  final String email;
  final String bio;
  final Uint8List? profileImageBytes;

  // Work experience
  final List<WorkExperience> workExperiences;

  // Education
  final List<EducationEntry> educationEntries;

  // Skills
  final List<SkillEntry> skills;

  // Hobbies
  final List<String> hobbies;

  UserResumeInfo({
    required this.fullName,
    required this.currentPosition,
    required this.street,
    required this.address,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.bio,
    required this.profileImageBytes,
    required this.workExperiences,
    required this.educationEntries,
    required this.skills,
    required this.hobbies,
  });
}

class WorkExperience {
  final String title;
  final String company;
  final String location;
  final String period;
  final String description;

  WorkExperience({
    required this.title,
    required this.company,
    required this.location,
    required this.period,
    required this.description,
  });
}

class EducationEntry {
  final String degree;
  final String institution;
  final String period;
  final String description;

  EducationEntry({
    required this.degree,
    required this.institution,
    required this.period,
    required this.description,
  });
}

class SkillEntry {
  final String name;
  final int level; // 1-5

  SkillEntry({
    required this.name,
    required this.level,
  });
}
