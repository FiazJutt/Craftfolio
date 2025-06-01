import 'package:flutter/material.dart';
import 'package:flutter_resume_template/flutter_resume_template.dart';
import 'package:craftfolio/templatespage.dart';

class ResumePreviewPage extends StatelessWidget {
  final ResumeTemplateInfo template;

  const ResumePreviewPage({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample resume data - in a real app, you would get this from user input
    final sampleBio = '''
Experienced software developer with a passion for creating efficient and elegant solutions. 
Proficient in multiple programming languages and frameworks with a focus on mobile development.
''';

    final workExperienceDescription = '''
Responsibilities:
  - Developed and maintained mobile applications using Flutter and Dart
  - Collaborated with the design team to implement UI/UX designs
  - Integrated RESTful APIs and Firebase services
  - Conducted code reviews and mentored junior developers

Technologies Used:
  - Flutter, Dart, Firebase
  - RESTful APIs, GraphQL
  - Git, JIRA
  - CI/CD pipelines 
''';

    final templateData = TemplateData(
      fullName: 'John Doe May',
      currentPosition: 'Mobile Developer',
      street: '123 Main St',
      address: 'New York, 10001',
      country: 'USA',
      email: 'john.doe@example.com',
      phoneNumber: '+1 (123) 456-7890',
      bio: sampleBio,
      experience: [
        ExperienceData(
          experienceTitle: 'Senior Flutter Developer',
          experienceLocation: 'Tech Solutions Inc.',
          experiencePeriod: 'Jan 2020 - Present',
          experiencePlace: 'New York',
          experienceDescription: workExperienceDescription,
        ),
        ExperienceData(
          experienceTitle: 'Junior Developer',
          experienceLocation: 'Digital Innovations',
          experiencePeriod: 'Mar 2018 - Dec 2019',
          experiencePlace: 'Boston',
          experienceDescription:
          'Worked on mobile applications and assisted in backend development.',
        ),
      ],
      educationDetails: [
        Education('Bachelor of Science in Computer Science',
            'University of Technology'),
        Education('Mobile Development Certification', 'Tech Academy'),
      ],
      languages: [
        Language('Flutter', 5),
        Language('Dart', 5),
        Language('Firebase', 4),
        Language('JavaScript', 3),
        Language('React Native', 3),
      ],
      hobbies: [
        'Open Source Contributing',
        'Tech Blogging',
        'Hiking',
        'Photography'
      ],
      image:
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
      backgroundImage: '',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterResumeTemplate(
            data: templateData,
            templateTheme: template.templateTheme,
            mode: TemplateMode.readOnlyMode,
            showButtons: true,
            imageHeight: 100,
            imageWidth: 100,
            emailPlaceHolder: 'Email:',
            telPlaceHolder: 'Phone:',
            experiencePlaceHolder: 'Experience',
            educationPlaceHolder: 'Education',
            languagePlaceHolder: 'Skills',
            aboutMePlaceholder: 'About Me',
            hobbiesPlaceholder: 'Interests',
            enableDivider: true,
          ),
        ),
      ),
    );
  }
}
