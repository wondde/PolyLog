import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../diary/domain/models.dart';

/// 인증 Repository
class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  /// 현재 사용자 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 현재 사용자
  User? get currentUser => _auth.currentUser;

  /// Google 로그인
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // 신규 사용자인 경우 기본 문서 생성
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _createUserDocument(user);
        }
      }

      return user;
    } catch (e) {
      throw Exception('Google 로그인 실패: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// 사용자 문서 생성
  Future<void> _createUserDocument(User user) async {
    final userModel = UserModel(
      uid: user.uid,
      displayName: user.displayName ?? 'User',
      region: 'kr',
      nativeLang: 'ko',
      learnLangs: [],
      level: {},
      prefs: const UserPreferences(),
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toFirestore());
  }

  /// 사용자 설정 업데이트
  Future<void> updateUserPreferences(Map<String, dynamic> newPrefs) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    await _firestore.collection('users').doc(uid).update({
      'prefs': newPrefs,
    });
  }

  /// 학습 언어 목록 업데이트
  Future<void> updateLearningLanguages(List<String> learnLangs) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    await _firestore.collection('users').doc(uid).update({
      'learnLangs': learnLangs,
    });
  }

  /// 주간 목표 학습량 업데이트
  Future<void> updateWeeklyGoal(int weeklyGoal) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    await _firestore.collection('users').doc(uid).update({
      'weeklyGoal': weeklyGoal,
    });
  }

  /// 사용자 문서 조회
  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// 사용자 문서 스트림
  Stream<UserModel?> userDocumentStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// 사용자 문서 업데이트
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  /// Onboarding 완료 (레벨 및 학습 언어 설정)
  Future<void> completeOnboarding({
    required String uid,
    required String nativeLang,
    required List<String> learnLangs,
    required Map<String, String> level,
    required UserPreferences prefs,
    int weeklyGoal = 7,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'nativeLang': nativeLang,
      'learnLangs': learnLangs,
      'level': level,
      'prefs': prefs.toMap(),
      'weeklyGoal': weeklyGoal,
    });
  }
}
