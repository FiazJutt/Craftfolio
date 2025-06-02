import 'package:craftfolio/resume_preview_page.dart';
import 'package:craftfolio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resume_template/flutter_resume_template.dart';

// Class to store resume template information
class ResumeTemplateInfo {
  final int id;
  final String name;
  final String description;
  final Color themeColor;
  final TemplateTheme templateTheme;

  ResumeTemplateInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.themeColor,
    required this.templateTheme,
  });
}

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  // List of resume templates available in the flutter_resume_template package
  final List<ResumeTemplateInfo> resumeTemplates = [
    ResumeTemplateInfo(
      id: 1,
      name: 'Modern Resume',
      description: 'Clean and contemporary design with a modern look',
      themeColor: Colors.blue,
      templateTheme: TemplateTheme.modern,
    ),
    ResumeTemplateInfo(
      id: 2,
      name: 'Classic Resume',
      description: 'Traditional and elegant layout for professional use',
      themeColor: Colors.green,
      templateTheme: TemplateTheme.classic,
    ),
    ResumeTemplateInfo(
      id: 3,
      name: 'Business Resume',
      description: 'Formal design for corporate and business environments',
      themeColor: Colors.orange,
      templateTheme: TemplateTheme.business,
    ),
    ResumeTemplateInfo(
      id: 4,
      name: 'Technical Resume',
      description: 'Specialized layout for technical and IT professionals',
      themeColor: Colors.purple,
      templateTheme: TemplateTheme.technical,
    ),
  ];

  // Function to handle template selection and navigate to preview page
  void openResumePreview(ResumeTemplateInfo selectedTemplate) {
    // Navigate to the resume preview page with the selected template
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumePreviewPage(template: selectedTemplate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       const Color(0xFF1A237E).withOpacity(0.9),
        //       const Color(0xFF0D47A1),
        //       const Color(0xFF1565C0).withOpacity(0.8),
        //     ],
        //   ),
        // ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header with user's name
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${AuthService().userInfo?.displayName ?? 'User'}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose a template to create your professional resume',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section title
                const Text(
                  'Resume Templates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // Templates Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: resumeTemplates.length,
                    itemBuilder: (context, index) {
                      final template = resumeTemplates[index];
                      return GestureDetector(
                        onTap: () => openResumePreview(template),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Template Preview
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: template.themeColor.withOpacity(0.1),
                                  ),
                                  // Removed ClipRRect and directly added the preview widget
                                  child: buildTemplatePreview(template),
                                ),
                              ),
                              // Template Name
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        template.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a preview of the template
  Widget buildTemplatePreview(ResumeTemplateInfo template) {
    // Create a simplified preview of the resume template with border radius applied directly
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge, // This provides the clipping without ClipRRect
      child: Row(
        children: [
          // Left sidebar preview (typical in most resume templates)
          Container(
            width: 80,
            color: template.themeColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.person, size: 24),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 40,
                  color: Colors.white70,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 4,
                  width: 30,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          // Right content preview
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: 100,
                    color: template.themeColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 140,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: template.themeColor,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 4,
                        width: 80,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: template.themeColor,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 4,
                        width: 60,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}