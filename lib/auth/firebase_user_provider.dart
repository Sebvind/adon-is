import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AdonIsFirebaseUser {
  AdonIsFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

AdonIsFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<AdonIsFirebaseUser> adonIsFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<AdonIsFirebaseUser>(
      (user) {
        currentUser = AdonIsFirebaseUser(user);
        return currentUser!;
      },
    );
