import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ProfileWizard extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const ProfileWizard({Key? key, this.initialData}) : super(key: key);

  @override
  State<ProfileWizard> createState() => _ProfileWizardState();
}

class _ProfileWizardState extends State<ProfileWizard> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();

  // Personal Details
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  String? _gender;
  final _nationalityController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Work History
  final _employerController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _workStartController = TextEditingController();
  final _workEndController = TextEditingController();
  final _workDescController = TextEditingController();
  bool _workCurrent = false;

  // Education
  final _schoolController = TextEditingController();
  final _degreeController = TextEditingController();
  final _eduStartController = TextEditingController();
  final _eduEndController = TextEditingController();
  final _eduDescController = TextEditingController();
  bool _eduCurrent = false;

  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final d = widget.initialData!;
      _firstNameController.text = (d['name'] ?? '').split(' ').first;
      _lastNameController.text = (d['name'] ?? '').split(' ').skip(1).join(' ');
      _professionController.text = d['profession'] ?? '';
      _gender = d['gender'];
      _nationalityController.text = d['nationality'] ?? '';
      _dobController.text = d['dob'] ?? '';
      _phoneController.text = d['phone'] ?? '';
      _emailController.text = d['email'] ?? '';
      _addressController.text = d['address'] ?? '';
      _employerController.text = d['employer'] ?? '';
      _jobTitleController.text = d['jobTitle'] ?? '';
      _workStartController.text = d['workStart'] ?? '';
      _workEndController.text = d['workEnd'] ?? '';
      _workDescController.text = d['workDesc'] ?? '';
      _workCurrent = d['workCurrent'] ?? false;
      _schoolController.text = d['school'] ?? '';
      _degreeController.text = d['degree'] ?? '';
      _eduStartController.text = d['eduStart'] ?? '';
      _eduEndController.text = d['eduEnd'] ?? '';
      _eduDescController.text = d['eduDesc'] ?? '';
      _eduCurrent = d['eduCurrent'] ?? false;
      if (d['profileImageBytes'] != null) {
        _profileImageBytes = d['profileImageBytes'];
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    if (kIsWeb) {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _profileImageBytes = bytes);
      }
    } else {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _profileImageBytes = bytes);
      }
    }
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    DateTime? initialDate;
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (_) {}
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1A237E),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A237E),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _nationalityController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _employerController.dispose();
    _jobTitleController.dispose();
    _workStartController.dispose();
    _workEndController.dispose();
    _workDescController.dispose();
    _schoolController.dispose();
    _degreeController.dispose();
    _eduStartController.dispose();
    _eduEndController.dispose();
    _eduDescController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _step++;
      });
    }
  }

  void _prevStep() {
    setState(() {
      _step--;
    });
  }

  void _finish() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop({
        'name': _firstNameController.text + ' ' + _lastNameController.text,
        'profession': _professionController.text,
        'gender': _gender,
        'nationality': _nationalityController.text,
        'dob': _dobController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'employer': _employerController.text,
        'jobTitle': _jobTitleController.text,
        'workStart': _workStartController.text,
        'workEnd': _workEndController.text,
        'workDesc': _workDescController.text,
        'workCurrent': _workCurrent,
        'school': _schoolController.text,
        'degree': _degreeController.text,
        'eduStart': _eduStartController.text,
        'eduEnd': _eduEndController.text,
        'eduDesc': _eduDescController.text,
        'eduCurrent': _eduCurrent,
        'profileImageBytes': _profileImageBytes,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A237E).withOpacity(0.9),
                  const Color(0xFF0D47A1),
                  const Color(0xFF1565C0).withOpacity(0.8),
                ],
              ),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 16),
                    if (_step == 0) _buildPersonalDetails(),
                    if (_step == 1) _buildWorkHistory(),
                    if (_step == 2) _buildEducation(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_step > 0)
                          ElevatedButton(
                            onPressed: _prevStep,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF1A237E),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                        if (_step < 2)
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF1A237E),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        if (_step == 2)
                          ElevatedButton(
                            onPressed: _finish,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF1A237E),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text('Save'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _step == i ? Colors.white : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: _step == i ? const Color(0xFF1A237E) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickProfileImage,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: _profileImageBytes != null
                  ? MemoryImage(_profileImageBytes!)
                  : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                child: _profileImageBytes == null
                  ? const Icon(Icons.add_a_photo, color: Colors.white, size: 32)
                  : null,
              ),
              const SizedBox(height: 8),
              Text('Add Profile Picture', style: TextStyle(color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _firstNameController,
          hintText: 'First Name',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _lastNameController,
          hintText: 'Last Name',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _professionController,
          hintText: 'Profession',
          prefixIcon: Icons.work_outline,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _gender,
          dropdownColor: const Color(0xFF1A237E),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Gender',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.wc, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (val) => setState(() => _gender = val),
          validator: (val) => val == null ? 'Select gender' : null,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _nationalityController,
          hintText: 'Nationality',
          prefixIcon: Icons.flag_outlined,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _dobController,
          hintText: 'Date of Birth',
          prefixIcon: Icons.cake_outlined,
          keyboardType: TextInputType.datetime,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white70, size: 20),
            onPressed: () => _pickDate(context, _dobController),
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _phoneController,
          hintText: 'Phone',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _emailController,
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _addressController,
          hintText: 'Address',
          prefixIcon: Icons.location_on_outlined,
        ),
      ],
    );
  }

  Widget _buildWorkHistory() {
    return Column(
      children: [
        CustomTextField(
          controller: _employerController,
          hintText: 'Employer',
          prefixIcon: Icons.business_outlined,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _jobTitleController,
          hintText: 'Job Title',
          prefixIcon: Icons.work_outline,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _workStartController,
                hintText: 'Start Date',
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.datetime,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                  onPressed: () => _pickDate(context, _workStartController),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                controller: _workEndController,
                hintText: 'End Date',
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.datetime,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                  onPressed: () => _pickDate(context, _workEndController),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: _workCurrent,
              onChanged: (val) => setState(() => _workCurrent = val ?? false),
              activeColor: Colors.white,
              checkColor: const Color(0xFF1A237E),
            ),
            const Text('I currently work here', style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _workDescController,
          hintText: 'Add Description',
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buildEducation() {
    return Column(
      children: [
        CustomTextField(
          controller: _schoolController,
          hintText: 'School Name',
          prefixIcon: Icons.school_outlined,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _degreeController,
          hintText: 'Degree',
          prefixIcon: Icons.school,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _eduStartController,
                hintText: 'Start Date',
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.datetime,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                  onPressed: () => _pickDate(context, _eduStartController),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                controller: _eduEndController,
                hintText: 'End Date',
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.datetime,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                  onPressed: () => _pickDate(context, _eduEndController),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: _eduCurrent,
              onChanged: (val) => setState(() => _eduCurrent = val ?? false),
              activeColor: Colors.white,
              checkColor: const Color(0xFF1A237E),
            ),
            const Text('I currently attend here', style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _eduDescController,
          hintText: 'Add Description',
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }
} 