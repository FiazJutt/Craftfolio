import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:craftfolio/screens/templates/templatespage.dart';
import 'package:craftfolio/models/user_resume_info.dart';
import 'package:printing/printing.dart';

class ResumePreviewPage extends StatelessWidget {
  final ResumeTemplateInfo template;

  const ResumePreviewPage({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample resume data for preview; replace with real user data as needed
    final resumeInfo = UserResumeInfo(
      fullName: "John Doe",
      currentPosition: "Software Engineer",
      street: "123 Main St",
      address: "City, State",
      country: "Country",
      phoneNumber: "123-456-7890",
      email: "john@example.com",
      bio: "Experienced developer...",
      profileImageBytes: null,
      workExperiences: [
        WorkExperience(
          title: "Software Engineer",
          company: "Tech Corp",
          location: "Remote",
          period: "2020-2023",
          description: "Worked on various projects...",
        ),
      ],
      educationEntries: [
        EducationEntry(
          degree: "BSc Computer Science",
          institution: "University X",
          period: "2015-2019",
          description: "Studied computer science.",
        ),
      ],
      skills: [
        SkillEntry(name: "Flutter", level: 5),
        SkillEntry(name: "Dart", level: 5),
        SkillEntry(name: "Firebase", level: 4),
      ],
      hobbies: ["Reading", "Traveling", "Coding"],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(template.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save or export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Resume saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality coming soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async => template.buildTemplate(resumeInfo).save(),
        canChangePageFormat: true,
        canChangeOrientation: true,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName:
            "${template.name.replaceAll(' ', '_').toLowerCase()}_resume.pdf",
      ),
    );
  }
}
