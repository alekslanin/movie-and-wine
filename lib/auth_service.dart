
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logger/logger.dart';

final authStateProvider = ChangeNotifierProvider<AuthState>(
   (ref) => AuthState(),
);

class AuthState extends ChangeNotifier {
  static final AuthState _instance = AuthState._internal();

  AuthState._internal();

  factory AuthState() {
    return _instance;
  }

  bool _isUserLoggedIn = false;

  bool isUserLoggedIn () => _isUserLoggedIn;

  void set(bool status) {
    _isUserLoggedIn = status;
    Logger().i('notify LOGGIN STATUS as $_isUserLoggedIn');
    notifyListeners();
  }
}

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  AuthService() {
    _initialize();
  }

  void _initialize() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        AuthState().set(false);
        Logger().i('User is currently signed out!');
      } else {
        AuthState().set(true);
        Logger().i('User is signed in!');
      }
    });
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthState().set(true);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      AuthState().set(false);
      throw Exception(e.message);
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  } 

  Future<void> signOut() async {
    AuthState().set(false);
    await _auth.signOut();
  }

  Future <void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  } 

  Future<void> deleteAccount(String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: password, // You should securely get the user's password
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updatePasswordWithReauth(String currentPassword, String newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: currentPassword,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  } 

}