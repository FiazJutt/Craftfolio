import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../models/user_resume_info.dart';

// Helper function to create section headers
pw.Widget _buildSectionHeader(String title,
    {PdfColor? color, double? fontSize}) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 12, bottom: 6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: fontSize ?? 14,
            fontWeight: pw.FontWeight.bold,
            color: color ?? PdfColors.black,
            letterSpacing: 1.2,
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 4),
          height: 2,
          width: 40,
          color: color ?? PdfColors.blue,
        ),
      ],
    ),
  );
}

// Helper function to create skill bars
pw.Widget _buildSkillBar(String skill, int level, {PdfColor? color}) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          skill,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Container(
          width: 100,
          height: 6,
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.circular(3),
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              width: 100 * (level / 5),
              height: 6,
              decoration: pw.BoxDecoration(
                color: color ?? PdfColors.blue,
                borderRadius: pw.BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// 1. Enhanced Classic Resume Template
pw.Document buildClassicResume(UserResumeInfo data) {
  final pdf = pw.Document();

  pdf.addPage(
    // pw.Page(
    // pageFormat: PdfPageFormat.a4,
    // margin: const pw.EdgeInsets.all(32),
    // build: (pw.Context context) => pw.Column(
    //   crossAxisAlignment: pw.CrossAxisAlignment.start,
    //   children: [
    pw.MultiPage(
      // Changed from pw.Page to pw.MultiPage
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24), // Reduced margin from 32 to 24
      build: (pw.Context context) => [
        // Header Section
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 20),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (data.profileImageBytes != null)
                pw.Container(
                  width: 80,
                  height: 80,
                  margin: const pw.EdgeInsets.only(right: 20),
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.grey400, width: 2),
                  ),
                  child: pw.ClipOval(
                    child: pw.Image(
                      pw.MemoryImage(data.profileImageBytes!),
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.fullName,
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data.currentPosition,
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.blue,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Email:  ${data.email}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.SizedBox(width: 20),
                        pw.Text(
                          'Phone: ${data.phoneNumber}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    if (data.street.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4),
                        child: pw.Text(
                          'Address: ${data.street}, ${data.address}, ${data.country}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Professional Summary
        _buildSectionHeader('Professional Summary'),
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: pw.Text(
            data.bio,
            style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.4),
            textAlign: pw.TextAlign.justify,
          ),
        ),

        // Skills Section
        _buildSectionHeader('Core Competencies'),
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 16, bottom: 16),
          child: pw.Wrap(
            spacing: 20,
            runSpacing: 12,
            children: data.skills
                .map((skill) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue50,
                        borderRadius: pw.BorderRadius.circular(15),
                        border: pw.Border.all(color: PdfColors.blue200),
                      ),
                      child: pw.Text(
                        '${skill.name} . ${skill.level}/5',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.blue800,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        // Experience Section
        _buildSectionHeader('Professional Experience'),
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 16),
          child: pw.Column(
            children: data.workExperiences
                .map((exp) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 16),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 8,
                            height: 8,
                            margin: const pw.EdgeInsets.only(top: 6, right: 12),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.blue,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  exp.title,
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  '${exp.company} • ${exp.location}',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    color: PdfColors.blue,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  exp.period,
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: PdfColors.grey600,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                                pw.SizedBox(height: 6),
                                pw.Text(
                                  exp.description,
                                  style: const pw.TextStyle(
                                      fontSize: 11, lineSpacing: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),

        // Education Section
        _buildSectionHeader('Education'),
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 16),
          child: pw.Column(
            children: data.educationEntries
                .map((edu) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 6,
                            height: 6,
                            margin: const pw.EdgeInsets.only(top: 6, right: 12),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.blue,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  edu.degree,
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  '${edu.institution} • ${edu.period}',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: PdfColors.grey600,
                                  ),
                                ),
                                if (edu.description.isNotEmpty)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(top: 4),
                                    child: pw.Text(
                                      edu.description,
                                      style: const pw.TextStyle(fontSize: 10),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),

        // Interests Section
        if (data.hobbies.isNotEmpty) ...[
          _buildSectionHeader('Interests & Hobbies'),
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 16),
            child: pw.Wrap(
              spacing: 12,
              runSpacing: 8,
              children: data.hobbies
                  .map((hobby) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text(
                          hobby,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ],

      // ),
    ),
  );
  return pdf;
}

// 2. Enhanced Modern Sidebar Resume Template
pw.Document buildModernSidebarResume(UserResumeInfo data) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (pw.Context context) => pw.Row(
        children: [
          // Sidebar
          pw.Container(
            width: 170,
            color: PdfColors.blueGrey800,
            padding: const pw.EdgeInsets.all(18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Profile Image
                if (data.profileImageBytes != null)
                  pw.Center(
                    child: pw.Container(
                      width: 100,
                      height: 100,
                      margin: const pw.EdgeInsets.only(bottom: 10),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: PdfColors.white, width: 3),
                      ),
                      child: pw.ClipOval(
                        child: pw.Image(
                          pw.MemoryImage(data.profileImageBytes!),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                // Name and Title
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        data.fullName,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        data.currentPosition,
                        style: pw.TextStyle(
                          color: PdfColors.blueGrey200,
                          fontSize: 14,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // Contact Information
                pw.Text(
                  'CONTACT',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 8, bottom: 16),
                  height: 2,
                  width: 40,
                  color: PdfColors.blueGrey400,
                ),

                _buildContactItem('Email : ', data.email),
                _buildContactItem('Phone : ', data.phoneNumber),
                if (data.street.isNotEmpty)
                  _buildContactItem('Address : ',
                      '${data.street}, ${data.address}, ${data.country}'),

                pw.SizedBox(height: 20),

                // Skills Section
                pw.Text(
                  'SKILLS',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 6, bottom: 12),
                  height: 2,
                  width: 40,
                  color: PdfColors.blueGrey400,
                ),

                pw.Column(
                  children: data.skills
                      .map((skill) => _buildSkillBar(skill.name, skill.level,
                          color: PdfColors.blueGrey400))
                      .toList(),
                ),

                pw.SizedBox(height: 20),

                // Hobbies Section
                if (data.hobbies.isNotEmpty) ...[
                  pw.Text(
                    'INTERESTS',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 6, bottom: 12),
                    height: 2,
                    width: 40,
                    color: PdfColors.blueGrey400,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: data.hobbies
                        .map((hobby) => pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 6),
                              child: pw.Row(
                                children: [
                                  pw.Container(
                                    width: 4,
                                    height: 4,
                                    margin: const pw.EdgeInsets.only(
                                        right: 6, top: 3),
                                    decoration: const pw.BoxDecoration(
                                      color: PdfColors.blueGrey400,
                                      shape: pw.BoxShape.circle,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                      hobby,
                                      style: pw.TextStyle(
                                        color: PdfColors.blueGrey200,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          // Main Content Area
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // About Section
                  _buildSectionHeader('About Me', color: PdfColors.blueGrey800),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 12),
                    child: pw.Text(
                      data.bio,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1),
                      textAlign: pw.TextAlign.justify,
                    ),
                  ),

                  // Experience Section
                  _buildSectionHeader('Experience',
                      color: PdfColors.blueGrey800),
                  pw.Column(
                    children: data.workExperiences
                        .map((exp) => pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    exp.title,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.blueGrey800,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    '${exp.company} . ${exp.location}',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.blueGrey600,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    exp.period,
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.grey600,
                                      fontStyle: pw.FontStyle.italic,
                                    ),
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Text(
                                    exp.description,
                                    style: const pw.TextStyle(
                                        fontSize: 10, lineSpacing: 1),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),

                  // Education Section
                  _buildSectionHeader('Education',
                      color: PdfColors.blueGrey800),
                  pw.Column(
                    children: data.educationEntries
                        .map((edu) => pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    edu.degree,
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.blueGrey800,
                                    ),
                                  ),
                                  pw.Text(
                                    '${edu.institution} . ${edu.period}',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColors.grey600,
                                    ),
                                  ),
                                  if (edu.description.isNotEmpty)
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.only(top: 4),
                                      child: pw.Text(
                                        edu.description,
                                        style: const pw.TextStyle(fontSize: 10),
                                      ),
                                    ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  return pdf;
}

// Helper function for contact items in sidebar
pw.Widget _buildContactItem(String label, String text) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 12),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Expanded(
          child: pw.Text(
            text,
            style: pw.TextStyle(
              color: PdfColors.blueGrey200,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

// // 3. Minimalist Resume Template

pw.Document buildMinimalistResume(UserResumeInfo data) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (pw.Context context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(children: [
              pw.Column(children: [
                // Name and Contact
                pw.Text(
                  data.fullName,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(data.currentPosition,
                    style: pw.TextStyle(
                        fontSize: 12, fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 8),
              ]),
            ]),
            pw.Row(children: [
              pw.Text(data.email),
              pw.Text(data.phoneNumber),
            ]),
            pw.SizedBox(height: 8),
          ],
        ),

        pw.Divider(),

        // About
        pw.SizedBox(height: 8),
        pw.Text('About', style: sectionTitle),
        pw.SizedBox(height: 6),
        pw.Text(data.bio),
        pw.SizedBox(height: 8),

        pw.Divider(),

        // Skills
        pw.SizedBox(height: 8),
        pw.Text('Skills', style: sectionTitle),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 8,
          runSpacing: 6,
          children: data.skills
              .map((s) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Text('${s.name} (${s.level}/5)'),
                  ))
              .toList(),
        ),
        pw.SizedBox(height: 8),

        pw.Divider(),

        // Experience
        pw.SizedBox(height: 8),
        pw.Text('Experience', style: sectionTitle),
        pw.SizedBox(height: 6),
        ...data.workExperiences.map((exp) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${exp.title} at ${exp.company}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('${exp.location} , ${exp.period}',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  pw.SizedBox(height: 4),
                  pw.Text(exp.description),
                ],
              ),
            )),

        pw.Divider(),

        // Education
        pw.SizedBox(height: 8),
        pw.Text('Education', style: sectionTitle),
        pw.SizedBox(height: 6),
        ...data.educationEntries.map((edu) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${edu.degree}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('${edu.institution} , ${edu.period}',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  pw.SizedBox(height: 4),
                  pw.Text(edu.description),
                ],
              ),
            )),

        pw.Divider(),

        // Hobbies
        pw.SizedBox(height: 8),
        pw.Text('Hobbies', style: sectionTitle),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 8,
          runSpacing: 6,
          children: data.hobbies
              .map((h) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Text(h),
                  ))
              .toList(),
        ),
      ],
    ),
  );

  return pdf;
}

// Reusable section title style
final sectionTitle = pw.TextStyle(
  fontSize: 14,
  fontWeight: pw.FontWeight.bold,
  color: PdfColors.black,
);

// pw.Document buildMinimalistResume(UserResumeInfo data) {
//   final pdf = pw.Document();
//   pdf.addPage(
//     // pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       margin: const pw.EdgeInsets.all(40),
//       build: (pw.Context context) => [
//         // pw.Page(
//         // build: (pw.Context context) =>
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.center,
//           children: [
//             if (data.profileImageBytes != null)
//               pw.Center(
//                 child: pw.Container(
//                   width: 60,
//                   height: 60,
//                   child: pw.Image(pw.MemoryImage(data.profileImageBytes!)),
//                 ),
//               ),
//             pw.Text(data.fullName,
//                 style:
//                     pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//             pw.Text(data.email),
//             pw.Text(data.phoneNumber),
//             pw.Text(data.currentPosition),
//             pw.Divider(),
//             pw.Text('About',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             pw.Text(data.bio),
//             pw.Divider(),
//             pw.Text('Skills',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             pw.Wrap(
//                 children: data.skills
//                     .map((s) => pw.Text('${s.name} (${s.level}/5)  '))
//                     .toList()),
//             pw.Divider(),
//             pw.Text('Experience',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             ...data.workExperiences.map((exp) => pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text('${exp.title} at ${exp.company} (${exp.period})',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text(exp.description),
//                     pw.SizedBox(height: 5),
//                   ],
//                 )),
//             pw.Divider(),
//             pw.Text('Education',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             ...data.educationEntries.map((edu) => pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                         '${edu.degree} - ${edu.institution} (${edu.period})'),
//                     pw.Text(edu.description),
//                     pw.SizedBox(height: 5),
//                   ],
//                 )),
//             pw.Divider(),
//             pw.Text('Hobbies',
//                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//             pw.Wrap(
//                 children: data.hobbies.map((h) => pw.Text('$h  ')).toList()),
//           ],
//         ),
//       ],
//     ),
//   );
//   return pdf;
// }

// 4. Enhanced Creative Header Resume Template
pw.Document buildCreativeHeaderResume(UserResumeInfo data) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.Container(
            height: 150,
            decoration: pw.BoxDecoration(
              gradient: const pw.LinearGradient(
                colors: [PdfColors.blue800, PdfColors.blue600],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (data.profileImageBytes != null)
                    pw.Container(
                      width: 90,
                      height: 90,
                      margin: const pw.EdgeInsets.only(right: 24),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: PdfColors.white, width: 3),
                      ),
                      child: pw.ClipOval(
                        child: pw.Image(
                          pw.MemoryImage(data.profileImageBytes!),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          data.fullName,
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          data.currentPosition,
                          style: pw.TextStyle(
                            fontSize: 18,
                            color: PdfColors.blue100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      _buildHeaderContactItem('Email: ', data.email),
                      _buildHeaderContactItem('Phone: ', data.phoneNumber),
                      if (data.street.isNotEmpty)
                        _buildHeaderContactItem(
                            'Address: ', '${data.street}, ${data.address}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return pw.SizedBox.shrink();
        }
      },
      build: (pw.Context context) => [
        pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // About Section
              _buildSectionHeader('About Me', color: PdfColors.blue800),
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Text(
                  data.bio,
                  style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.4),
                  textAlign: pw.TextAlign.justify,
                ),
              ),

              // Skills Section
              _buildSectionHeader('Skills & Expertise',
                  color: PdfColors.blue800),
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: data.skills
                      .map((skill) => pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: pw.BoxDecoration(
                              gradient: const pw.LinearGradient(
                                colors: [PdfColors.blue50, PdfColors.blue100],
                              ),
                              borderRadius: pw.BorderRadius.circular(20),
                              border: pw.Border.all(color: PdfColors.blue300),
                            ),
                            child: pw.Row(
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                pw.Text(
                                  skill.name,
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.blue800,
                                  ),
                                ),
                                pw.SizedBox(width: 8),
                                pw.Row(
                                  children: List.generate(
                                      5,
                                      (index) => pw.Container(
                                            width: 6,
                                            height: 6,
                                            margin: const pw.EdgeInsets.only(
                                                right: 2),
                                            decoration: pw.BoxDecoration(
                                              color: index < skill.level
                                                  ? PdfColors.blue600
                                                  : PdfColors.grey300,
                                              shape: pw.BoxShape.circle,
                                            ),
                                          )),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

              // Experience Section
              _buildSectionHeader('Professional Experience',
                  color: PdfColors.blue800),
              pw.Column(
                children: data.workExperiences
                    .map((exp) => pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(
                              left: pw.BorderSide(
                                  color: PdfColors.blue600, width: 3),
                            ),
                          ),
                          padding: const pw.EdgeInsets.only(left: 16),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                exp.title,
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue800,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                '${exp.company} . ${exp.location}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColors.blue600,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 2),
                              pw.Text(
                                exp.period,
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColors.grey600,
                                  fontStyle: pw.FontStyle.italic,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text(
                                exp.description,
                                style: const pw.TextStyle(
                                    fontSize: 11, lineSpacing: 1.3),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),

              // Education Section
              _buildSectionHeader('Education', color: PdfColors.blue800),
              pw.Column(
                children: data.educationEntries
                    .map((edu) => pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Row(
                            children: [
                              pw.Container(
                                width: 40,
                                height: 40,
                                margin: const pw.EdgeInsets.only(right: 16),
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.blue100,
                                  borderRadius: pw.BorderRadius.circular(8),
                                ),
                                child: pw.Center(
                                  child: pw.Text(
                                    '🎓',
                                    style: const pw.TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      edu.degree,
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.blue800,
                                      ),
                                    ),
                                    pw.Text(
                                      '${edu.institution} . ${edu.period}',
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        color: PdfColors.grey600,
                                      ),
                                    ),
                                    if (edu.description.isNotEmpty)
                                      pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(top: 4),
                                        child: pw.Text(
                                          edu.description,
                                          style:
                                              const pw.TextStyle(fontSize: 10),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),

              // Interests Section
              if (data.hobbies.isNotEmpty) ...[
                _buildSectionHeader('Interests & Hobbies',
                    color: PdfColors.blue800),
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: data.hobbies
                      .map((hobby) => pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey100,
                              borderRadius: pw.BorderRadius.circular(15),
                              border: pw.Border.all(color: PdfColors.grey300),
                            ),
                            child: pw.Text(
                              hobby,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
          // ),
          // ),
        ),
      ],
    ),
  );
  return pdf;
}

// Helper function for header contact items
pw.Widget _buildHeaderContactItem(String label, String text) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          text,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

// 5. Enhanced Compact Resume Template - Optimized for One Page
pw.Document buildCompactResume(UserResumeInfo data) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16), // Reduced from 24
      build: (pw.Context context) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left Column
          pw.Container(
            width: 150, // Reduced from 160
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Profile Section
                pw.Container(
                  padding: const pw.EdgeInsets.all(12), // Reduced from 16
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(6), // Reduced from 8
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      if (data.profileImageBytes != null)
                        pw.Container(
                          width: 60, // Reduced from 80
                          height: 60, // Reduced from 80
                          margin: const pw.EdgeInsets.only(
                              bottom: 8), // Reduced from 12
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            border: pw.Border.all(
                                color: PdfColors.grey400,
                                width: 1.5), // Reduced from 2
                          ),
                          child: pw.ClipOval(
                            child: pw.Image(
                              pw.MemoryImage(data.profileImageBytes!),
                              fit: pw.BoxFit.cover,
                            ),
                          ),
                        ),
                      pw.Text(
                        data.fullName,
                        style: pw.TextStyle(
                          fontSize: 13, // Reduced from 14
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 2), // Reduced from 4
                      pw.Text(
                        data.currentPosition,
                        style: pw.TextStyle(
                          fontSize: 11, // Reduced from 12
                          color: PdfColors.grey600,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 12), // Reduced from 16

                // Contact Information
                pw.Container(
                  padding: const pw.EdgeInsets.all(10), // Reduced from 12
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(6), // Reduced from 8
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'CONTACT',
                        style: pw.TextStyle(
                          fontSize: 11, // Reduced from 12
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800,
                          letterSpacing: 1,
                        ),
                      ),
                      pw.SizedBox(height: 6), // Reduced from 8
                      _buildCompactContactItem('Email : ', data.email),
                      _buildCompactContactItem('Phone : ', data.phoneNumber),
                      if (data.street.isNotEmpty)
                        _buildCompactContactItem('Address : ',
                            '${data.street}, ${data.address}, ${data.country}'),
                    ],
                  ),
                ),

                pw.SizedBox(height: 12), // Reduced from 16

                // Skills Section
                pw.Container(
                  padding: const pw.EdgeInsets.all(10), // Reduced from 12
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(6), // Reduced from 8
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SKILLS',
                        style: pw.TextStyle(
                          fontSize: 11, // Reduced from 12
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800,
                          letterSpacing: 1,
                        ),
                      ),
                      pw.SizedBox(height: 6), // Reduced from 8
                      pw.Column(
                        children: data.skills
                            .map((skill) => pw.Container(
                                  margin: const pw.EdgeInsets.only(
                                      bottom: 6), // Reduced from 8
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            skill.name,
                                            style: const pw.TextStyle(
                                                fontSize: 9), // Reduced from 10
                                          ),
                                          pw.Text(
                                            '${skill.level}/5',
                                            style: pw.TextStyle(
                                              fontSize: 8, // Reduced from 9
                                              color: PdfColors.grey600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      pw.SizedBox(height: 2),
                                      pw.Container(
                                        width: double.infinity,
                                        height: 3, // Reduced from 4
                                        decoration: pw.BoxDecoration(
                                          color: PdfColors.grey300,
                                          borderRadius:
                                              pw.BorderRadius.circular(
                                                  1.5), // Reduced from 2
                                        ),
                                        child: pw.Align(
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Container(
                                            width: 130 *
                                                (skill.level /
                                                    5), // Adjusted for new width
                                            height: 3, // Reduced from 4
                                            decoration: pw.BoxDecoration(
                                              color: PdfColors.grey700,
                                              borderRadius:
                                                  pw.BorderRadius.circular(
                                                      1.5), // Reduced from 2
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 12), // Reduced from 16

                // Hobbies Section
                if (data.hobbies.isNotEmpty)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10), // Reduced from 12
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius:
                          pw.BorderRadius.circular(6), // Reduced from 8
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INTERESTS',
                          style: pw.TextStyle(
                            fontSize: 11, // Reduced from 12
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                            letterSpacing: 1,
                          ),
                        ),
                        pw.SizedBox(height: 6), // Reduced from 8
                        pw.Wrap(
                          spacing: 4, // Reduced from 6
                          runSpacing: 4, // Reduced from 6
                          children: data.hobbies
                              .map((hobby) => pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3), // Reduced padding
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.grey200,
                                      borderRadius: pw.BorderRadius.circular(
                                          8), // Reduced from 10
                                    ),
                                    child: pw.Text(
                                      hobby,
                                      style: const pw.TextStyle(
                                          fontSize: 8), // Reduced from 9
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          pw.SizedBox(width: 16), // Reduced from 20

          // Right Column
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // About Section
                _buildSectionHeader('Professional Summary'),
                pw.Container(
                  padding:
                      const pw.EdgeInsets.only(bottom: 8), // Reduced from 10
                  child: pw.Text(
                    data.bio,
                    style: const pw.TextStyle(
                        fontSize: 10, lineSpacing: 1.2), // Reduced from 11
                    textAlign: pw.TextAlign.justify,
                  ),
                ),

                // Experience Section
                _buildSectionHeader('Experience'),
                pw.Column(
                  children: data.workExperiences
                      .map((exp) => pw.Container(
                            margin: const pw.EdgeInsets.only(
                                bottom: 8), // Reduced from 10
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      width: 6, // Reduced from 8
                                      height: 6, // Reduced from 8
                                      margin: const pw.EdgeInsets.only(
                                          top: 3, right: 10), // Reduced margins
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.blue,
                                        shape: pw.BoxShape.circle,
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            exp.title,
                                            style: pw.TextStyle(
                                              fontSize: 11, // Reduced from 12
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                          pw.SizedBox(
                                              height: 1), // Reduced from 2
                                          pw.Row(children: [
                                            pw.Text(
                                              '${exp.company} • ${exp.location}',
                                              style: pw.TextStyle(
                                                fontSize: 10, // Reduced from 11
                                                color: PdfColors.blue,
                                                fontWeight: pw.FontWeight.bold,
                                              ),
                                            ),
                                            pw.Spacer(),
                                            pw.Text(
                                              exp.period,
                                              style: pw.TextStyle(
                                                fontSize: 9, // Reduced from 10
                                                color: PdfColors.grey600,
                                                fontStyle: pw.FontStyle.italic,
                                              ),
                                            ),
                                          ]),
                                          pw.SizedBox(
                                              height: 4), // Reduced from 6
                                          pw.Text(
                                            exp.description,
                                            style: const pw.TextStyle(
                                                fontSize: 10,
                                                lineSpacing:
                                                    1.2), // Reduced from 11
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),

                // Education Section
                _buildSectionHeader('Education'),
                pw.Column(
                  children: data.educationEntries
                      .map((edu) => pw.Container(
                            margin: const pw.EdgeInsets.only(
                                bottom: 6), // Reduced from 10
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Container(
                                  width: 5, // Reduced from 6
                                  height: 5, // Reduced from 6
                                  margin: const pw.EdgeInsets.only(
                                      top: 3, right: 10), // Reduced margins
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.blue,
                                    shape: pw.BoxShape.circle,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        edu.degree,
                                        style: pw.TextStyle(
                                          fontSize: 10, // Reduced from 11
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '${edu.institution} • ${edu.period}',
                                        style: pw.TextStyle(
                                          fontSize: 9, // Reduced from 10
                                          color: PdfColors.grey600,
                                        ),
                                      ),
                                      if (edu.description.isNotEmpty)
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.only(
                                              top: 2), // Reduced from 4
                                          child: pw.Text(
                                            edu.description,
                                            style: const pw.TextStyle(
                                                fontSize: 9), // Reduced from 10
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  return pdf;
}

// Helper function for compact contact items
pw.Widget _buildCompactContactItem(String label, String text) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Expanded(
          child: pw.Text(
            text,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    ),
  );
}

// 6. Elegant Resume Template
pw.Document buildElegantResume(UserResumeInfo data) {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) => pw.Container(
        padding: const pw.EdgeInsets.all(0),
        child: pw.Column(
          children: [
            // pw.MultiPage(
            //     // Changed from pw.Page to pw.MultiPage
            //     pageFormat: PdfPageFormat.a4,
            //     margin: const pw.EdgeInsets.all(24), // Reduced margin from 32 to 24
            //     build: (pw.Context context) => [
            // Header
            pw.Container(
              color: PdfColors.blueGrey900,
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(data.fullName,
                          style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white)),
                      pw.SizedBox(height: 4),
                      pw.Text(data.currentPosition,
                          style: pw.TextStyle(
                              fontSize: 13, color: PdfColors.blueGrey100)),
                      pw.SizedBox(height: 8),
                      pw.Text('${data.email} | ${data.phoneNumber}',
                          style: pw.TextStyle(
                              fontSize: 11, color: PdfColors.blueGrey100)),
                      pw.Text(
                          '${data.street}, ${data.address}, ${data.country}',
                          style: pw.TextStyle(
                              fontSize: 11, color: PdfColors.blueGrey100)),
                    ],
                  ),
                  if (data.profileImageBytes != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: PdfColors.white, width: 2),
                      ),
                      child: pw.ClipOval(
                        child:
                            pw.Image(pw.MemoryImage(data.profileImageBytes!)),
                      ),
                    ),
                ],
              ),
            ),
            // Body
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Sidebar
                pw.Container(
                  width: 140,
                  color: PdfColors.blueGrey50,
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 18, horizontal: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('SKILLS',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey800,
                              fontSize: 11,
                              letterSpacing: 1.5)),
                      pw.SizedBox(height: 6),
                      ...data.skills.map((s) => pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Text(s.name,
                                      style: pw.TextStyle(fontSize: 10)),
                                ),
                                pw.Container(
                                  width: 36,
                                  height: 6,
                                  decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(3),
                                    color: PdfColors.blueGrey200,
                                  ),
                                  child: pw.Container(
                                    width: 36 * (s.level / 5),
                                    height: 6,
                                    decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(3),
                                      color: PdfColors.blueGrey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      pw.SizedBox(height: 18),
                      pw.Text('HOBBIES',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey800,
                              fontSize: 11,
                              letterSpacing: 1.5)),
                      pw.SizedBox(height: 6),
                      pw.Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: data.hobbies
                            .map((h) => pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  decoration: pw.BoxDecoration(
                                    color: PdfColors.blueGrey100,
                                    borderRadius: pw.BorderRadius.circular(6),
                                  ),
                                  child: pw.Text(h,
                                      style: pw.TextStyle(fontSize: 9)),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                // Main content
                pw.Expanded(
                  child: pw.Container(
                    color: PdfColors.white,
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 18, horizontal: 24),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('ABOUT ME',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey800,
                                fontSize: 13,
                                letterSpacing: 1.5)),
                        pw.SizedBox(height: 6),
                        pw.Text(data.bio, style: pw.TextStyle(fontSize: 10)),
                        pw.SizedBox(height: 14),
                        pw.Text('EXPERIENCE',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey800,
                                fontSize: 13,
                                letterSpacing: 1.5)),
                        pw.SizedBox(height: 6),
                        ...data.workExperiences.map((exp) => pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 12),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('${exp.title} at ${exp.company}',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 11)),
                                  pw.Text('${exp.location}  |  ${exp.period}',
                                      style: pw.TextStyle(
                                          fontSize: 9,
                                          color: PdfColors.blueGrey500)),
                                  pw.Text(exp.description,
                                      style: pw.TextStyle(fontSize: 10)),
                                ],
                              ),
                            )),
                        pw.SizedBox(height: 10),
                        pw.Text('EDUCATION',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey800,
                                fontSize: 13,
                                letterSpacing: 1.5)),
                        pw.SizedBox(height: 6),
                        ...data.educationEntries.map((edu) => pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 10),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('${edu.degree} - ${edu.institution}',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 11)),
                                  pw.Text(edu.period,
                                      style: pw.TextStyle(
                                          fontSize: 9,
                                          color: PdfColors.blueGrey500)),
                                  pw.Text(edu.description,
                                      style: pw.TextStyle(fontSize: 10)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return pdf;
}
