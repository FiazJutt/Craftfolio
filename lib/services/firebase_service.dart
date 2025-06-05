/// with comments
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
      profileData.remove('profileImageBytes');
    }

    // DEBUG: Check hobbies before saving
    print('Hobbies before organizing: ${profileData['hobbies']}');
    print('Hobbies type: ${profileData['hobbies'].runtimeType}');

    // Organize data into sections with CORRECT field mapping
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
      'skills': profileData['languages'] ?? [], // Skills/Languages
      'hobbies': profileData['hobbies'] ?? [], // Hobbies saved as List<String>
      'createdAt': ServerValue.timestamp,
      'updatedAt': ServerValue.timestamp,
    };

    print('Organized hobbies data: ${organizedData['hobbies']}');

    // Save to database
    await infoRef.set(organizedData);
    return infoId;
  }

  // Update existing profile data
  Future<void> updateUserInfo(String infoId, Map<String, dynamic> profileData) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final infoRef = userInfosRef.child(currentUserId!).child(infoId);

    // Convert profile image to base64 if it exists
    if (profileData['profileImageBytes'] != null) {
      final Uint8List imageBytes = profileData['profileImageBytes'];
      final String base64Image = base64Encode(imageBytes);
      profileData['profileImageBase64'] = base64Image;
      profileData.remove('profileImageBytes');
    }

    // Organize data into sections with CORRECT field mapping
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
      'experience': profileData['experience'] ?? [],
      'educationDetails': profileData['educationDetails'] ?? [],
      'skills': profileData['languages'] ?? [],
      'hobbies': profileData['hobbies'] ?? [], // Hobbies updated as List<String>
      'updatedAt': ServerValue.timestamp,
    };

    // Only update the image if a new one was provided
    if (profileData['profileImageBase64'] != null) {
      updates['personalInfo']['profileImageBase64'] = profileData['profileImageBase64'];
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
      final dynamic snapshotValue = snapshot.value;

      if (snapshotValue is Map) {
        Map<String, dynamic>.from(snapshotValue).forEach((key, value) {
          if (value is Map) {
            /*
             * PROBLEM: The original code was calling _convertToStringDynamicMap(value) first,
             * which would process ALL fields including hobbies through the helper methods.
             * This caused hobbies (which are strings) to be incorrectly processed by
             * _convertToListOfMaps(), resulting in empty Map objects instead of strings.
             */
            final Map<String, dynamic> info = _convertToStringDynamicMap(value);

            // Extract personal info
            Map<String, dynamic> personalInfo = {};
            if (info['personalInfo'] is Map) {
              personalInfo = _convertToStringDynamicMap(info['personalInfo']);
            }

            // Convert base64 image back to bytes if it exists
            if (personalInfo['profileImageBase64'] != null) {
              try {
                final String base64Image = personalInfo['profileImageBase64'].toString();
                final Uint8List imageBytes = base64Decode(base64Image);
                personalInfo['profileImageBytes'] = imageBytes;
                personalInfo.remove('profileImageBase64');
              } catch (e) {
                print('Error decoding base64 image: $e');
              }
            }

            // Safely convert experience array (these are objects/maps)
            List<Map<String, dynamic>> experience = [];
            if (info['experience'] is List) {
              experience = _convertToListOfMaps(info['experience']);
            }

            // Safely convert education array (these are objects/maps)
            List<Map<String, dynamic>> educationDetails = [];
            if (info['educationDetails'] is List) {
              educationDetails = _convertToListOfMaps(info['educationDetails']);
            }

            // Safely convert skills array (these are objects/maps)
            List<Map<String, dynamic>> skills = [];
            if (info['skills'] is List) {
              skills = _convertToListOfMaps(info['skills']);
            }

            /*
             * FIX: Instead of using the processed 'info['hobbies']' which has been corrupted
             * by _convertToStringDynamicMap, we get the raw hobbies data directly from the
             * original Firebase value BEFORE any processing occurs.
             *
             * FIREBASE BEHAVIOR: When you save List<String> to Firebase Realtime Database,
             * Firebase sometimes converts it to a Map with numeric indices:
             *
             * Saved as: ["Cricket", "Hello"]
             * Retrieved as: {0: "Cricket", 1: "Hello"}
             *
             * This is why we need to handle both List and Map formats.
             */
            List<String> hobbies = [];
            final rawHobbiesData = value['hobbies']; // Get raw data directly from Firebase

            print('Raw hobbies data from Firebase: $rawHobbiesData');
            print('Hobbies data type: ${rawHobbiesData.runtimeType}');

            if (rawHobbiesData != null) {
              if (rawHobbiesData is List) {
                print('Processing hobbies as List');
                // Handle normal List format: ["Cricket", "Hello"]
                hobbies = rawHobbiesData
                    .map((item) => item.toString())
                    .where((item) => item.isNotEmpty)
                    .toList();
              } else if (rawHobbiesData is Map) {
                print('Processing hobbies as Map');
                /*
                 * Handle Firebase's Map conversion: {0: "Cricket", 1: "Hello"}
                 * We need to:
                 * 1. Convert to proper Map<String, dynamic>
                 * 2. Sort keys numerically to maintain order
                 * 3. Extract values as strings
                 */
                final Map<String, dynamic> hobbiesMap = Map<String, dynamic>.from(rawHobbiesData);
                print('Hobbies map: $hobbiesMap');

                // Sort keys numerically to maintain original order (0, 1, 2, etc.)
                final sortedKeys = hobbiesMap.keys.toList()
                  ..sort((a, b) {
                    final aNum = int.tryParse(a.toString()) ?? 0;
                    final bNum = int.tryParse(b.toString()) ?? 0;
                    return aNum.compareTo(bNum);
                  });

                print('Sorted keys: $sortedKeys');

                // Extract values in correct order and convert to strings
                hobbies = sortedKeys
                    .map((key) => hobbiesMap[key].toString())
                    .where((item) => item.isNotEmpty)
                    .toList();
              } else {
                print('Hobbies is neither List nor Map: ${rawHobbiesData.runtimeType}');
              }
            } else {
              print('Hobbies is null');
            }

            print('Final processed hobbies are: $hobbies');

            // Create a flattened map for the UI
            final Map<String, dynamic> flattenedInfo = {
              ...personalInfo,
              'experience': experience,
              'educationDetails': educationDetails,
              'languages': skills,
              'hobbies': hobbies, // Now correctly contains List<String>
              'infoId': key,
            };

            infoList.add(flattenedInfo);
          }
        });
      }
    } catch (e) {
      print('Error parsing Firebase data: $e');
      print('Stack trace: ${StackTrace.current}');
    }

    return infoList;
  }

  /*
   * UPDATED HELPER METHOD: Added special handling for hobbies field
   *
   * THE PROBLEM: This method was being called recursively on all fields,
   * including hobbies. When it encountered a List (like hobbies), it would
   * call _convertToListOfMaps(), which assumes the list contains Map objects.
   * But hobbies contains strings, not maps, so this corrupted the data.
   *
   * THE FIX: We now skip processing hobbies in this method and handle them
   * separately in getUserInfos() where we can treat them as strings.
   */
  Map<String, dynamic> _convertToStringDynamicMap(Map map) {
    return map.map((key, value) {
      final String keyStr = key.toString();

      // CRITICAL FIX: Skip processing hobbies here to prevent data corruption
      if (keyStr == 'hobbies') {
        return MapEntry(keyStr, value); // Keep original value unchanged
      }

      if (value is Map) {
        // Recursively process nested maps (like personalInfo)
        return MapEntry(keyStr, _convertToStringDynamicMap(value));
      } else if (value is List && keyStr != 'hobbies') {
        // Process lists that contain maps (like experience, education, skills)
        // but NOT hobbies which contains strings
        return MapEntry(keyStr, _convertToListOfMaps(value));
      } else {
        // For all other data types, keep as-is
        return MapEntry(keyStr, value);
      }
    });
  }

  /*
   * Helper method to safely convert List to List<Map<String, dynamic>>
   * This is used for experience, education, and skills which are arrays of objects,
   * but NOT for hobbies which is an array of strings.
   */
  List<Map<String, dynamic>> _convertToListOfMaps(List list) {
    List<Map<String, dynamic>> result = [];

    for (var item in list) {
      if (item is Map) {
        result.add(_convertToStringDynamicMap(item));
      }
      // Note: We only add Map items, ignoring non-Map items
      // This is why hobbies (strings) were getting lost when processed here
    }

    return result;
  }
}

