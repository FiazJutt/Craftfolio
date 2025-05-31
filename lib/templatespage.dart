import 'package:craftfolio/services/auth_service.dart';
import 'package:flutter/material.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  // Sample resume templates with image paths
  final List<Map<String, dynamic>> _templates = [
    {
      'id': 1,
      'name': 'Professional',
      'image': 'assets/templates/template1.png', // Add your template images here
    },
    {
      'id': 2,
      'name': 'Creative',
      'image': 'assets/templates/template2.png',
    },
    {
      'id': 3,
      'name': 'Minimalist',
      'image': 'assets/templates/template3.jpg',
    },
    {
      'id': 4,
      'name': 'Corporate',
      'image': 'assets/templates/template4.png',
    },
    {
      'id': 5,
      'name': 'Modern',
      'image': 'assets/templates/template5.png',
    },
    {
      'id': 6,
      'name': 'Elegant',
      'image': 'assets/templates/template6.jpg',
    },
  ];

  void _onTemplateSelected(Map<String, dynamic> template) {
    // TODO: Navigate to resume builder with selected template
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${template['name']} template'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Container(
                height: 90,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Hello, ${AuthService().userInfo?.displayName ?? 'User'}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a template to get started with your resume',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Templates Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return GestureDetector(
                      onTap: () => _onTemplateSelected(template),
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
                            // Template Image Preview
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    template['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Placeholder when image is not found
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.description,
                                              size: 40,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Template ${template['id']}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Template Name
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                template['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
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
    );
  }
}














// import 'package:craftfolio/services/auth_service.dart';
// import 'package:flutter/material.dart';
//
// class TemplatesPage extends StatefulWidget {
//   const TemplatesPage({super.key});
//
//   @override
//   State<TemplatesPage> createState() => _TemplatesPageState();
// }
//
// class _TemplatesPageState extends State<TemplatesPage> {
//   // Sample resume templates
//   final List<Map<String, dynamic>> _templates = [
//     {
//       'id': 1,
//       'name': 'Professional',
//       'description': 'Clean and modern design',
//       'color': const Color(0xFF2196F3),
//       'icon': Icons.business_center,
//     },
//     {
//       'id': 2,
//       'name': 'Creative',
//       'description': 'Bold and colorful layout',
//       'color': const Color(0xFF9C27B0),
//       'icon': Icons.palette,
//     },
//     {
//       'id': 3,
//       'name': 'Minimalist',
//       'description': 'Simple and elegant',
//       'color': const Color(0xFF4CAF50),
//       'icon': Icons.layers,
//     },
//     {
//       'id': 4,
//       'name': 'Corporate',
//       'description': 'Formal business style',
//       'color': const Color(0xFF795548),
//       'icon': Icons.domain,
//     },
//   ];
//
//   void _onTemplateSelected(Map<String, dynamic> template) {
//     // TODO: Navigate to template preview or editor
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Selected ${template['name']} template'),
//         backgroundColor: template['color'],
//       ),
//     );
//   }
//
//   Widget _buildHorizontalTemplateCard(Map<String, dynamic> template, bool isSmallScreen) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Container(
//             width: isSmallScreen ? 50 : 60,
//             height: isSmallScreen ? 50 : 60,
//             decoration: BoxDecoration(
//               color: template['color'],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               template['icon'],
//               color: Colors.white,
//               size: isSmallScreen ? 24 : 30,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   template['name'],
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   template['description'],
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 11 : 12,
//                     color: Colors.white.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Icon(
//             Icons.arrow_forward_ios,
//             color: Colors.white.withOpacity(0.5),
//             size: 16,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVerticalTemplateCard(Map<String, dynamic> template, bool isSmallScreen) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: isSmallScreen ? 50 : 60,
//           height: isSmallScreen ? 50 : 60,
//           decoration: BoxDecoration(
//             color: template['color'],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             template['icon'],
//             color: Colors.white,
//             size: isSmallScreen ? 24 : 30,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           template['name'],
//           style: TextStyle(
//             fontSize: isSmallScreen ? 14 : 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Text(
//             template['description'],
//             style: TextStyle(
//               fontSize: isSmallScreen ? 11 : 12,
//               color: Colors.white.withOpacity(0.7),
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 400;
//     final crossAxisCount = isSmallScreen ? 1 : 2;
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFF1A237E).withOpacity(0.9),
//               const Color(0xFF0D47A1),
//               const Color(0xFF1565C0).withOpacity(0.8),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.04,
//               vertical: 12,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Section
//                 Container(
//                   width: double.infinity,
//                   height: 110,
//                   padding: EdgeInsets.all(20),
//                   margin: const EdgeInsets.only(bottom: 24),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.purple.shade600,
//                         Colors.purple.shade800,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.purple.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Welcome Back',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 20 : 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const Spacer(),
//
//                           Text(
//                             AuthService().userInfo?.displayName ?? 'User',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 20 : 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Select a professional template to create your resume',
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 14 : 16,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Templates Grid
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: crossAxisCount,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                     childAspectRatio: crossAxisCount == 1 ? 3.0 : 0.85,
//                   ),
//                   itemCount: _templates.length,
//                   itemBuilder: (context, index) {
//                     final template = _templates[index];
//                     return GestureDetector(
//                       onTap: () => _onTemplateSelected(template),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.2),
//                           ),
//                         ),
//                         child: crossAxisCount == 1
//                             ? _buildHorizontalTemplateCard(template, isSmallScreen)
//                             : _buildVerticalTemplateCard(template, isSmallScreen),
//                       ),
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }