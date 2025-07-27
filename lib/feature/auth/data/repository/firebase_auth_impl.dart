

import 'package:missionland_app/feature/auth/data/data_source_api/firebase_auth_api.dart';
import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';

class FirebaseAuthImpl implements AuthRepository {
  final FirebaseAuthApi firebaseAuthApi;
  FirebaseAuthImpl({required this.firebaseAuthApi});

  @override
  Future<void> signUp({required String email, required String password}) async {
    await firebaseAuthApi.signUp(email, password);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await firebaseAuthApi.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuthApi.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return await firebaseAuthApi.isSignedIn();
  }


    
  }
  


  

