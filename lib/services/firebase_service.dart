import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref('UsersData');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Reference to userInfos node in the database
  DatabaseReference get userInfosRef => _database.child('userInfos');

  // Reference to userAuthData node in the database
  DatabaseReference get userAuthDataRef => _database.child('userAuthData');

  // Save profile data to Firebase Realtime Database
  Future<String> saveUserInfo(Map<String, dynamic> profileData) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }


    // Generate a unique key for this info entry
    final infoRef = userInfosRef.child(currentUserId!).push();
    final infoId = infoRef.key!;

    // Convert profile image to base64 if it exists
    if (profileData['profileImageBytes'] != null) {
      final Uint8List imageBytes = profileData['profileImageBytes'];
      final String base64Image = base64Encode(imageBytes);
      profileData['profileImageBase64'] = base64Image;
      profileData.remove(
          'profileImageBytes'); // Remove the bytes to avoid storage issues
    }

    // Organize data into sections
    final Map<String, dynamic> organizedData = {
      'personalInfo': {
        'fullName': profileData['fullName'] ?? '',
        'currentPosition': profileData['currentPosition'] ?? '',
        'street': profileData['street'] ?? '',
        'address': profileData['address'] ?? '',
        'country': profileData['country'] ?? '',
        'phoneNumber': profileData['phoneNumber'] ?? '',
        'email': profileData['email'] ?? '',
        'bio': profileData['bio'] ?? '',
        'profileImageBase64': profileData['profileImageBase64'],
      },
      'experience': profileData['experience'] ?? [],
      'educationDetails': profileData['educationDetails'] ?? [],
      'skills': profileData['languages'] ?? [],
      'hobbies': profileData['hobbies'] ?? [],
      'createdAt': ServerValue.timestamp,
      'updatedAt': ServerValue.timestamp,
    };

    // Save to database
    await infoRef.set(organizedData);
    return infoId;
  }

  // Update existing profile data
  Future<void> updateUserInfo(
      String infoId, Map<String, dynamic> profileData) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final infoRef = userInfosRef.child(currentUserId!).child(infoId);

    // Convert profile image to base64 if it exists
    if (profileData['profileImageBytes'] != null) {
      final Uint8List imageBytes = profileData['profileImageBytes'];
      final String base64Image = base64Encode(imageBytes);
      profileData['profileImageBase64'] = base64Image;
      profileData.remove(
          'profileImageBytes'); // Remove the bytes to avoid storage issues
    }

    // Organize data into sections
    final Map<String, dynamic> updates = {
      'personalInfo': {
        'fullName': profileData['fullName'] ?? '',
        'currentPosition': profileData['currentPosition'] ?? '',
        'street': profileData['street'] ?? '',
        'address': profileData['address'] ?? '',
        'country': profileData['country'] ?? '',
        'phoneNumber': profileData['phoneNumber'] ?? '',
        'email': profileData['email'] ?? '',
        'bio': profileData['bio'] ?? '',
      },
      'workExperience': profileData['experience'] ?? [],
      'educationDetails': profileData['educationDetails'] ?? [],
      'skills': profileData['languages'] ?? [],
      'hobbies': profileData['hobbies'] ?? [],
      'updatedAt': ServerValue.timestamp,
    };

    // Only update the image if a new one was provided
    if (profileData['profileImageBase64'] != null) {
      updates['personalInfo']['profileImageBase64'] =
          profileData['profileImageBase64'];
    }

    // Update in database
    await infoRef.update(updates);
  }

  // Delete a user info entry
  Future<void> deleteUserInfo(String infoId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await userInfosRef.child(currentUserId!).child(infoId).remove();
  }

  // Get all user info entries
  Future<List<Map<String, dynamic>>> getUserInfos() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await userInfosRef.child(currentUserId!).get();

    if (!snapshot.exists) {
      return [];
    }

    final List<Map<String, dynamic>> infoList = [];

    try {
      // Convert the database snapshot to a list of maps
      final dynamic snapshotValue = snapshot.value;

      if (snapshotValue is Map) {
        // Safely cast to Map<String, dynamic>
        Map<String, dynamic>.from(snapshotValue).forEach((key, value) {
          if (value is Map) {
            // Convert nested maps to proper Map<String, dynamic>
            final Map<String, dynamic> info = _convertToStringDynamicMap(value);

            // Extract personal info
            Map<String, dynamic> personalInfo = {};
            if (info['personalInfo'] is Map) {
              personalInfo = _convertToStringDynamicMap(info['personalInfo']);
            }

            // Convert base64 image back to bytes if it exists
            if (personalInfo['profileImageBase64'] != null) {
              try {
                final String base64Image =
                    personalInfo['profileImageBase64'].toString();
                final Uint8List imageBytes = base64Decode(base64Image);
                personalInfo['profileImageBytes'] = imageBytes;
                personalInfo
                    .remove('profileImageBase64'); // Remove the base64 string
              } catch (e) {
                print('Error decoding base64 image: $e');
              }
            }

            // Safely convert experience array
            List<Map<String, dynamic>> experience = [];
            if (info['experience'] is List) {
              experience = _convertToListOfMaps(info['experience']);
            }

            // Safely convert education array
            List<Map<String, dynamic>> educationDetails = [];
            if (info['educationDetails'] is List) {
              educationDetails = _convertToListOfMaps(info['educationDetails']);
            }

            // Safely convert skills array
            List<Map<String, dynamic>> skills = [];
            if (info['skills'] is List) {
              skills = _convertToListOfMaps(info['skills']);
            }

            // Safely convert hobbies array
            List<String> hobbies = [];
            if (info['hobbies'] is List) {
              hobbies = (info['hobbies'] as List)
                  .map((item) => item.toString())
                  .toList();
            }

            // Create a flattened map for the UI
            final Map<String, dynamic> flattenedInfo = {
              ...personalInfo,
              'experience': experience,
              'educationDetails': educationDetails,
              'languages': skills,
              'hobbies': hobbies,
              'infoId': key, // Store the Firebase key for later use
            };

            infoList.add(flattenedInfo);
          }
        });
      }
    } catch (e) {
      print('Error parsing Firebase data: $e');
    }

    return infoList;
  }

  // Helper method to safely convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _convertToStringDynamicMap(Map map) {
    return map.map((key, value) {
      // Convert the key to string
      final String keyStr = key.toString();

      // Handle different value types
      if (value is Map) {
        return MapEntry(keyStr, _convertToStringDynamicMap(value));
      } else if (value is List) {
        return MapEntry(keyStr, _convertToListOfMaps(value));
      } else {
        return MapEntry(keyStr, value);
      }
    });
  }

  // Helper method to safely convert List to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _convertToListOfMaps(List list) {
    List<Map<String, dynamic>> result = [];

    for (var item in list) {
      if (item is Map) {
        result.add(_convertToStringDynamicMap(item));
      }
    }

    return result;
  }
}