/*
 * SUMMARY OF THE ISSUE AND FIX:
 *
 * ISSUE:
 * 1. Hobbies are stored as List<String> in your app: ["Cricket", "Hello"]
 * 2. Firebase sometimes converts arrays to Maps: {0: "Cricket", 1: "Hello"}
 * 3. The _convertToStringDynamicMap helper method was processing ALL fields
 * 4. When it found hobbies (a List), it called _convertToListOfMaps()
 * 5. _convertToListOfMaps() expects Map objects, but hobbies contains strings
 * 6. So hobbies strings were ignored/lost, resulting in empty arrays
 *
 * FIX:
 * 1. Added special handling in _convertToStringDynamicMap to skip hobbies
 * 2. In getUserInfos(), we now get hobbies directly from raw Firebase data
 * 3. We handle both List and Map formats that Firebase might return
 * 4. We properly convert Map indices back to ordered List<String>
 *
 * WHY OTHER FIELDS WORK:
 * Experience, education, and skills contain objects/maps like:
 * [{"title": "Job", "company": "ABC"}, {"title": "Job2", "company": "XYZ"}]
 * So _convertToListOfMaps() works correctly for them.
 *
 * But hobbies contains simple strings: ["Cricket", "Hello"]
 * So they need different handling.
 */


/*
* ## Summary of the Problem and Solution

### **The Issue:**

1. **Data Type Mismatch**: Your hobbies are stored as `List<String>` (e.g., `["Cricket", "Hello"]`), while other fields like experience, education, and skills are stored as `List<Map<String, dynamic>>` (arrays of objects).

2. **Firebase Conversion**: Firebase Realtime Database sometimes converts arrays to Maps with numeric indices. So `["Cricket", "Hello"]` becomes `{0: "Cricket", 1: "Hello"}`.

3. **Wrong Processing**: The original code used a generic helper method `_convertToStringDynamicMap()` that processed ALL fields uniformly. When it encountered hobbies (a List), it called `_convertToListOfMaps()`.

4. **Data Loss**: `_convertToListOfMaps()` expects the list to contain Map objects, but hobbies contains strings. Since strings aren't Maps, they were ignored, resulting in empty arrays.

### **The Fix:**

1. **Special Handling**: Added a condition in `_convertToStringDynamicMap()` to skip processing hobbies, keeping the raw data intact.

2. **Direct Access**: In `getUserInfos()`, we now get hobbies directly from the raw Firebase data (`value['hobbies']`) before any processing occurs.

3. **Dual Format Support**: Handle both List format (`["Cricket", "Hello"]`) and Map format (`{0: "Cricket", 1: "Hello"}`) that Firebase might return.

4. **Proper Conversion**: When hobbies come as a Map, we sort the numeric keys and extract values to recreate the original string array.

### **Why Other Fields Worked:**

- **Experience/Education/Skills**: These contain objects like `[{"title": "Job", "company": "ABC"}]`, so `_convertToListOfMaps()` works correctly for them.
- **Hobbies**: These contain simple strings `["Cricket", "Hello"]`, requiring different handling.

This fix ensures hobbies are processed correctly while maintaining the existing functionality for other data types.
*/
