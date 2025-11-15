import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../app_widgets/app_toast.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observable user state
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
  }

  // Sign in with Email and Password
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      AppToast.showCustomToast(
        'Success',
        'Logged in successfully!',
        type: ToastType.success,
      );
      Get.offAllNamed(AppRoutes.dashboard);
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      AppToast.showCustomToast(
        'Error',
        message,
        type: ToastType.error,
      );
    } catch (e) {
      AppToast.showCustomToast(
        'Error',
        'Login failed: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up with Email, Name and Password
  Future<void> signUpWithEmailPassword(
    String email,
    String name,
    String password,
  ) async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name.trim());
      await userCredential.user?.reload();
      
      AppToast.showCustomToast(
        'Success',
        'Account created successfully!',
        type: ToastType.success,
      );
      Get.offAllNamed(AppRoutes.dashboard);
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      AppToast.showCustomToast(
        'Error',
        message,
        type: ToastType.error,
      );
    } catch (e) {
      AppToast.showCustomToast(
        'Error',
        'Sign up failed: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        isLoading.value = false;
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      await _auth.signInWithCredential(credential);
      
      AppToast.showCustomToast(
        'Success',
        'Signed in with Google!',
        type: ToastType.success,
      );
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      AppToast.showCustomToast(
        'Error',
        'Google sign in failed: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
      
      AppToast.showCustomToast(
        'Success',
        'Signed in with Apple!',
        type: ToastType.success,
      );
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      AppToast.showCustomToast(
        'Error',
        'Apple sign in failed: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      AppToast.showCustomToast(
        'Error',
        'Sign out failed: ${e.toString()}',
        type: ToastType.error,
      );
    }
  }

  // Continue as Guest
  void continueAsGuest() {
    Get.offAllNamed(AppRoutes.dashboard);
  }

  // Check if user is logged in
  bool get isLoggedIn => user.value != null;
  
  // Get user display name
  String get displayName => user.value?.displayName ?? 'Guest';
  
  // Get user email
  String get userEmail => user.value?.email ?? '';
}

