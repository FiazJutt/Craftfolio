import 'package:craftfolio/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class PersonalDetailsSection extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const PersonalDetailsSection({
    Key? key,
    this.initialData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<PersonalDetailsSection> createState() => _PersonalDetailsSectionState();
}

class _PersonalDetailsSectionState extends State<PersonalDetailsSection> {
  // Personal details controllers
  final _fullNameController = TextEditingController();
  final _currentPositionController = TextEditingController();
  final _streetController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController(); // About Me section

  // Profile image
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final d = widget.initialData!;

      // Personal details
      _fullNameController.text = d['fullName'] ?? '';
      _currentPositionController.text = d['currentPosition'] ?? '';
      _streetController.text = d['street'] ?? '';
      _addressController.text = d['address'] ?? '';
      _countryController.text = d['country'] ?? '';
      _phoneController.text = d['phoneNumber'] ?? '';
      _emailController.text = d['email'] ?? '';
      _bioController.text = d['bio'] ?? '';

      // Profile image
      if (d['profileImageBytes'] != null) {
        _profileImageBytes = d['profileImageBytes'];
      }
    }

    // Add listeners to update parent when data changes
    _fullNameController.addListener(_notifyParent);
    _currentPositionController.addListener(_notifyParent);
    _streetController.addListener(_notifyParent);
    _addressController.addListener(_notifyParent);
    _countryController.addListener(_notifyParent);
    _phoneController.addListener(_notifyParent);
    _emailController.addListener(_notifyParent);
    _bioController.addListener(_notifyParent);
  }

  void _notifyParent() {
    widget.onDataChanged({
      'fullName': _fullNameController.text,
      'currentPosition': _currentPositionController.text,
      'street': _streetController.text,
      'address': _addressController.text,
      'country': _countryController.text,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
      'profileImageBytes': _profileImageBytes,
    });
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    if (kIsWeb) {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
          _notifyParent();
        });
      }
    } else {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
          _notifyParent();
        });
      }
    }
  }

  @override
  void dispose() {
    // Personal details
    _fullNameController.dispose();
    _currentPositionController.dispose();
    _streetController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Profile image
          Center(
            child: GestureDetector(
              onTap: _pickProfileImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  image: _profileImageBytes != null
                      ? DecorationImage(
                    image: MemoryImage(_profileImageBytes!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _profileImageBytes == null
                    ? const Icon(Icons.add_a_photo, color: Colors.white, size: 40)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name and position
          CustomTextField(
            controller: _fullNameController,
            hintText: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _currentPositionController,
            hintText: 'Current Position',
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: 12),
          // About Me (Bio)
          CustomTextField(
            controller: _bioController,
            hintText: 'About Me',
            prefixIcon: Icons.description_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          // Contact information
          const Text(
            'Contact Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _streetController,
            hintText: 'Street',
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _addressController,
            hintText: 'City, State, Zip',
            prefixIcon: Icons.location_city_outlined,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _countryController,
            hintText: 'Country',
            prefixIcon: Icons.public,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _phoneController,
            hintText: 'Phone Number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _emailController,
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (val) => val!.isEmpty || !val.contains('@')
                ? 'Please enter a valid email'
                : null,
          ),
        ],
      ),
    );
  }
}
