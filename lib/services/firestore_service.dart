import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import '../models/user_profile.dart';
import '../models/skin_analysis.dart';

/// All reads/writes to Cloud Firestore go through this class.
///
/// Firestore structure:
///   users/{uid}                    — profile document
///   users/{uid}/analyses/{id}      — SkinAnalysis records
///   users/{uid}/routine_logs/{date}— daily routine + water intake
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── User profile ───────────────────────────────────────────────────────────

  static Future<void> saveUserProfile(
      String uid, UserProfile profile, String email) async {
    await _db.collection('users').doc(uid).set({
      'name': profile.name,
      'email': email,
      'dateOfBirth': profile.dateOfBirth.toIso8601String(),
      'skinType': profile.skinType,
      'skinConcerns': profile.skinConcerns,
      'location': profile.location,
      'climate': profile.climate,
      'waterIntake': profile.waterIntake,
      'sleepHours': profile.sleepHours,
      'isOnboarded': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  static Future<void> saveProfileImageUrl(String uid, String url) async {
    await _db.collection('users').doc(uid).set(
      {'profileImageUrl': url, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  static Future<void> setOnboarded(String uid) async {
    await _db.collection('users').doc(uid).set(
      {'isOnboarded': true, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  // ── Skin analyses ──────────────────────────────────────────────────────────

  static Future<void> saveSkinAnalysis(
      String uid, SkinAnalysis analysis) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('analyses')
        .add({
      'skinScore': analysis.skinScore,
      'concerns': analysis.concerns,
      'skinTone': analysis.skinTone,
      'recommendations': analysis.recommendations,
      'suggestedIngredients': analysis.suggestedIngredients,
      'analyzedAt': Timestamp.fromDate(analysis.analyzedAt),
    });
    await _db.collection('users').doc(uid).update({
      'latestSkinScore': analysis.skinScore,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Map<String, dynamic>>> getSkinAnalyses(
      String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('analyses')
        .orderBy('analyzedAt', descending: true)
        .limit(14)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // ── Routine & water logs ───────────────────────────────────────────────────

  static String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  static Future<void> saveRoutineLog(
      String uid, Map<String, bool> checks, int waterGlasses) async {
    final date = _dateKey(DateTime.now());
    await _db
        .collection('users')
        .doc(uid)
        .collection('routine_logs')
        .doc(date)
        .set({
      'checks': checks,
      'waterGlasses': waterGlasses,
      'date': date,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getTodayRoutineLog(
      String uid) async {
    final date = _dateKey(DateTime.now());
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('routine_logs')
        .doc(date)
        .get();
    return doc.exists ? doc.data() : null;
  }

  // ── Favourites ─────────────────────────────────────────────────────────────

  static Future<void> saveFavorites(
      String uid, Set<String> favoriteIds) async {
    await _db.collection('users').doc(uid).update({
      'favorites': favoriteIds.toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<String>> getFavorites(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return [];
    return List<String>.from(doc.data()?['favorites'] ?? []);
  }

  // ── Chat history ───────────────────────────────────────────────────────────

  static Future<void> saveChatMessage(
      String uid, ChatMessage message) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('chat_logs')
        .add({
      'text': message.text,
      'isUser': message.isUser,
      'timestamp': Timestamp.fromDate(message.timestamp),
      'quickReplies': message.quickReplies,
    });
  }

  static Future<List<Map<String, dynamic>>> getChatHistory(
      String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('chat_logs')
        .orderBy('timestamp', descending: false)
        .limit(50)
        .get();
    return snap.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      // Convert Timestamp → ISO string so the provider needs no Firestore import.
      if (data['timestamp'] is Timestamp) {
        data['timestamp'] =
            (data['timestamp'] as Timestamp).toDate().toIso8601String();
      }
      return data;
    }).toList();
  }
}
