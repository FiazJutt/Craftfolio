import 'package:craftfolio/screens/templates/template_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:craftfolio/screens/templates/resume_templates.dart';
import 'package:craftfolio/models/user_resume_info.dart';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Class to store resume template information
class ResumeTemplateInfo {
  final int id;
  final String name;
  final String description;
  final Color themeColor;
  final String imageAsset;
  final pw.Document Function(UserResumeInfo) buildTemplate;

  ResumeTemplateInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.themeColor,
    required this.imageAsset,
    required this.buildTemplate,
  });
}

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  // List of resume templates available in the new PDF-based implementation
  final List<ResumeTemplateInfo> resumeTemplates = [
    ResumeTemplateInfo(
      id: 1,
      name: 'Classic Resume',
      description: 'Traditional and elegant layout for professional use',
      themeColor: Colors.green,
      imageAsset: 'assets/templates/classic.png',
      buildTemplate: buildClassicResume,
    ),
    ResumeTemplateInfo(
      id: 2,
      name: 'Modern Sidebar',
      description: 'Modern resume with sidebar for skills and info',
      themeColor: Colors.blue,
      imageAsset: 'assets/templates/modern_sidebar.png',
      buildTemplate: buildModernSidebarResume,
    ),
    ResumeTemplateInfo(
      id: 3,
      name: 'Minimalist Resume',
      description: 'Simple and clean minimalist layout',
      themeColor: Colors.orange,
      imageAsset: 'assets/templates/minimalist.png',
      buildTemplate: buildMinimalistResume,
    ),
    ResumeTemplateInfo(
      id: 4,
      name: 'Creative Header',
      description: 'Creative resume with a bold header',
      themeColor: Colors.purple,
      imageAsset: 'assets/templates/creative_header.png',
      buildTemplate: buildCreativeHeaderResume,
    ),
    ResumeTemplateInfo(
      id: 5,
      name: 'Compact Resume',
      description: 'Compact, two-column layout for concise resumes',
      themeColor: Colors.teal,
      imageAsset: 'assets/templates/compact.png',
      buildTemplate: buildCompactResume,
    ),
    ResumeTemplateInfo(
      id: 6,
      name: 'Elegant Resume',
      description: 'Elegant, professional, and modern one-page CV',
      themeColor: Colors.indigo,
      imageAsset: 'assets/templates/elegant.png',
      buildTemplate: buildElegantResume,
    ),
  ];

  // Load user profiles from Firebase and convert to UserResumeInfo list
  List<UserResumeInfo> _userProfiles = [];

  @override
  void initState() {
    super.initState();
    // No eager profile loading here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                const Text(
                  'Resume Templates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                // Templates Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: resumeTemplates.length,
                    itemBuilder: (context, index) {
                      final template = resumeTemplates[index];
                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TemplateDetailPage(
                                templateInfo: template,
                                userProfiles: _userProfiles,
                              ),
                            ),
                          );
                        },
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
                                flex: 5,
                                child: Container(
                                  margin: const EdgeInsets.all(4),
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
                                // flex: 1,
                                // child: Padding(
                                // padding: const EdgeInsets.all(6.0),
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                // ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        template.imageAsset,
        fit: BoxFit.fill,
        width: double.infinity,
        height: 140, // or another appropriate height
        errorBuilder: (context, error, stackTrace) => Container(
          color: template.themeColor.withOpacity(0.1),
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported,
              size: 40, color: Colors.grey),
        ),
      ),
    );
  }
}
