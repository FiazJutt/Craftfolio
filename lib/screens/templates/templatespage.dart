import 'package:craftfolio/core/services/auth_service.dart';
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
  final pw.Document Function(UserResumeInfo) buildTemplate;

  ResumeTemplateInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.themeColor,
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
      buildTemplate: buildClassicResume,
    ),
    ResumeTemplateInfo(
      id: 2,
      name: 'Modern Sidebar',
      description: 'Modern resume with sidebar for skills and info',
      themeColor: Colors.blue,
      buildTemplate: buildModernSidebarResume,
    ),
    ResumeTemplateInfo(
      id: 3,
      name: 'Minimalist Resume',
      description: 'Simple and clean minimalist layout',
      themeColor: Colors.orange,
      buildTemplate: buildMinimalistResume,
    ),
    ResumeTemplateInfo(
      id: 4,
      name: 'Creative Header',
      description: 'Creative resume with a bold header',
      themeColor: Colors.purple,
      buildTemplate: buildCreativeHeaderResume,
    ),
    ResumeTemplateInfo(
      id: 5,
      name: 'Compact Resume',
      description: 'Compact, two-column layout for concise resumes',
      themeColor: Colors.teal,
      buildTemplate: buildCompactResume,
    ),
    ResumeTemplateInfo(
      id: 6,
      name: 'Elegant Resume',
      description: 'Elegant, professional, and modern one-page CV',
      themeColor: Colors.indigo,
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
                // Welcome header with user's name
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [Colors.blue.shade600, Colors.blue.shade800],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.blue.withOpacity(0.3),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Hello, ${AuthService().userInfo?.displayName ?? 'User'}!',
                //         style: const TextStyle(
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       const Text(
                //         'Choose a template to create your professional resume',
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 24),

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
                      childAspectRatio: 0.8,
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
      clipBehavior:
          Clip.hardEdge, // This provides the clipping without ClipRRect
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

Future<void> generateResumePdf() async {
  final pdf = pw.Document();

  // Load image from assets (you must add it to pubspec.yaml)
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/profile.jpg')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left Sidebar
            pw.Container(
              width: 180,
              color: PdfColor.fromInt(0xFF0C2D48),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.ClipOval(
                      child: pw.Image(profileImage, width: 100, height: 100),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("Contact",
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text("📞 123-456-7890",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Text("✉️ hello@reallygreatsite.com",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Text("📍 123 Anywhere st., Any City",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Text("🌐 www.reallygreatsite.com",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(height: 20),
                  pw.Text("Skills",
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Bullet(
                      text: "Layout Design ★★★★★",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Bullet(
                      text: "Web Design ★★★★☆",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Bullet(
                      text: "Digital Imaging ★★★★☆",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Bullet(
                      text: "Print Production ★★★★☆",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(height: 20),
                  pw.Text("Language",
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Bullet(
                      text: "English",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Bullet(
                      text: "German",
                      style: pw.TextStyle(color: PdfColors.white)),
                  pw.Bullet(
                      text: "France",
                      style: pw.TextStyle(color: PdfColors.white)),
                ],
              ),
            ),

            // Right Side
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Adeline Palmerston",
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Graphic Designer",
                        style: pw.TextStyle(
                            fontSize: 16, color: PdfColors.grey700)),
                    pw.SizedBox(height: 20),
                    pw.Text("Profile",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      "As a passionate and versatile graphic designer, I am successful at turning concepts into visually appealing designs. With a strong foundation in attention to detail, I am dedicated to providing creative solutions that captivate viewers and convey messages effectively.",
                      textAlign: pw.TextAlign.justify,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text("Work Experience",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        "Graphic Designer | Creative Agency | May 2018 - Present"),
                    pw.Bullet(
                        text:
                            "Collaborated with clients to understand their design needs."),
                    pw.Text(
                        "Freelance Graphic Designer | Self-Employed | June 2020 – Dec 2022"),
                    pw.Bullet(
                        text:
                            "Collaborated directly with clients to assess design needs, goals, and target audiences."),
                    pw.SizedBox(height: 20),
                    pw.Text("Education",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Bullet(
                        text:
                            "Bachelor of Fine Arts in Graphic Design | Fauget University | Graduated May 2018"),
                    pw.Bullet(
                        text:
                            "\"Mastering Color Theory in Design\" | Design Academy | March 2020"),
                  ],
                ),
              ),
            )
          ],
        );
      },
    ),
  );

  // Display the preview or print
  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}

// import 'package:craftfolio/core/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:craftfolio/screens/templates/resume_templates.dart';
// import 'package:craftfolio/models/user_resume_info.dart';

// import 'package:craftfolio/screens/templates/template_detail_page.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// // Class to store resume template information
// class ResumeTemplateInfo {
//   final int id;
//   final String name;
//   final String description;
//   final Color themeColor;
//   final pw.Document Function(UserResumeInfo) buildTemplate;

//   ResumeTemplateInfo({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.themeColor,
//     required this.buildTemplate,
//   });
// }

// class TemplatesPage extends StatefulWidget {
//   const TemplatesPage({super.key});

//   @override
//   State<TemplatesPage> createState() => _TemplatesPageState();
// }

// class _TemplatesPageState extends State<TemplatesPage> {
//   // List of resume templates available in the new PDF-based implementation
//   final List<ResumeTemplateInfo> resumeTemplates = [
//     ResumeTemplateInfo(
//       id: 1,
//       name: 'Classic Resume',
//       description: 'Traditional and elegant layout for professional use',
//       themeColor: Colors.green,
//       buildTemplate: buildClassicResume,
//     ),
//     ResumeTemplateInfo(
//       id: 2,
//       name: 'Modern Sidebar',
//       description: 'Modern resume with sidebar for skills and info',
//       themeColor: Colors.blue,
//       buildTemplate: buildModernSidebarResume,
//     ),
//     ResumeTemplateInfo(
//       id: 3,
//       name: 'Minimalist Resume',
//       description: 'Simple and clean minimalist layout',
//       themeColor: Colors.orange,
//       buildTemplate: buildMinimalistResume,
//     ),
//     ResumeTemplateInfo(
//       id: 4,
//       name: 'Creative Header',
//       description: 'Creative resume with a bold header',
//       themeColor: Colors.purple,
//       buildTemplate: buildCreativeHeaderResume,
//     ),
//     ResumeTemplateInfo(
//       id: 5,
//       name: 'Compact Resume',
//       description: 'Compact, two-column layout for concise resumes',
//       themeColor: Colors.teal,
//       buildTemplate: buildCompactResume,
//     ),
//     ResumeTemplateInfo(
//       id: 6,
//       name: 'Elegant Resume',
//       description: 'Elegant, professional, and modern one-page CV',
//       themeColor: Colors.indigo,
//       buildTemplate: buildElegantResume,
//     ),
//   ];

//   // Load user profiles from Firebase and convert to UserResumeInfo list
//   List<UserResumeInfo> _userProfiles = [];

//   @override
//   void initState() {
//     super.initState();
//     // No eager profile loading here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         // decoration: BoxDecoration(
//         //   gradient: LinearGradient(
//         //     begin: Alignment.topCenter,
//         //     end: Alignment.bottomCenter,
//         //     colors: [
//         //       const Color(0xFF1A237E).withOpacity(0.9),
//         //       const Color(0xFF0D47A1),
//         //       const Color(0xFF1565C0).withOpacity(0.8),
//         //     ],
//         //   ),
//         // ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Welcome header with user's name
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue.shade600, Colors.blue.shade800],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hello, ${AuthService().userInfo?.displayName ?? 'User'}!',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Choose a template to create your professional resume',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Section title
//                 const Text(
//                   'Resume Templates',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Templates Grid
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemCount: resumeTemplates.length,
//                     itemBuilder: (context, index) {
//                       final template = resumeTemplates[index];
//                       return GestureDetector(
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => TemplateDetailPage(
//                                 templateInfo: template,
//                                 userProfiles: _userProfiles,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 1,
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // Template Preview
//                               Expanded(
//                                 flex: 3,
//                                 child: Container(
//                                   margin: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: template.themeColor.withOpacity(0.1),
//                                   ),
//                                   // Removed ClipRRect and directly added the preview widget
//                                   child: buildTemplatePreview(template),
//                                 ),
//                               ),
//                               // Template Name
//                               Expanded(
//                                 flex: 1,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         template.name,
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black87,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build a preview of the template
//   Widget buildTemplatePreview(ResumeTemplateInfo template) {
//     // Create a simplified preview of the resume template with border radius applied directly
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       clipBehavior:
//           Clip.hardEdge, // This provides the clipping without ClipRRect
//       child: Row(
//         children: [
//           // Left sidebar preview (typical in most resume templates)
//           Container(
//             width: 80,
//             color: template.themeColor,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.white70,
//                   child: Icon(Icons.person, size: 24),
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   height: 4,
//                   width: 40,
//                   color: Colors.white70,
//                 ),
//                 const SizedBox(height: 6),
//                 Container(
//                   height: 4,
//                   width: 30,
//                   color: Colors.white70,
//                 ),
//               ],
//             ),
//           ),
//           // Right content preview
//           Expanded(
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 6,
//                     width: 100,
//                     color: template.themeColor.withOpacity(0.7),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     height: 4,
//                     width: 140,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Container(
//                         height: 10,
//                         width: 10,
//                         color: template.themeColor,
//                       ),
//                       const SizedBox(width: 6),
//                       Container(
//                         height: 4,
//                         width: 80,
//                         color: Colors.grey[400],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Container(
//                         height: 10,
//                         width: 10,
//                         color: template.themeColor,
//                       ),
//                       const SizedBox(width: 6),
//                       Container(
//                         height: 4,
//                         width: 60,
//                         color: Colors.grey[400],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<void> generateResumePdf() async {
//   final pdf = pw.Document();

//   // Load image from assets (you must add it to pubspec.yaml)
//   final profileImage = pw.MemoryImage(
//     (await rootBundle.load('assets/profile.jpg')).buffer.asUint8List(),
//   );

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (context) {
//         return pw.Row(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Left Sidebar
//             pw.Container(
//               width: 180,
//               color: PdfColor.fromInt(0xFF0C2D48),
//               padding: const pw.EdgeInsets.all(10),
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Center(
//                     child: pw.ClipOval(
//                       child: pw.Image(profileImage, width: 100, height: 100),
//                     ),
//                   ),
//                   pw.SizedBox(height: 20),
//                   pw.Text("Contact",
//                       style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontWeight: pw.FontWeight.bold)),
//                   pw.SizedBox(height: 5),
//                   pw.Text("📞 123-456-7890",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Text("✉️ hello@reallygreatsite.com",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Text("📍 123 Anywhere st., Any City",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Text("🌐 www.reallygreatsite.com",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.SizedBox(height: 20),
//                   pw.Text("Skills",
//                       style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontWeight: pw.FontWeight.bold)),
//                   pw.Bullet(
//                       text: "Layout Design ★★★★★",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Bullet(
//                       text: "Web Design ★★★★☆",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Bullet(
//                       text: "Digital Imaging ★★★★☆",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Bullet(
//                       text: "Print Production ★★★★☆",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.SizedBox(height: 20),
//                   pw.Text("Language",
//                       style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontWeight: pw.FontWeight.bold)),
//                   pw.Bullet(
//                       text: "English",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Bullet(
//                       text: "German",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                   pw.Bullet(
//                       text: "France",
//                       style: pw.TextStyle(color: PdfColors.white)),
//                 ],
//               ),
//             ),

//             // Right Side
//             pw.Expanded(
//               child: pw.Padding(
//                 padding: const pw.EdgeInsets.all(16.0),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text("Adeline Palmerston",
//                         style: pw.TextStyle(
//                             fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                     pw.Text("Graphic Designer",
//                         style: pw.TextStyle(
//                             fontSize: 16, color: PdfColors.grey700)),
//                     pw.SizedBox(height: 20),
//                     pw.Text("Profile",
//                         style: pw.TextStyle(
//                             fontSize: 16, fontWeight: pw.FontWeight.bold)),
//                     pw.Text(
//                       "As a passionate and versatile graphic designer, I am successful at turning concepts into visually appealing designs. With a strong foundation in attention to detail, I am dedicated to providing creative solutions that captivate viewers and convey messages effectively.",
//                       textAlign: pw.TextAlign.justify,
//                     ),
//                     pw.SizedBox(height: 20),
//                     pw.Text("Work Experience",
//                         style: pw.TextStyle(
//                             fontSize: 16, fontWeight: pw.FontWeight.bold)),
//                     pw.Text(
//                         "Graphic Designer | Creative Agency | May 2018 - Present"),
//                     pw.Bullet(
//                         text:
//                             "Collaborated with clients to understand their design needs."),
//                     pw.Text(
//                         "Freelance Graphic Designer | Self-Employed | June 2020 – Dec 2022"),
//                     pw.Bullet(
//                         text:
//                             "Collaborated directly with clients to assess design needs, goals, and target audiences."),
//                     pw.SizedBox(height: 20),
//                     pw.Text("Education",
//                         style: pw.TextStyle(
//                             fontSize: 16, fontWeight: pw.FontWeight.bold)),
//                     pw.Bullet(
//                         text:
//                             "Bachelor of Fine Arts in Graphic Design | Fauget University | Graduated May 2018"),
//                     pw.Bullet(
//                         text:
//                             "\"Mastering Color Theory in Design\" | Design Academy | March 2020"),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     ),
//   );

//   // Display the preview or print
//   await Printing.layoutPdf(onLayout: (format) => pdf.save());
// }
