
import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';
class SignInUsecase {
  AuthRepository authRepository;
  SignInUsecase({required this.authRepository});

  
  Future<void> call(String email, String password) async {
    return await authRepository.signIn(email: email, password: password);
  }


}