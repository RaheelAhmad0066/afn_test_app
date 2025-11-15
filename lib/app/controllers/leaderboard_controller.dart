import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/leaderboard_model.dart';
import '../app_widgets/app_toast.dart';

/// Leaderboard Controller
class LeaderboardController extends GetxController {
  DatabaseReference? _databaseRef;
  
  DatabaseReference? get databaseRef {
    if (_databaseRef == null) {
      try {
        if (Firebase.apps.isNotEmpty) {
          _databaseRef = FirebaseDatabase.instance.ref();
        } else {
          print('Firebase apps is empty');
          return null;
        }
      } catch (e) {
        print('Firebase Database not initialized: $e');
        return null;
      }
    }
    return _databaseRef;
  }
  
  bool get isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty && databaseRef != null;
    } catch (e) {
      print('Firebase availability check failed: $e');
      return false;
    }
  }

  // Observable Lists
  final RxList<LeaderboardModel> allTimeLeaderboard = <LeaderboardModel>[].obs;
  final RxList<LeaderboardModel> weeklyLeaderboard = <LeaderboardModel>[].obs;
  
  // Selected View
  final RxBool isWeeklyView = true.obs;
  
  // Loading States
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  /// Toggle between Weekly and All Time
  void toggleView(bool isWeekly) {
    isWeeklyView.value = isWeekly;
  }

  /// Get current leaderboard based on view
  List<LeaderboardModel> get currentLeaderboard {
    return isWeeklyView.value ? weeklyLeaderboard : allTimeLeaderboard;
  }

  /// Get top 3 players - reordered for podium (2nd, 1st, 3rd)
  List<LeaderboardModel> get topThree {
    final list = currentLeaderboard.take(3).toList();
    
    if (list.isEmpty) return [];
    if (list.length == 1) return [list[0]]; // Just 1st
    if (list.length == 2) return [list[1], list[0]]; // 2nd, 1st
    
    // 3 or more: return [2nd, 1st, 3rd]
    return [list[1], list[0], list[2]];
  }

  /// Load leaderboard from Firebase
  Future<void> loadLeaderboard() async {
    if (!isFirebaseAvailable) {
      print('Firebase not available, skipping leaderboard load');
      isLoading.value = false;
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Load all time leaderboard
      await _loadAllTimeLeaderboard();
      
      // Load weekly leaderboard
      await _loadWeeklyLeaderboard();
      
    } catch (e) {
      print('Error loading leaderboard: $e');
      if (Firebase.apps.isNotEmpty) {
        AppToast.showError('Failed to load leaderboard');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all time leaderboard - sorted by total points
  Future<void> _loadAllTimeLeaderboard() async {
    try {
      final ref = databaseRef;
      if (ref == null) {
        print('Database reference is null');
        allTimeLeaderboard.clear();
        return;
      }
      
      final snapshot = await ref.child('leaderboard').child('allTime').get();
      
      if (snapshot.exists) {
        final snapshotValue = snapshot.value;
        if (snapshotValue is Map<dynamic, dynamic>) {
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          
          allTimeLeaderboard.value = snapshotValue.entries.map((entry) {
            return LeaderboardModel.fromJson(
              Map<String, dynamic>.from(entry.value),
              entry.key.toString(),
              currentUserId: currentUserId,
            );
          }).toList();
          
          // Sort by total points (descending)
          allTimeLeaderboard.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
        }
      } else {
        allTimeLeaderboard.clear();
      }
    } catch (e) {
      print('Error loading all time leaderboard: $e');
      allTimeLeaderboard.clear();
    }
  }

  /// Load weekly leaderboard - only includes scores from current week
  Future<void> _loadWeeklyLeaderboard() async {
    try {
      final ref = databaseRef;
      if (ref == null) {
        print('Database reference is null');
        weeklyLeaderboard.clear();
        return;
      }
      
      final now = DateTime.now();
      // Calculate week start (Monday of current week)
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartTimestamp = weekStart.millisecondsSinceEpoch;
      
      final snapshot = await ref.child('leaderboard').child('weekly').get();
      
      if (snapshot.exists) {
        final snapshotValue = snapshot.value;
        if (snapshotValue is Map<dynamic, dynamic>) {
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          
          weeklyLeaderboard.value = snapshotValue.entries
              .where((entry) {
                final data = entry.value as Map<dynamic, dynamic>?;
                if (data == null) return false;
                final lastUpdated = data['lastUpdated'] as int?;
                if (lastUpdated == null) return false;
                // Only include entries updated in current week
                return lastUpdated >= weekStartTimestamp;
              })
              .map((entry) {
                return LeaderboardModel.fromJson(
                  Map<String, dynamic>.from(entry.value),
                  entry.key.toString(),
                  currentUserId: currentUserId,
                );
              })
              .toList();
          
          // Sort by total points (descending)
          weeklyLeaderboard.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
        }
      } else {
        weeklyLeaderboard.clear();
      }
    } catch (e) {
      print('Error loading weekly leaderboard: $e');
      weeklyLeaderboard.clear();
    }
  }

  /// Update user score after completing a test
  Future<void> updateUserScore({
    required int points,
    required bool testPassed,
  }) async {
    if (!isFirebaseAvailable) {
      print('Firebase not available, cannot update score');
      return;
    }
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in, cannot update score');
      return;
    }
    
    try {
      final userId = user.uid;
      final userName = user.displayName ?? 'User';
      final userEmail = user.email ?? '';
      final userAvatar = user.photoURL;
      
      // Update all time leaderboard
      await _updateScore(
        path: 'leaderboard/allTime/$userId',
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        userAvatar: userAvatar,
        points: points,
        testPassed: testPassed,
      );
      
      // Update weekly leaderboard
      await _updateScore(
        path: 'leaderboard/weekly/$userId',
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        userAvatar: userAvatar,
        points: points,
        testPassed: testPassed,
      );
      
      // Reload leaderboard to update rankings
      await loadLeaderboard();
      
    } catch (e) {
      print('Error updating user score: $e');
    }
  }

  /// Update score at specific path
  Future<void> _updateScore({
    required String path,
    required String userId,
    required String userName,
    required String userEmail,
    String? userAvatar,
    required int points,
    required bool testPassed,
  }) async {
    try {
      final dbRef = databaseRef;
      if (dbRef == null) {
        print('Database reference is null, cannot update score');
        return;
      }
      
      final ref = dbRef.child(path);
      final snapshot = await ref.get();
      
      if (snapshot.exists) {
        // User exists, update their score
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final currentPoints = (data['totalPoints'] ?? 0) as int;
        final testsCompleted = (data['testsCompleted'] ?? 0) as int;
        
        await ref.update({
          'totalPoints': testPassed ? currentPoints + points : currentPoints,
          'testsCompleted': testsCompleted + 1,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        // New user, create entry
        await ref.set({
          'userName': userName,
          'userEmail': userEmail,
          'userAvatar': userAvatar,
          'totalPoints': testPassed ? points : 0,
          'testsCompleted': 1,
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      print('Error updating score at $path: $e');
    }
  }
}