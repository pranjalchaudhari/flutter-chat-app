import 'package:bottle_chat/modals/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser _userFromFirebase(User user){
    return user != null ? AppUser(userId: user.uid) : null;
  }
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCred.user;
      return _userFromFirebase(user);
    }catch(e){
      print(e);
    }
  }
  Future createUserWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCred.user;
      return _userFromFirebase(user);
    }catch(e){
      print(e);
    }
  }
  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e);
    }
  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}