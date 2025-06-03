import 'package:craftfolio/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
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
        try {
          if (d['profileImageBytes'] is Uint8List) {
            _profileImageBytes = d['profileImageBytes'];
          } else if (d['profileImageBytes'] is String) {
            _profileImageBytes = base64Decode(d['profileImageBytes']);
          }
        } catch (e) {
          print('Error setting profile image: $e');
          _profileImageBytes = null;
        }
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
    print('Notifying parent of personal details changes');
    
    // Ensure current position is not empty
    final currentPosition = _currentPositionController.text.trim();
    
    // Create the data map
    final Map<String, dynamic> data = {
      'fullName': _fullNameController.text,
      'currentPosition': currentPosition.isNotEmpty ? currentPosition : 'No profession added',
      'street': _streetController.text,
      'address': _addressController.text,
      'country': _countryController.text,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
    };
    
    // Add image data if available
    if (_profileImageBytes != null) {
      print('Adding image data to notification (${_profileImageBytes!.length} bytes)');
      data['profileImageBytes'] = _profileImageBytes;
    } else {
      print('No image data to add to notification');
    }
    
    print('Notifying with data keys: ${data.keys}');
    widget.onDataChanged(data);
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Limit image size
        maxHeight: 800,
        imageQuality: 85, // Compress quality
      );
      
      if (picked != null) {
        print('Image picked from gallery: ${picked.path}');
        final bytes = await picked.readAsBytes();
        print('Image read successfully. Original byte length: ${bytes.length}');
        
        // Store image data
        setState(() {
          _profileImageBytes = Uint8List.fromList(bytes); // Create a new copy
        });
        
        // Verify the image data
        if (_profileImageBytes != null) {
          print('Image stored in state. Byte length: ${_profileImageBytes!.length}');
          
          try {
            // Test base64 conversion
            final base64Test = base64Encode(_profileImageBytes!);
            print('Test base64 conversion successful (${base64Test.length} chars)');
            
            // Ensure image can be displayed
            await precacheImage(MemoryImage(_profileImageBytes!), context);
            print('Image successfully cached for display');
            
            // Create a new notification with the image data
            print('Preparing to notify parent with image data...');
            _notifyParent();
            
          } catch (conversionError) {
            print('Error in image conversion/caching: $conversionError');
            throw Exception('Failed to process image data: $conversionError');
          }
        } else {
          throw Exception('Failed to store image data in state');
        }
      } else {
        print('No image picked from gallery');
      }
    } catch (e) {
      print('Error in image picking process: $e');
      setState(() {
        _profileImageBytes = null; // Clear invalid image data
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
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
            hintText: 'Current Position (e.g. Software Engineer)',
            prefixIcon: Icons.work_outline,
            validator: (val) => val!.isEmpty ? 'Please enter your current position' : null,
            onChanged: (val) => _notifyParent(),
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
